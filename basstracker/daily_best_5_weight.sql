WITH cte_Ranks AS (
  SELECT
    ROW_NUMBER() OVER(
      PARTITION BY date
      ORDER BY weight_oz
      Desc
    ) AS "rank",
    date,
    weight_oz
  FROM basstracker
  WHERE
    angler = '$angler'
    and date = '$date'
)
, cte_Top5 AS (
  SELECT
    rank,
    weight_oz
  FROM cte_Ranks
  WHERE rank < 6
)
SELECT
  concat(cast(sum(weight_oz) / 16 as varchar), '-', cast(sum(weight_oz) - (sum(weight_oz)/16) * 16 as varchar)) AS weight
FROM cte_Top5
