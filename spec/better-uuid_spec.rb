require 'better-uuid'

describe BetterUUID do
  context 'v1' do
    describe '#version' do
      it { u = BetterUUID.create_v1
           expect(u.version).to be(1) }
    end

    describe '.create' do
      context 'unique' do
        it { u1 = BetterUUID.create
             u2 = BetterUUID.create
             expect(u1).not_to eq(u2) }
      end

      context 'repeatable' do
        it { u1 = BetterUUID.create 1, 2, '345678'
             u2 = BetterUUID.create 1, 2, '345678'
             expect(u1).to eq(u2) }
      end
    end

    describe '.create_v1' do
      context 'same as .create' do
        it { u1 = BetterUUID.create    1, 2, '345678'
             u2 = BetterUUID.create_v1 1, 2, '345678'
             expect(u1).to eq(u2) }
      end
    end
  end

  context 'v3' do
    describe '#version' do
      it { u = BetterUUID.create_md5 'foo', BetterUUID::Namespace::DNS
           expect(u.version).to be(3) }
    end

    describe '.create_md5' do
      context 'unique' do
        it { u1 = BetterUUID.create_md5 'foo', BetterUUID::Namespace::DNS
             u2 = BetterUUID.create_md5 'foo', BetterUUID::Namespace::URL
             u3 = BetterUUID.create_md5 'bar', BetterUUID::Namespace::DNS
             expect(u1).not_to eq(u2)
             expect(u1).not_to eq(u3) }
      end

      context 'repeatable' do
        it { u1 = BetterUUID.create_md5 'foo', BetterUUID::Namespace::DNS
             u2 = BetterUUID.create_md5 'foo', BetterUUID::Namespace::DNS
             expect(u1).to eq(u2) }
      end
    end
  end

  context 'v4' do
    describe '#version' do
      it { u = BetterUUID.create_random
           expect(u.version).to be(4) }
    end

    describe '.create_random' do
      context 'unique' do
        # This test  is not  perfect, because the  random nature of  version 4
        # BetterUUID  it is  not always  true that  the three  objects  below really
        # differ.  But  in real  life it's  enough to say  we're OK  when this
        # passes.
        it { u1 = BetterUUID.create_random
             u2 = BetterUUID.create_random
             u3 = BetterUUID.create_random
             expect(u1).not_to eq(u2)
             expect(u1).not_to eq(u3) }
      end
    end

    describe '.create_v4' do
      context 'same as .create_random' do
        it { expect(BetterUUID.create_random.version).to eq(BetterUUID.create_v4.version) }
      end
    end
  end

  context 'v5' do
    describe '#version' do
      it { u = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::DNS
           expect(u.version).to be(5) }
    end

    describe '.create_sha1' do
      context 'repeatable' do
        it { u1 = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::DNS
             u2 = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::DNS
             expect(u1).to eq(u2) }
      end

      context 'unique' do
        it { u1 = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::DNS
             u2 = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::URL
             u3 = BetterUUID.create_sha1 'bar', BetterUUID::Namespace::DNS
             expect(u1).not_to eq(u2)
             expect(u1).not_to eq(u3) }
      end
    end

    describe '.create_v5' do
      context 'same as .create_sha1' do
        it { u1 = BetterUUID.create_sha1 'foo', BetterUUID::Namespace::DNS
             u2 = BetterUUID.create_v5   'foo', BetterUUID::Namespace::DNS
             expect(u1).to eq(u2) }
      end
    end
  end

  describe '.pack' do
    it { u = BetterUUID.pack(0x6ba7b810, 0x9dad, 0x11d1, 0x80, 0xb4, "\000\300O\3240\310")
         expect(u).to eq(BetterUUID::Namespace::DNS) }
  end

  describe '.unpack' do
    it { tl, tm, th, cl, ch, m = BetterUUID::Namespace::DNS.unpack
         expect(tl).to eq(0x6ba7b810)
         expect(tm).to eq(0x9dad)
         expect(th).to eq(0x11d1)
         expect(cl).to eq(0x80)
         expect(ch).to eq(0xb4)
         expect(m).to eq("\000\300O\3240\310".force_encoding('ASCII-8BIT')) }
  end

  describe '.parse' do
    it  {  u1 = BetterUUID.pack 0x6ba7b810, 0x9dad, 0x11d1, 0x80, 0xb4, "\000\300O\3240\310"
           u2 = BetterUUID.parse '6ba7b810-9dad-11d1-80b4-00c04fd430c8'
           u3 = BetterUUID.parse 'urn:uuid:6ba7b810-9dad-11d1-80b4-00c04fd430c8'
           expect(u1).to eq(u2)
           expect(u1).to eq(u3) }
  end

  describe '.to_s' do
    it { s = '6ba7b810-9dad-11d1-80b4-00c04fd430c8'
         u = BetterUUID.parse(s)
         expect(u.to_s).to eq(s) }
  end

  describe '.guid' do
    context 'same as .to_s' do
      it { u = BetterUUID.create
           expect(u.guid).to eq(u.to_s) }
    end
  end

  describe '.to_uri' do
    context 'works' do
      it { s = 'urn:uuid:6ba7b810-9dad-11d1-80b4-00c04fd430c8'
           u = BetterUUID.parse s
           expect(u.to_uri).to eq(s) }
    end

    context 'same as .urn' do
      it { s = 'urn:uuid:6ba7b810-9dad-11d1-80b4-00c04fd430c8'
           u = BetterUUID.parse s
           expect(u.urn).to eq(u.to_uri) }
    end
  end

  describe '.to_i' do
    it {  s = '6ba7b810-9dad-11d1-80b4-00c04fd430c8'
          u = BetterUUID.parse(s)
          i = 0x6ba7b8109dad11d180b400c04fd430c8
          expect(u.to_i).to eq(i) }
  end
end


