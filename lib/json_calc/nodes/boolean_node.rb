module JsonCalc
  module Nodes
    class BooleanNode
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end
  end
end
