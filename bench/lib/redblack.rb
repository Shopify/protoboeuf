# frozen_string_literal: true

require "upstream/benchmark_pb"

module RBNode
  def insert key, val
    RBTree.insert self, key, val
  end

  def key? k
    return false if leaf
    return true if k == key
    k < key ? left.key?(k) : right.key?(k)
  end

  def deconstruct
    if leaf
      ["black", nil, nil, nil, nil]
    else
      [color, key, value, left, right]
    end
  end
end

module RBTree
  private_class_method def self.balance color, key, value, left, right
    # x, y, z are keys
    # a, b, c, d are nodes
    case [color, key, left, right]
    in ["black", z, ["red", y, yv, ["red", x, xv, a, b], c], d]
      zv = value
    in ["black", z, ["red", x, xv, a, ["red", y, yv, b, c]], d]
      zv = value
    in ["black", x, a, ["red", z, zv, ["red", y, yv, b, c], d]]
      xv = value
    in ["black", x, a, ["red", y, yv, b, ["red", z, zv, c, d]]]
      xv = value
    else
      return Upstream::RedBlackNode.new(color: color, key: key, value: value, left: left, right: right)
    end

    Upstream::RedBlackNode.new(color: "red", key: y, value: yv,
      left: Upstream::RedBlackNode.new(color: "black", key: x, value: xv, left: a, right: b),
      right: Upstream::RedBlackNode.new(color: "black", key: z, value: zv, left: c, right: d))
  end

  private_class_method def self.insert_aux tree, key, value
    if tree.leaf
      Upstream::RedBlackNode.new key: key, value: value, color: "red", left: LEAF, right: LEAF
    else
      if key < tree.key
        balance(tree.color, tree.key, tree.value, insert_aux(tree.left, key, value), tree.right)
      elsif key > tree.key
        balance(tree.color, tree.key, tree.value, tree.left, insert_aux(tree.right, key, value))
      else
        tree
      end
    end
  end

  def self.insert tree, k, v
    root = insert_aux(tree, k, v)

    if root.color == "red"
      Upstream::RedBlackNode.new(color: "black",
        key: root.key,
        value: root.value,
        left: root.left,
        right: root.right)
    else
      root
    end
  end

  LEAF = Upstream::RedBlackNode.new(color: "black", leaf: true)

  def self.new; LEAF; end
end

class Upstream::RedBlackNode
  include RBNode
end
