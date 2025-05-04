module JsonCalc
  module Nodes
    class UnaryNode
      attr_reader :op, :expr
      def initialize(op, expr)
        @op = op
        @expr = expr
      end
    end
  end
end
