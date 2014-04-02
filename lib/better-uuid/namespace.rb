class BetterUUID
  # Pre-defined UUID Namespaces described in RFC4122 Appendix C.
  module Namespace
     DNS = BetterUUID.parse '6ba7b810-9dad-11d1-80b4-00c04fd430c8'
     URL = BetterUUID.parse '6ba7b811-9dad-11d1-80b4-00c04fd430c8'
     OID = BetterUUID.parse '6ba7b812-9dad-11d1-80b4-00c04fd430c8'
    X500 = BetterUUID.parse '6ba7b814-9dad-11d1-80b4-00c04fd430c8'
  end
end
