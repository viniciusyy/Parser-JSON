module JsonCalc
  module Nodes
    class NumberNode
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end
  end
end
