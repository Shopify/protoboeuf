# frozen_string_literal: true

require "protobuff/benchmark_pb"
require "upstream/benchmark_pb"
require "redblack"
require "redblack/node"
require "benchmark/ips"

class Upstream::RedBlackNode
  include RBNode
  include Enumerable
end

class ProtoBuff::RedBlackNode
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
  x.report("decode protobuff") { ProtoBuff::RedBlackNode.decode binary }
  x.compare!
}

Benchmark.ips { |x|
  x.report("decode and read upstream")  { walk Upstream::RedBlackNode.decode binary }
  x.report("decode and read protobuff") { walk ProtoBuff::RedBlackNode.decode binary }
  x.compare!
}
