require_relative "../lib/json_calc/lexer"
require_relative "../lib/json_calc/parser"
require_relative "../lib/json_calc/evaluator"

# Verifica se foi passado caminho para arquivo JSON
if ARGV.empty?
  puts "Uso: #{$0} caminho/para/arquivo.json"
  exit 1
end
# Leitura do arquivo de entrada
input = File.read(ARGV.first)

# 1) Tokenização
lexer = JsonCalc::Lexer.new(input)

# 2) Parsing → AST
parser = JsonCalc::Parser.new(lexer)

begin
  ast = parser.parse
rescue StandardError => e
  warn "Erro de sintaxe: #{e.message}"
  exit 1
end

# 3) Avaliação da AST → Hash/Array/valores
evaluator = JsonCalc::Evaluator.new

begin
  result = evaluator.evaluate(ast)
rescue StandardError => e
  warn "Erro na avaliação: #{e.message}"
  exit 1
end

puts
puts "=== AVISOS DE CÁLCULOS ==="
p evaluator.warnings

puts
puts "=== RESULTADO ==="
p result
