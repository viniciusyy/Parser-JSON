require_relative 'parser'

module JsonCalc
  class Evaluator
    attr_reader :warnings

    def initialize
      @warnings = []
    end

    def evaluate(node)
      case node
      when Nodes::ObjectNode
        result = {}
        node.members.each do |pair|
          key = evaluate(pair.key)
          value = evaluate(pair.value)
          result[key] = value
        end
        result
      when Nodes::ArrayNode
        node.elements.map { |e| evaluate(e) }
      when Nodes::StringNode
        node.value
      when Nodes::NumberNode
        node.value
      when Nodes::BooleanNode
        node.value
      when Nodes::NullNode
        nil
      when Nodes::CalcNode
        w = build_warning(node.expr_ast)
        @warnings << w
        evaluate(node.expr_ast)
      when Nodes::BinOpNode
        l = evaluate(node.left)
        r = evaluate(node.right)
        case node.op
        when :PLUS then l + r
        when :MINUS then l - r
        when :STAR then l * r
        when :SLASH then l.to_f / r
        when :CARET then l ** r
        end
      when Nodes::UnaryNode
        val = evaluate(node.expr)
        node.op == :MINUS ? -val : val
      else
        raise "Nó desconhecido: #{node.class}"
      end
    end

    private

    def literal(node)
      case node
      when Nodes::NumberNode then node.value
      when Nodes::UnaryNode then evaluate(node)
      else
        evaluate(node)
      end
    end

    def build_warning(node)
      if node.is_a?(Nodes::BinOpNode)
        name = case node.op
               when :PLUS then 'soma'
               when :MINUS then 'subtracao'
               when :STAR then 'multiplicacao'
               when :SLASH then 'divisao'
               when :CARET then 'potencia'
               end
        if [:PLUS, :MINUS].include?(node.op)
          [name, build_warning(node.right), literal(node.left)]
        else
          [name, literal(node.left), literal(node.right)]
        end
      else
        literal(node)
      end
    end
  end
end
