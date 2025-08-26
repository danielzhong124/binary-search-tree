# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
  end

  def <=>(other)
    @value <=> other.value
  end
end
