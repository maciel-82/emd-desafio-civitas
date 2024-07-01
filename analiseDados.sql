-- 1. INFORMAÇÕES GERAIS SOBRE OS DADOS DA TABELA

-- 1.1. Exibe o número de linhas
SELECT COUNT(1)
FROM rj-cetrio.desafio.readings_2024_06;

-- 1.2. Exibe o número de colunas
SELECT COUNT(1) AS num_colunas
FROM rj-cetrio.desafio.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'readings_2024_06';

-- 1.3. Exibe o conteúdo das cinco primeiras linhas
SELECT *
FROM rj-cetrio.desafio.readings_2024_06
LIMIT 5;

-- 1.4. Exibe os metadados das colunas
SELECT *
FROM rj-cetrio.desafio.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'readings_2024_06';

-- 1.5. Exibe o número de observações nulas em cada campo
SELECT
SUM(CASE WHEN datahora IS NULL THEN 1 ELSE 0 END) AS datahora_null,
SUM(CASE WHEN datahora_captura IS NULL THEN 1 ELSE 0 END) AS datahora_captura_null,
SUM(CASE WHEN placa IS NULL THEN 1 ELSE 0 END) AS placa_null,
SUM(CASE WHEN empresa IS NULL THEN 1 ELSE 0 END) AS empresa_null,
SUM(CASE WHEN tipoveiculo IS NULL THEN 1 ELSE 0 END) AS tipoveiculo_null,
SUM(CASE WHEN velocidade IS NULL THEN 1 ELSE 0 END) AS velocidade_null,
SUM(CASE WHEN camera_numero IS NULL THEN 1 ELSE 0 END) AS camera_numero_null,
SUM(CASE WHEN camera_latitude IS NULL THEN 1 ELSE 0 END) AS camera_latitude_null,
SUM(CASE WHEN camera_longitude IS NULL THEN 1 ELSE 0 END) AS camera_longitude_null
FROM rj-cetrio.desafio.readings_2024_06;
--> O campo 'datahora_captura' possui 1.816.325 observações nulas


-- 2. IDENTIFICANDO ERROS NO CAMPO 'DATAHORA'

-- 2.1. Identifica os valores mínimo e máximo
SELECT
min(datahora) AS min,
max(datahora) AS max
FROM rj-cetrio.desafio.readings_2024_06;
--> O intervalo de valores está ok

-- 2.2. Identifica os percentis dos horários extraídos de 'datahora'
WITH a1 AS (
  SELECT EXTRACT(TIME FROM datahora) AS horario
  FROM rj-cetrio.desafio.readings_2024_06
)
SELECT
APPROX_QUANTILES(horario, 100)[OFFSET(1)] AS percentile_1,
APPROX_QUANTILES(horario, 100)[OFFSET(25)] AS percentile_25,
APPROX_QUANTILES(horario, 100)[OFFSET(50)] AS percentile_50,
APPROX_QUANTILES(horario, 100)[OFFSET(75)] AS percentile_75,
APPROX_QUANTILES(horario, 100)[OFFSET(99)] AS percentile_99,
APPROX_QUANTILES(horario, 100)[OFFSET(100)] AS percentile_100
FROM a1;
--> O intervalo de valores está ok


-- 3. IDENTIFICANDO ERROS NO CAMPO 'DATAHORA_CAPTURA'

-- 3.1. Identifica os valores mínimo e máximo
SELECT
min(datahora_captura) AS min,
max(datahora_captura) AS max
FROM rj-cetrio.desafio.readings_2024_06;
--> O intervalo de valores está ok

-- 3.2. Identifica se há observações com captura de dados anterior à detecção do radar
SELECT COUNT(1)
FROM rj-cetrio.desafio.readings_2024_06
WHERE datahora_captura < datahora;
--> Há 495.797 observações com captura de dados anterior à detecção do radar


-- 4. IDENTIFICANDO ERROS NO CAMPO 'VELOCIDADE'

-- 4.1. Identifica os valores mínimo e máximo
SELECT
min(velocidade) AS min,
max(velocidade) AS max
FROM rj-cetrio.desafio.readings_2024_06;
--> O intervalo possui valores entre 0 e 255 km/h

-- 4.2. Identifica a porcentagem de observações com velocidade igual a zero
SELECT ROUND(SUM(CASE WHEN velocidade = 0 THEN 1 ELSE 0 END)/COUNT(1),2)
FROM rj-cetrio.desafio.readings_2024_06;
--> As observações com velocidade igual a zero representam 0.01% do total

-- 4.3. Identifica os percentis dos valores acima de zero
SELECT
APPROX_QUANTILES(velocidade, 100)[OFFSET(1)] AS percentile_1,
APPROX_QUANTILES(velocidade, 100)[OFFSET(2)] AS percentile_2,
APPROX_QUANTILES(velocidade, 100)[OFFSET(25)] AS percentile_25,
APPROX_QUANTILES(velocidade, 100)[OFFSET(50)] AS percentile_50,
APPROX_QUANTILES(velocidade, 100)[OFFSET(75)] AS percentile_75,
APPROX_QUANTILES(velocidade, 100)[OFFSET(99)] AS percentile_99,
APPROX_QUANTILES(velocidade, 100)[OFFSET(100)] AS percentile_100
FROM rj-cetrio.desafio.readings_2024_06
WHERE velocidade > 0;
--> 99% das observações com velocidade acima de 0 têm velocidade até 75 km/h


