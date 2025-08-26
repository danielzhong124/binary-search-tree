# frozen_string_literal: true

require_relative 'node'

class Tree
  def initialize(values)
    @root = build_tree(values.sort.uniq)
  end

  def build_tree(values)
    return nil if values.empty?

    mid = values.length / 2

    root = Node.new(values[mid])
    root.left = build_tree(values[0...mid])
    root.right = build_tree(values[(mid + 1)...values.length])

    root
  end

  def insert(value)
    @root = insert_rec(value, @root)
  end

  def insert_rec(value, root)
    return Node.new(value) if root.nil?
    return root if value == root.value

    value < root.value ? root.left = insert_rec(value, root.left) : root.right = insert_rec(value, root.right)
    root
  end

  def delete(value)
    @root = delete_rec(value, @root)
  end

  def delete_rec(value, root)
    return nil if root.nil?

    if value == root.value
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      successor = leftmost_leaf(root.right)
      root.value = successor.value
      root.right = delete_rec(successor.value, root.right)
    else
      value < root.value ? root.left = delete_rec(value, root.left) : root.right = delete_rec(value, root.right)
    end

    root
  end

  def leftmost_leaf(curr)
    curr = curr.left until curr.left.nil?
    curr
  end

  def find(value, root = @root)
    return nil if root.nil?
    return root if value == root.value

    value < root.value ? find(value, root.left) : find(value, root.right)
  end

  def level_order(root = @root)
    queue = root ? [root] : []
    values = []
    until queue.empty?
      curr = queue.shift
      block_given? ? yield(curr) : values << curr.value
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end

    values unless block_given?
  end

  def preorder(root = @root, &block)
    if block_given?
      return if root.nil?

      yield(root)
      preorder(root.left, &block)
      preorder(root.right, &block)
    else
      return [] if root.nil?

      [root.value] + preorder(root.left) + preorder(root.right)
    end
  end

  def inorder(root = @root, &block)
    if block_given?
      return if root.nil?

      inorder(root.left, &block)
      yield(root)
      inorder(root.right, &block)
    else
      return [] if root.nil?

      inorder(root.left) + [root.value] + inorder(root.right)
    end
  end

  def postorder(root = @root, &block)
    if block_given?
      return if root.nil?

      postorder(root.left, &block)
      postorder(root.right, &block)
      yield(root)
    else
      return [] if root.nil?

      postorder(root.left) + postorder(root.right) + [root.value]
    end
  end

  def height(value)
    node = find(value)
    return nil if node.nil?

    left_height = node.left ? 1 + height(node.left.value) : 0
    right_height = node.right ? 1 + height(node.right.value) : 0

    [left_height, right_height].max
  end

  def depth(value, root = @root)
    return nil if root.nil?
    return 0 if value == root.value

    value < root.value ? 1 + depth(value, root.left) : 1 + depth(value, root.right)
  end

  def balanced?(root = @root)
    return true if root.nil?

    left_height = root.left ? 1 + height(root.left.value) : 0
    right_height = root.right ? 1 + height(root.right.value) : 0

    (left_height - right_height).between?(-1, 1) && balanced?(root.left) && balanced?(root.right)
  end

  def rebalance
    values = inorder
    @root = build_tree(values)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private :insert_rec, :delete_rec, :leftmost_leaf
end
