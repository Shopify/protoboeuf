# frozen_string_literal: true

require "protoboeuf/parser"
require "protoboeuf/benchmark_pb"
require "upstream/benchmark_pb"
require "benchmark/ips"

# Parse the proto file so we can generate fake data
unit = ProtoBoeuf.parse_file "bench/fixtures/benchmark.proto"


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