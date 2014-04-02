require 'digest/sha1'
require 'tmpdir'

# Pure ruby UUID generator, which is compatible with RFC4122

class BetterUUID
  module StateFile
    extend self

    FILENAME = 'better-uuid.ruby.marshall'

    def update(clock = nil, mac_addr = nil)
      result = change_state(clock, mac_addr)
      start_background_writer
      result
    end

  private
    def start_background_writer
      $_better_uuid_background_writer ||= Thread.new { background_writer }
    end

    def background_write
      if $_better_uuid_background_writer_state_dirty
        open(filename, 'wb') { |fp|
          fp.flock IO::LOCK_EX
          write fp
        }
        $_better_uuid_background_writer_state_dirty = false
      end
    rescue Errno::EACCES, Errno::ENOENT, Errno::ENOSPC
    end

    def background_writer
      $_better_uuid_background_writer_state_dirty ||= false
      at_exit { background_write }
      loop do
        background_write
        sleep 3
      end
    end

    def pseudo_mac
      # Generate a pseudo MAC address because we have no pure-ruby way
      # to know  the MAC  address of the  NIC this system  uses.  Note
      # that cheating  with pseudo arresses here  is completely legal:
      # see Section 4.5 of RFC4122 for details.
      sha1 = Digest::SHA1.new
      256.times do
        r = [rand(0x100000000)].pack 'N'
        sha1.update r
      end
      str = sha1.digest
      r = rand 14 # 20-6
      node = str[r, 6] || str
      if RUBY_VERSION >= '1.9.0'
        nnode = node.bytes.to_a
        nnode[0] |= 0x01
        node = ''
        nnode.each { |s| node << s.chr }
      else
        node[0] |= 0x01 # multicast bit
      end
      node
    end

    def default_initial_state
      [ rand(0x40000), pseudo_mac ]
    end

    def initial_state
      begin
        open(filename, 'rb') { |fp|
          fp.flock IO::LOCK_EX
          read fp
        }
      rescue Errno::EACCES, Errno::ENOENT, ArgumentError
        default_initial_state
      end
    end

    def next_state(clock = nil, mac_addr = nil)
      $_better_uuid_background_writer_state_dirty = true
      c = clock ? (clock % 0x4000) : @c
      m = mac_addr ? mac_addr : @m
      c = c.succ
      [ c, m ]
    end

    def change_state(clock, mac_addr)
      @c, @m = if instance_variable_defined?(:@_better_uuid_initialized)
        next_state(clock, mac_addr)
      else
        @_better_uuid_initialized = true
        initial_state
      end
    end

    def read(fp)       # :nodoc:
      Marshal.load fp.read
    end

    def filename
      File.join(Dir.tmpdir, FILENAME)
    end

    def write(fp)  # :nodoc:
      fp.write Marshal.dump([@c, @m])
    end
  end
end
