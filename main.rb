# frozen_string_literal: true

require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
puts tree.balanced?

4.times { |n| tree.insert(100 + n) }
puts tree.balanced?

tree.rebalance
puts tree.balanced?