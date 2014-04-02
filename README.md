[![Build Status](https://travis-ci.org/steakknife/better-uuid.svg)](https://travis-ci.org/steakknife/better-uuid)

# BetterUUID

## Advantages

- Very fast because it doesn't hit disk on every create, updates in a seperate thread


## Usage

    BetterUUID.create # or create_v1
    BetterUUID.create_v3 'key', BetterUUID::Namespace::DNS # or URL, OID or X500
    BetterUUID.create_v4 # random
    BetterUUID.create_v5 'key', BetterUUID::Namespace::DNS # or URL, OID or X500

    BetterUUID.parse 'urn:uuid:6ba7b810-9dad-11d1-80b4-00c04fd430c8'

## Installation

### Bundler

    gem 'better-uuid'

### manually

    gem cert --add <(curl -L https://raw.githubusercontent.com/steakknife/better-uuid/master/gem-public_cert.pem)
    gem install better-uuid -P HighSecurity

## Author

Barry Allard

## Attribution

Heavily based off https://github.com/spectra/ruby-uuid 
which was based on http://mput.dip.jp/mput/uuid.txt

## License

MIT 
