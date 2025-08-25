# frozen_string_literal: true

class Node
  include Comparable
  attr_reader :data
  attr_accessor :left, :right

  def initialize(data)
    @data = data
  end

  def <=>(other)
    @data <=> other.data
  end
end
