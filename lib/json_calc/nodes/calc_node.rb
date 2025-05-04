module JsonCalc
  module Nodes
    class CalcNode
      attr_reader :expr_ast
      def initialize(expr_ast)
        @expr_ast = expr_ast
      end
    end
  end
end
