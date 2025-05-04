module JsonCalc
  module Nodes
    class StringNode
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end
  end
end
