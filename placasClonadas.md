# Identificação de placas clonadas

Este código SQL permite identificar possíveis casos de clonagem de placas de veículos. A análise é feita utilizando dados de leituras de câmeras OCR.

## Descrição do código

O código SQL realiza os seguintes passos:

1. **Preparação dos dados**:
   - Remove registros com coordenadas inválidas (latitude ou longitude iguais a zero).
   - Converte longitudes positivas para negativas, corrigindo possíveis erros de sinal.

2. **Cálculo de distâncias e diferenças de tempo**:
   Para cada par de leituras da mesma placa:
   - Calcula a distância em metros entre as coordenadas geográficas.
   - Calcula a diferença de tempo em segundos entre as leituras.

3. **Identificação de anomalias**:
   - Calcula a velocidade média necessária para cobrir a distância entre as leituras.
   - Onde a velocidade média é extremamente alta, há um indicativo de possível clonagem de placas.