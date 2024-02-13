module RBNode
  def each(&blk)
    yield self
    unless leaf
      left.each(&blk)
      right.each(&blk)
    end
  end

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
