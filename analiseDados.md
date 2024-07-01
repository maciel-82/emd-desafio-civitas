# Análise exploratória de dados

Este código contém consultas SQL utilizadas para realizar uma análise exploratória de dados em um conjunto de dados de leituras de câmeras OCR.

## Descrição das consultas

### 1. Informações gerais sobre os dados da tabela

- **Número de linhas:**
  - Conta o número de linhas na tabela `readings_2024_06`.

- **Número de colunas:**
  - Conta o número de colunas na tabela `readings_2024_06`.

- **Primeiras linhas:**
  - Exibe as cinco primeiras linhas da tabela `readings_2024_06`.

- **Metadados das colunas:**
  - Lista os metadados das colunas na tabela `readings_2024_06`.

- **Observações nulas:**
  - Conta o número de observações nulas em cada campo da tabela `readings_2024_06`.

### 2. Identificando erros nos campos de data/hora

- **Valores mínimo e máximo:**
  - Identifica os valores mínimo e máximo nos campos de data/hora.

- **Percentis dos horários:**
  - Calcula percentis dos horários extraídos dos campos de data/hora.

- **Comparação entre campos de data/hora:**
  - Identifica se há observações com captura de dados anterior à detecção do radar.

### 3. Identificando erros no campo de velocidade

- **Valores mínimo e máximo:**
  - Identifica os valores mínimo e máximo no campo de velocidade.

- **Porcentagem de valores 'zero':**
  - Calcula a porcentagem de observações com velocidade igual a zero.

- **Percentis dos valores de velocidade:**
  - Calcula percentis dos valores de velocidade acima de zero.

### 4. Identificando erros nos campos de latitude e longitude da câmera

- **Valores mínimo e máximo de latitude e longitude:**
  - Identifica os valores mínimo e máximo nos campos de latitude e longitude da câmera.

- **Porcentagem de valores 'zero':**
  - Calcula a porcentagem de observações com latitude e/ou longitude igual a zero.

- **Percentis dos valores válidos e corrigidos de latitude e longitude:**
  - Calcula percentis dos valores de latitude e longitude válidos para o município do RJ (abaixo de zero).
  - O conjunto de dados possui observações cuja longitude está com o sinal invertido. O cálculo dos percentis inclui a correção deste erro.

- **Recuperação de coordenadas das câmeras:**
  - Dentre as câmeras com latitude e/ou longitude igual a zero, identifica se há registros com o mesmo número de câmera, e com latitude/longitude correta.
  - O objetivo é verificar se a latitude/longitude da câmera pode ser recuperada