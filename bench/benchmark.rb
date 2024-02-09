# frozen_string_literal: true

require "protobuff/decoder"
require "protobuff/benchmark_pb"
require "upstream/benchmark_pb"
require "redblack"
require "benchmark/ips"

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

tree_10_nodes = nil
tree_100_nodes = nil
tree_1000_nodes = nil

1000.times do |i|
  tree = tree.insert(i, make_node(i))
  if i == 9
    tree_10_nodes = Upstream::RedBlackNode.encode(tree).freeze
  end

  if i == 99
    tree_100_nodes = Upstream::RedBlackNode.encode(tree).freeze
  end

  if i == 999
    tree_1000_nodes = Upstream::RedBlackNode.encode(tree).freeze
  end
end

def walk(node)
  return 0 if node.leaf
  walk(node.left) + walk(node.right) + node.value.unsigned_64
end

Benchmark.ips do |x|
  x.report("decode upstream (#{tree_1000_nodes.bytesize} bytes)") {
    Upstream::RedBlackNode.decode tree_1000_nodes
  }
  x.report("decode protobuff (#{tree_1000_nodes.bytesize} bytes)") {
    Protobuff::RedBlackNode.decode tree_1000_nodes
  }
  x.report("decode and read upstream (#{tree_1000_nodes.bytesize} bytes)") {
    walk Upstream::RedBlackNode.decode tree_1000_nodes
  }
  x.report("decode and read protobuff (#{tree_1000_nodes.bytesize} bytes)") {
    walk Protobuff::RedBlackNode.decode tree_1000_nodes
  }
end
