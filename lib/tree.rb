# frozen_string_literal: true

require_relative 'node'

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2

    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[(mid + 1)...array.length])

    root
  end

  def insert(value)
    @root = insert_rec(value, @root)
  end

  def insert_rec(value, curr)
    return Node.new(value) if curr.nil?
    return curr if value == curr.value

    value < curr.value ? curr.left = insert_rec(value, curr.left) : curr.right = insert_rec(value, curr.right)
    curr
  end

  def delete(value)
    @root = delete_rec(value, @root)
  end

  def delete_rec(value, curr)
    return nil if curr.nil?

    if value == curr.value
      return curr.right if curr.left.nil?
      return curr.left if curr.right.nil?

      successor = leftmost_leaf(curr.right)
      curr.value = successor.value
      curr.right = delete_rec(successor.value, curr.right)
    else
      value < curr.value ? curr.left = delete_rec(value, curr.left) : curr.right = delete_rec(value, curr.right)
    end

    curr
  end

  def leftmost_leaf(curr)
    curr = curr.left until curr.left.nil?
    curr
  end

  def find(value, curr = @root)
    return nil if curr.nil?
    return curr if value == curr.value
    
    value < curr.value ? find(value, curr.left) : find(value, curr.right)
  end

  def level_order
    queue = @root.nil? ? [] : [@root]
    values = []
    until queue.empty?
      curr = queue.shift
      block_given? ? yield(curr) : values << curr.value
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end

    values unless block_given?
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private :insert_rec, :delete_rec, :leftmost_leaf
end
