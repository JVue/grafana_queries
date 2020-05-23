WITH cte_Ranks AS (
  SELECT
    ROW_NUMBER() OVER(
      PARTITION BY date
      ORDER BY weight_oz
      Desc
    ) AS "rank",
    date,
    time,
    angler,
    weight_oz
  FROM basstracker
  WHERE
    angler = '$angler'
    and date = '$date'
  ORDER BY date, angler, "rank"
)
SELECT
  rank,
  time,
  concat(cast(weight_oz / 16 as varchar), '-', cast(weight_oz - (weight_oz/16) * 16 as varchar)) AS weight
FROM cte_Ranks
WHERE rank < 6
ORDER BY rank
