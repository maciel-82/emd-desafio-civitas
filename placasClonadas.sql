-- Estima a velocidade do veículo a partir das distâncias e diferenças de tempo, para
-- verificar se esta é possível. Caso não seja, indica que uma das leituras é de placa clonada
WITH b1 AS (

  -- Corrige os valores de latitude e longitude, gera uma chave primária, e
  -- calcula as distâncias e diferenças de tempo entre leituras da mesma placa
  WITH a1 AS (
    SELECT
    GENERATE_UUID() AS uuid,
    placa,
    datahora,
    camera_latitude AS lat,
    (ABS(camera_longitude)*-1) AS long
    FROM rj-cetrio.desafio.readings_2024_06
    WHERE
    camera_latitude <> 0 AND
    camera_longitude <> 0
  )
  SELECT
  a1_left.placa,
  a1_left.datahora AS datahora01,
  a1_right.datahora AS datahora02,
  ROUND(
    ST_DISTANCE(
      ST_GEOGPOINT(a1_left.long, a1_left.lat),
      ST_GEOGPOINT(a1_right.long, a1_right.lat)
    ),1
  ) AS dist_metros,
  ABS(
    TIMESTAMP_DIFF(
      a1_left.datahora,
      a1_right.datahora,
      SECOND
    )
  ) AS horario_dif_segundos
  FROM a1 AS a1_left
  LEFT JOIN a1 AS a1_right ON
  a1_left.placa = a1_right.placa AND
  a1_left.uuid < a1_right.uuid
  WHERE
  a1_left.placa IS NOT NULL AND
  a1_right.placa IS NOT NULL AND
  a1_left.datahora < a1_right.datahora
)
SELECT
placa,
dist_metros,
datahora01,
datahora02,
horario_dif_segundos,
ROUND((dist_metros / horario_dif_segundos)/3.6,2) AS velocidade_km_h
FROM b1
WHERE
dist_metros > 0 AND
horario_dif_segundos > 0
ORDER BY (dist_metros / horario_dif_segundos) DESC;
