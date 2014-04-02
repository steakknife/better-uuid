require 'better-uuid/versions'
require 'better-uuid/class_methods'
require 'better-uuid/instance_methods'

class BetterUUID
  private_class_method :new
  extend BetterUUID::ClassMethods
  include BetterUUID::InstanceMethods
end
