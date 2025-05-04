# Parser de linguagens Markdown

Este repositório implementa um **parser recursivo-descendente (LL(1))** para um subconjunto de JSON estendido com expressões aritméticas embutidas. O projeto utiliza **Ruby puro**, sem gems externas, e segue os fundamentos de gramáticas livres de contexto (GLC) e autômatos de pilha.

---

## 🎯 Objetivos

* **Parsear** estruturas JSON básicas:

  * Objetos `{ "chave": valor, ... }`
  * Arrays `[valor1, valor2, ...]`
  * Strings, Números, Booleanos (`true`, `false`), `null`
* **Estender** a gramática para reconhecer e **avaliar** cálculos demarcados por cifrões:

  ```json
  { "conta": $9/3 + 21^1$ }
  ```
* Montar uma **AST (Abstract Syntax Tree)** e, em seguida, gerar estruturas Ruby nativas (`Hash`, `Array`, `Numeric`, `String`, `Boolean`, `nil`), resolvendo expressões aritméticas de forma integrada.

---


## 🚀 Como usar

1. **Clonar o repositório**

   ```bash
   git clone https://github.com/seu-usuario/json_calc_parser.git
   cd json_calc_parser
   ```
2. **Preparar permissão de execução**

   ```bash
   chmod +x bin/run.rb
   ```
3. **Executar o parser** com seu arquivo JSON:

   ```bash
   ruby bin/run.rb exemplo.json
   ```

---

## 🛠️ Detalhes de Implementação

* **Lexer** (`lexer.rb`): escaneia a string de entrada e emite tokens (símbolos, literais, operadores, palavras-chave).
* **Parser** (`parser.rb`): métodos `parse_object`, `parse_array`, `parse_calc`, `parse_expr`, `parse_term`, `parse_power`, `parse_factor` constroem recursivamente a AST.
* **AST Nodes**: classes como `ObjectNode`, `CalcNode`, `BinOpNode`, `UnaryNode` representam a estrutura sintática.
* **Evaluator** (`evaluator.rb`): percorre a AST, monta um `Hash`/`Array` e resolve cálculos, coletando **avisos** que refletem a árvore de chamadas das operações.

---

## 🧪 Testes e Exemplos

* O arquivo `exemplo.json` demonstra objetos, arrays e cálculos aninhados.
* Recomenda-se escrever **RSpec** ou **Minitest** para cobrir casos válidos e inválidos.





