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
    return nil if curr.nil?
    return curr if value == curr.value
    
    value < curr.value ? find(value, curr.left) : find(value, curr.right)
  end

  def level_order(root = @root)
    queue = root.nil? ? [] : [root]
    values = []
    until queue.empty?
      curr = queue.shift
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end

    values
  end

  def preorder(root = @root)
    return [] if root.nil?

    values = [root.value]
    values += preorder(root.left)
    values += preorder(root.right)

    values
  end

  def inorder(root = @root)
    return [] if root.nil?

    values = inorder(root.left)
    values << root.value
    values += inorder(root.right)

    values
  end

  def postorder(root = @root)
    return [] if root.nil?

    values = postorder(root.left)
    values += postorder(root.right)
    values << root.value

    values
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private :insert_rec, :delete_rec, :leftmost_leaf
end
