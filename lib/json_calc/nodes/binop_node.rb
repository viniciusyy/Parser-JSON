module JsonCalc
  module Nodes
    class BinOpNode
      attr_reader :left, :op, :right
      def initialize(left, op, right)
        @left = left
        @op = op
        @right = right
      end
    end
  end
end
