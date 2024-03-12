# frozen_string_literal: true

require "protoboeuf/parser"
require "protoboeuf/benchmark_pb"
require "upstream/benchmark_pb"
require "benchmark/ips"

# Given a message definition, generate fake data
def gen_msg_data(msg)

end




# Given a type name, generate fake data
def gen_data(type_name)
  # TODO: resolve the type name
  #unit.messages
  #unit.enums
  #message.enums
  #message.messages



end




# Parse the proto file so we can generate fake data
unit = ProtoBoeuf.parse_file "bench/fixtures/benchmark.proto"
root_msg = unit.messages.select {|msg| msg.name == 'ParkingLot' }[0]


# NOTE: for the benchmark, we can guarantee that we don't have overlapping
# type names, so we can keep a hash of name => definition




msgs = (0..100).map { |i| gen_msg_data(root_msg) }
p msgs






# For each message type, we can write a method to generate fake data...
# One challenge is that each message can refer to others...?




# TODO:
# Walk the AST and generate some fake data
# Need to encode using upstream since we don't have an encoder yet








Upstream::ParkingLot



# Our implementation
ProtoBoeuf::ParkingLot
# Instantiate with ParkingLot.new



# TODO: generate fake data



# TODO: run the benchmark









=begin
class Upstream::RedBlackNode
  include RBNode
  include Enumerable
end

class ProtoBoeuf::RedBlackNode
  include RBNode
  include Enumerable
end

def make_node(key)
  Upstream::MessageWithManyTypes.new(
    unsigned_64: key,
    unsigned_32: key,
    signed_64: key,
    signed_32: key,
    a_string: "hello world #{key}"
  )
end

tree = RBTree.new

1000.times do |i|
  tree = tree.insert(i, make_node(i))
end

binary = Upstream::RedBlackNode.encode(tree).freeze

def walk(node)
  return 0 if node.leaf
  walk(node.left) + walk(node.right) + node.value.unsigned_64
end

Benchmark.ips { |x|
  x.report("decode upstream")  { Upstream::RedBlackNode.decode binary }
  x.report("decode protoboeuf") { ProtoBoeuf::RedBlackNode.decode binary }
  x.compare!
}

Benchmark.ips { |x|
  x.report("decode and read upstream")  { walk Upstream::RedBlackNode.decode binary }
  x.report("decode and read protoboeuf") { walk ProtoBoeuf::RedBlackNode.decode binary }
  x.compare!
}
=end