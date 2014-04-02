### https://raw.githubusercontent.com/spectra/ruby-uuid/master/uuid.rb
### original http://mput.dip.jp/mput/uuid.txt

# Copyright(c) 2005 URABE, Shyouhei.
#
# Permission is hereby granted, free of  charge, to any person obtaining a copy
# of  this code, to  deal in  the code  without restriction,  including without
# limitation  the rights  to  use, copy,  modify,  merge, publish,  distribute,
# sublicense, and/or sell copies of the code, and to permit persons to whom the
# code is furnished to do so, subject to the following conditions:
#
#        The above copyright notice and this permission notice shall be
#        included in all copies or substantial portions of the code.
#
# THE  CODE IS  PROVIDED 'AS  IS',  WITHOUT WARRANTY  OF ANY  KIND, EXPRESS  OR
# IMPLIED,  INCLUDING BUT  NOT LIMITED  TO THE  WARRANTIES  OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE  AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHOR  OR  COPYRIGHT  HOLDER BE  LIABLE  FOR  ANY  CLAIM, DAMAGES  OR  OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF  OR IN CONNECTION WITH  THE CODE OR THE  USE OR OTHER  DEALINGS IN THE
# CODE.
#
# 2009-02-20:  Modified by Pablo Lorenzoni <pablo@propus.com.br>  to  correctly
# include the version in the raw_bytes.

require 'better-uuid/state_file'

require 'digest/md5'
require 'digest/sha1'


# Pure ruby UUID generator, which is compatible with RFC4122

class BetterUUID

  module ClassMethods
    def mask19(v, str) # :nodoc
      nstr = str.bytes.to_a
      version = [0, 16, 32, 48, 64, 80][v]
      nstr[6] &= 0b00001111
      nstr[6] |= version
#     nstr[7] &= 0b00001111
#     nstr[7] |= 0b01010000
      nstr[8] &= 0b00111111
      nstr[8] |= 0b10000000
      str = ''
      nstr.each { |s| str << s.chr }
      str
    end

    def mask18(v, str) # :nodoc
      version = [0, 16, 32, 48, 64, 80][v]
      str[6] &= 0b00001111
      str[6] |= version
#     str[7] &= 0b00001111
#     str[7] |= 0b01010000
      str[8] &= 0b00111111
      str[8] |= 0b10000000
      str
    end

    def mask(v, str)
      if RUBY_VERSION >= '1.9.0'
        return mask19 v, str
      else
        return mask18 v, str
      end
    end
    private :mask, :mask18, :mask19

    # UUID generation using SHA1. Recommended over create_md5.
    # Namespace object is another UUID, some of them are pre-defined below.
    def create_sha1(str, namespace)
      sha1 = Digest::SHA1.new
      sha1.update namespace.raw_bytes
      sha1.update str
      sum = sha1.digest
      raw = mask 5, sum[0..15]
      ret = new raw
      ret.freeze
      ret
    end
    alias :create_v5 :create_sha1

    # UUID generation using MD5 (for backward compat.)
    def create_md5(str, namespace)
      md5 = Digest::MD5.new
      md5.update namespace.raw_bytes
      md5.update str
      sum = md5.digest
      raw = mask 3, sum[0..16]
      ret = new raw
      ret.freeze
      ret
    end
    alias :create_v3 :create_md5

    # UUID  generation  using  random-number  generator.   From  it's  random
    # nature, there's  no warranty that  the created ID is  really universaly
    # unique.
    def create_random
      rnd = [
        rand(0x100000000),
        rand(0x100000000),
        rand(0x100000000),
        rand(0x100000000),
      ].pack 'N4'
      raw = mask 4, rnd
      ret = new raw
      ret.freeze
      ret
    end
    alias :create_v4 :create_random

    def get_time
      # UUID epoch is 1582/Oct/15
      tt = Time.now
      tt.to_i*10000000 + tt.tv_usec*10 + 0x01B21DD213814000
    end
    private :get_time

    # create  the 'version  1' UUID  with current  system clock,  current UTC
    # timestamp, and the IEEE 802 address (so-called MAC address).
    #
    # Speed notice: it's slow.  It writes  some data into hard drive on every
    # invokation. If you want to speed  this up, try remounting tmpdir with a
    # memory based filesystem  (such as tmpfs).  STILL slow?  then no way but
    # rewrite it with c :)
    def create(clock = nil, time = nil, mac_addr = nil)
      c, m = StateFile::update(clock, mac_addr)
      time ||= get_time

      tl = time & 0xFFFF_FFFF
      tm = time >> 32
      tm = tm & 0xFFFF
      th = time >> 48
      th = th & 0x0FFF
      th = th | 0x1000
      cl = c & 0xFF
      ch = c & 0x3F00
      ch = ch >> 8
      ch = ch | 0x80
      pack tl, tm, th, cl, ch, m
    end
    alias :create_v1 :create

    # A  simple GUID  parser:  just ignores  unknown  characters and  convert
    # hexadecimal dump into 16-octet object.
    def parse(obj)
      str = obj.dup.to_s.sub %r/\Aurn:uuid:/, ''
      str.gsub! %r/[^0-9A-Fa-f]/, ''
      raw = str[0..31].lines.to_a.pack 'H*'
      ret = new raw
      ret.freeze
      ret
    end

    # The 'primitive constructor' of this class
    # Note UUID.pack(uuid.unpack) == uuid
    def pack(tl, tm, th, ch, cl, n)
      raw = [tl, tm, th, ch, cl, n].pack 'NnnCCa6'
      ret = new raw
      ret.freeze
      ret
    end
  end
end
