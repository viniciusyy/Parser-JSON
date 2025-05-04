require_relative 'lexer'
require_relative 'nodes/object_node'
require_relative 'nodes/array_node'
require_relative 'nodes/pair_node'
require_relative 'nodes/string_node'
require_relative 'nodes/number_node'
require_relative 'nodes/boolean_node'
require_relative 'nodes/null_node'
require_relative 'nodes/calc_node'
require_relative 'nodes/binop_node'
require_relative 'nodes/unary_node'

module JsonCalc
  class Parser
    def initialize(lexer)
      @lexer = lexer
      advance
    end

    # Avança para o próximo token
    def advance
      @current = @lexer.next_token
    end

    # Verifica e consome token esperado
    def eat(type)
      if @current.type == type
        text = @current.text
        advance
        return text
      else
        raise "Esperava token #{type}, mas veio #{@current.type}"
      end
    end

    # Início do parsing: deve consumir tudo até EOF
    def parse
      node = element
      raise "Token inesperado após JSON: #{@current.type}" if @current.type != :EOF
      node
    end

    # Reconhece elemento JSON ou cálculo
    def element
      case @current.type
      when :LBRACE
        parse_object
      when :LBRACKET
        parse_array
      when :STRING
        value = @current.text
        advance
        Nodes::StringNode.new(value)
      when :NUMBER
        text = @current.text
        advance
        num = text.include?('.') ? text.to_f : text.to_i
        Nodes::NumberNode.new(num)
      when :TRUE
        advance
        Nodes::BooleanNode.new(true)
      when :FALSE
        advance
        Nodes::BooleanNode.new(false)
      when :NULL
        advance
        Nodes::NullNode.new
      when :DOLLAR
        parse_calc
      else
        raise "Token inesperado: #{@current.type}"
      end
    end

    # { members }
    def parse_object
      eat(:LBRACE)
      members = []
      unless @current.type == :RBRACE
        loop do
          key = eat(:STRING)
          eat(:COLON)
          val = element
          members << Nodes::PairNode.new(Nodes::StringNode.new(key), val)
          break if @current.type != :COMMA
          advance
        end
      end
      eat(:RBRACE)
      Nodes::ObjectNode.new(members)
    end

    # [ elements ]
    def parse_array
      eat(:LBRACKET)
      elements = []
      unless @current.type == :RBRACKET
        loop do
          elements << element
          break if @current.type != :COMMA
          advance
        end
      end
      eat(:RBRACKET)
      Nodes::ArrayNode.new(elements)
    end

     # $ expr $
    def parse_calc
      eat(:DOLLAR)
      node = parse_expr
      eat(:DOLLAR)
      Nodes::CalcNode.new(node)
    end

    # expr = term { (+|-) term }
    def parse_expr
      node = parse_term
      while [:PLUS, :MINUS].include?(@current.type)
        op = @current.type
        advance
        right = parse_term
        node = Nodes::BinOpNode.new(node, op, right)
      end
      node
    end

    # term = power { (*|/) power }
    def parse_term
      node = parse_power
      while [:STAR, :SLASH].include?(@current.type)
        op = @current.type
        advance
        right = parse_power
        node = Nodes::BinOpNode.new(node, op, right)
      end
      node
    end

    # power = factor [ ^ power ]
    def parse_power
      node = parse_factor
      if @current.type == :CARET
        advance
        right = parse_power
        node = Nodes::BinOpNode.new(node, :CARET, right)
      end
      node
    end
# factor = -factor | ( expr ) | number
    def parse_factor
      if @current.type == :MINUS
        advance
        expr = parse_factor
        return Nodes::UnaryNode.new(:MINUS, expr)
      elsif @current.type == :LPAREN
        advance
        node = parse_expr
        eat(:RPAREN)
        node
      elsif @current.type == :NUMBER
        text = @current.text
        advance
        num = text.include?('.') ? text.to_f : text.to_i
        Nodes::NumberNode.new(num)
      else
        raise "Fator inesperado: #{@current.type}"
      end
    end
  end
end
