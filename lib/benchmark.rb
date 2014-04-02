require 'better-uuid'
begin
  require 'absolute_time'
rescue LoadError
  require 'benchmark'
end
NUM_OPS = 1_000_000

FOO = 'foo'

def time(&block)
  (defined?(AbsoluteTime) ? AbsoluteTime : Benchmark).realtime(&block)
end

# v1
seconds = time { NUM_OPS.times { BetterUUID.create_v1 } } 
puts "#{NUM_OPS / seconds} create_v1/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v3
seconds = time { NUM_OPS.times { BetterUUID.create_v3 FOO, BetterUUID::Namespace::URL } } 
puts "#{NUM_OPS / seconds} create_v3/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v4
seconds = time { NUM_OPS.times { BetterUUID.create_v4 } } 
puts "#{NUM_OPS / seconds} create_v4/sec  (#{1e6*seconds / NUM_OPS} usec/op)"

# v5
seconds = time { NUM_OPS.times { BetterUUID.create_v5 FOO, BetterUUID::Namespace::URL } } 
puts "#{NUM_OPS / seconds} create_v5/sec  (#{1e6*seconds / NUM_OPS} usec/op)"
