WITH cte_Ranks AS (
  SELECT
    angler,
    lake,
    weight_oz,
    ROW_NUMBER() OVER(
      PARTITION BY angler
      ORDER BY weight_oz
      Desc
    ) AS "rank"
  FROM basstracker
  WHERE
    date = '$date'
    and event = 'elites'
    and (angler = 'jason.vue'
    or angler = 'chewy.lee'
    or angler = 'cubby.xiong'
    or angler = 'lee.thao'
    or angler = 'lee.vue')
  ORDER BY date, angler, "rank"
)
, cte_Top5 AS (
  SELECT
    angler,
    lake,
    weight_oz,
    rank
  FROM cte_Ranks
  WHERE rank < 6
)
, cte_TotalWeightCalc AS (
  SELECT
    angler,
    lake,
    SUM(weight_oz) OVER (
      PARTITION BY angler
    ) AS total_weight_oz
  FROM cte_Top5
)
, cte_TotalWeights AS (
  SELECT DISTINCT angler, lake, total_weight_oz
  FROM cte_TotalWeightCalc
)
SELECT
  ROW_NUMBER() OVER (ORDER BY total_weight_oz Desc) AS "rank",
  angler,
  lake,
  concat(cast(total_weight_oz / 16 as varchar), '-', cast(total_weight_oz - (total_weight_oz/16) * 16 as varchar)) AS total_weight
FROM cte_TotalWeights
