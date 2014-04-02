require 'better-uuid'
require 'absolute_time'
NUM_OPS = 1_000_000

FOO = 'foo'

# v1
seconds = AbsoluteTime.realtime { NUM_OPS.times { BetterUUID.create_v1 } } 
puts "#{NUM_OPS / seconds} create_v1/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v3
seconds = AbsoluteTime.realtime { NUM_OPS.times { BetterUUID.create_v3 FOO, BetterUUID::Namespace::URL } } 
puts "#{NUM_OPS / seconds} create_v3/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v4
seconds = AbsoluteTime.realtime { NUM_OPS.times { BetterUUID.create_v4 } } 
puts "#{NUM_OPS / seconds} create_v4/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v5
seconds = AbsoluteTime.realtime { NUM_OPS.times { BetterUUID.create_v5 FOO, BetterUUID::Namespace::URL } } 
puts "#{NUM_OPS / seconds} create_v5/sec  (#{1e6*seconds / NUM_OPS} usec/op)"
