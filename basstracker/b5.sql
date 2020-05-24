WITH cte_Ranks AS (
  SELECT
    date,
    angler,
    lake,
    weight_oz,
    ROW_NUMBER() OVER(
      PARTITION BY date, angler, lake
      ORDER BY weight_oz
      Desc
    ) AS "rank"
  FROM basstracker
  WHERE
    (angler = 'jason.vue'
    or angler = 'chewy.lee'
    or angler = 'cubby.xiong'
    or angler = 'lee.thao'
    or angler = 'lee.vue')
    and date like '05/%/$year'
  ORDER BY date, angler, "rank"
)
, cte_Top5 AS (
  SELECT
    date,
    angler,
    lake,
    weight_oz,
    rank
  FROM cte_Ranks
  WHERE rank < 6
)
, cte_TotalWeightCalc AS (
  SELECT
    date,
    angler,
    lake,
    SUM(weight_oz) OVER (
      PARTITION BY date, angler, lake
    ) AS total_weight_oz
  FROM cte_Top5
)
, cte_TotalWeightsPerDay AS (
  SELECT DISTINCT date, angler, lake, total_weight_oz
  FROM cte_TotalWeightCalc
)
SELECT
  ROW_NUMBER() OVER (ORDER BY total_weight_oz desc) AS "rank",
  date,
  angler,
  lake,
  concat(cast(total_weight_oz / 16 as varchar), '-', cast(total_weight_oz - (total_weight_oz/16) * 16 as varchar)) AS total_weight
FROM cte_TotalWeightsPerDay
