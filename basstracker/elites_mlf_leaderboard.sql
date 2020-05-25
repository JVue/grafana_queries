WITH cte_SumOfWeights AS (
  SELECT
    DISTINCT
      angler,
      lake,
      COUNT(*) OVER(PARTITION BY angler) AS total_catches,
      SUM(weight_oz) OVER(PARTITION BY angler) AS total_weight_oz
  FROM basstracker
  WHERE
    date = '$date'
    and event = 'elites'
    and (angler = 'jason.vue'
    or angler = 'chewy.lee'
    or angler = 'cubby.xiong'
    or angler = 'lee.thao'
    or angler = 'lee.vue')
)
SELECT
  RANK() OVER(ORDER BY total_weight_oz desc),
  angler,
  lake,
  total_catches,
  concat(cast(total_weight_oz / 16 as varchar), '-', cast(total_weight_oz - (total_weight_oz/16) * 16 as varchar)) AS total_weight
FROM cte_SumOfWeights
