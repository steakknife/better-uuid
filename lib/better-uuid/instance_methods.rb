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


# Pure ruby UUID generator, which is compatible with RFC4122

class BetterUUID
  module InstanceMethods

    # The 'primitive deconstructor', or the dual to pack.
    # Note UUID.pack(uuid.unpack) == uuid
    def unpack
      raw_bytes.unpack 'NnnCCa6'
    end

    # Generate the string representation (a.k.a GUID) of this UUID
    def to_s
      a = unpack
      tmp = a[-1].unpack 'C*'
      a[-1] = sprintf '%02x%02x%02x%02x%02x%02x', *tmp
      '%08x-%04x-%04x-%02x%02x-%s' % a
    end
    alias guid to_s

    # Convert into a RFC4122-comforming URN representation
    def to_uri
      'urn:uuid:' + self.to_s
    end
    alias urn to_uri

    # Convert into 128-bit unsigned integer
    # Typically a Bignum instance, but can be a Fixnum.
    def to_int
      tmp = self.raw_bytes.unpack 'C*'
      tmp.inject do |r, i|
        r * 256 | i
      end
    end
    alias to_i to_int

    # Gets the version of this UUID
    # returns nil if bad version
    def version
      a = unpack
      v = (a[2] & 0xF000).to_s(16)[0].chr.to_i
      return v if (1..5).include? v
      return nil
    end

    # Two  UUIDs  are  said  to  be  equal if  and  only  if  their  (byte-order
    # canonicalized) integer representations are equivallent.  Refer RFC4122 for
    # details.
    def ==(other)
      to_i == other.to_i
    end

    include Comparable
    # UUIDs are comparable (don't know what benefits are there, though).
    def <=>(other)
      to_s <=> other.to_s
    end
  end
end