-- 5. IDENTIFICANDO ERROS NO CAMPO 'CAMERA_LATITUDE'

-- 5.1. Identifica os valores mínimo e máximo
SELECT
min(camera_latitude) AS min,
max(camera_latitude) AS max
FROM rj-cetrio.desafio.readings_2024_06;
--> Há observações com latitude igual a zero

-- 5.2. Identifica a porcentagem de observações com latitude igual a zero
SELECT ROUND(SUM(CASE WHEN camera_latitude = 0.0 THEN 1 ELSE 0 END)/COUNT(1),2)
FROM rj-cetrio.desafio.readings_2024_06;
--> As observações com latitude igual a zero representam 0.01% do total

-- 5.3. Identifica os percentis dos valores abaixo de zero
SELECT
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(1)] AS percentile_1,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(2)] AS percentile_2,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(25)] AS percentile_25,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(50)] AS percentile_50,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(75)] AS percentile_75,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(99)] AS percentile_99,
APPROX_QUANTILES(camera_latitude, 100)[OFFSET(100)] AS percentile_100
FROM rj-cetrio.desafio.readings_2024_06
WHERE camera_latitude < 0;
--> O intervalo de valores está ok

-- 5.4. Identifica se há câmeras com mesmo número e coordenadas lat-long diferentes
WITH a1 AS (
  SELECT DISTINCT camera_numero, camera_latitude, camera_longitude
  FROM rj-cetrio.desafio.readings_2024_06
)
SELECT camera_numero, COUNT(1)
FROM a1
GROUP BY camera_numero
HAVING COUNT(1) > 1;
--> Não existe a inconsistência procurada

-- 5.5. Dentre as câmeras com latitude igual a zero, identifica se há
--      registros com o mesmo número de câmera, e com latitude correta.
--      O objetivo é verificar se a latitude pode ser recuperada
WITH a1 AS (
  SELECT DISTINCT camera_numero, camera_latitude
  FROM rj-cetrio.desafio.readings_2024_06
  WHERE camera_latitude = 0
), a2 AS (
  SELECT DISTINCT camera_numero, camera_latitude
  FROM rj-cetrio.desafio.readings_2024_06
  WHERE NOT camera_latitude = 0
)
SELECT a1.camera_numero, a2.camera_numero
FROM a1
INNER JOIN a2 ON a1.camera_numero = a2.camera_numero
WHERE
a1.camera_numero IS NOT NULL AND
a2.camera_numero IS NOT NULL;
--> Não há latitude a ser recuperada


-- 6. IDENTIFICANDO ERROS NO CAMPO 'CAMERA_LONGITUDE'

-- 6.1. Identifica os valores mínimo e máximo
SELECT
min(camera_longitude) AS min,
max(camera_longitude) AS max
FROM rj-cetrio.desafio.readings_2024_06;
--> Há observações com longitude positiva, o que não ocorre no Brasil.
--> Os valores positivos parecem estar com o sinal trocado, sendo necessário invertê-lo.

-- 6.2. Identifica os valores mínimo e máximo, sem os valores positivos
SELECT
min(camera_longitude) AS min,
max(camera_longitude) AS max
FROM rj-cetrio.desafio.readings_2024_06
WHERE NOT camera_longitude > 0;
--> Há observações com longitude igual a zero

-- 6.3. Identifica a porcentagem de observações com longitude igual a zero
SELECT ROUND(SUM(CASE WHEN camera_longitude = 0 THEN 1 ELSE 0 END)/COUNT(1),2)
FROM rj-cetrio.desafio.readings_2024_06;
--> As observações com longitude igual a zero representam 0.01% do total

-- 6.4. Identifica os percentis dos valores abaixo de zero,
--      após corrigir o sinal dos valores positivos
WITH a1 AS (
  SELECT (ABS(camera_longitude) * -1) AS long
  FROM rj-cetrio.desafio.readings_2024_06
  WHERE NOT camera_longitude = 0
)
SELECT
APPROX_QUANTILES(long, 100)[OFFSET(1)] AS percentile_1,
APPROX_QUANTILES(long, 100)[OFFSET(25)] AS percentile_25,
APPROX_QUANTILES(long, 100)[OFFSET(50)] AS percentile_50,
APPROX_QUANTILES(long, 100)[OFFSET(75)] AS percentile_75,
APPROX_QUANTILES(long, 100)[OFFSET(99)] AS percentile_99,
APPROX_QUANTILES(long, 100)[OFFSET(100)] AS percentile_100
FROM a1;
--> O intervalo de valores está ok

-- 6.5. Dentre as câmeras com longitude igual a zero, identifica se há
--      registros com o mesmo número de câmera, e com longitude correta.
--      O objetivo é verificar se a longitude pode ser recuperada
WITH a1 AS (
  SELECT DISTINCT camera_numero, camera_longitude
  FROM rj-cetrio.desafio.readings_2024_06
  WHERE camera_longitude = 0
), a2 AS (
  SELECT DISTINCT camera_numero, camera_longitude
  FROM rj-cetrio.desafio.readings_2024_06
  WHERE NOT camera_longitude = 0
)
SELECT a1.camera_numero, a2.camera_numero
FROM a1
INNER JOIN a2 ON a1.camera_numero = a2.camera_numero
WHERE
a1.camera_numero IS NOT NULL AND
a2.camera_numero IS NOT NULL;
--> Não há longitude a ser recuperada
