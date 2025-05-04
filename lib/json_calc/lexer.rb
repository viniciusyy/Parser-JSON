module JsonCalc
  Token = Struct.new(:type, :text)

  class Lexer
    # Palavras reservadas JSON
    KEYWORDS = {
      "true"  => :TRUE,
      "false" => :FALSE,
      "null"  => :NULL
    }

    # Símbolos e operadores suportados
    PUNCTUATION = {
      '{' => :LBRACE, '}' => :RBRACE,
      '[' => :LBRACKET, ']' => :RBRACKET,
      ':' => :COLON,   ',' => :COMMA,
      '$' => :DOLLAR,
      '+' => :PLUS,    '-' => :MINUS,
      '*' => :STAR,    '/' => :SLASH,
      '^' => :CARET,
      '(' => :LPAREN,  ')' => :RPAREN
    }

    def initialize(input)
      @input = input
      @pos   = 0
    end

    # Retorna o próximo token válido ou EOF
    def next_token
      skip_whitespace
      return Token.new(:EOF, "") if eof?

      ch = peek
      if PUNCTUATION[ch]
        advance
        return Token.new(PUNCTUATION[ch], ch)
      elsif ch == '"'
        return read_string
      elsif ch =~ /[0-9]/
        return read_number
      elsif ch =~ /[A-Za-z]/
        return read_keyword
      else
        raise "Caractere inesperado: '#{ch}'"
      end
    end

    private

    # Ignora espaços, quebras de linha e tabs
    def skip_whitespace
      advance while peek =~ /[\s]/
    end

    # Lê uma string entre aspas, com escapes permitidos
    def read_string
      advance # consume '"'
      str = ""
      until eof? || peek == '"'
        if peek == '\\'
          advance
          esc = advance
          case esc
          when '"' then str << '"'
          when '\\' then str << '\\'
          when 'b' then str << "\b"
          when 'f' then str << "\f"
          when 'n' then str << "\n"
          when 'r' then str << "\r"
          when 't' then str << "\t"
          else
            raise "Escape inválido: \#{esc}"
          end
        else
          str << advance
        end
      end
      raise "String não fechada" if eof?
      advance # consume '"'
      Token.new(:STRING, str)
    end

    def read_number
      num = ''
      num << advance while peek =~ /[0-9]/
      if peek == '.'
        num << advance
        raise "Decimal inválido" unless peek =~ /[0-9]/
        num << advance while peek =~ /[0-9]/
      end
      if peek =~ /[eE]/
        num << advance
        num << advance if peek =~ /[\+\-]/
        raise "Expo inválido" unless peek =~ /[0-9]/
        num << advance while peek =~ /[0-9]/
      end
      Token.new(:NUMBER, num)
    end

    def read_keyword
      id = ''
      id << advance while peek =~ /[A-Za-z]/
      type = KEYWORDS[id]
      raise "Identificador inesperado: #{id}" unless type
      Token.new(type, id)
    end

    def peek
      @input[@pos] || ""
    end

    def advance
      ch = peek
      @pos += 1
      ch
    end

    def eof?
      @pos >= @input.length
    end
  end
end
