module JsonCalc
  module Nodes
    class ObjectNode
      attr_reader :members
      def initialize(members)
        @members = members
      end
    end
  end
end
