module JsonCalc
  module Nodes
    class ArrayNode
      attr_reader :elements
      def initialize(elements)
        @elements = elements
      end
    end
  end
end
