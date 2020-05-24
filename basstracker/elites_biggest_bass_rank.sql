WITH cte_Ranks AS (
  SELECT
    angler,
    time,
    lake,
    weight,
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
, cte_BiggestBass AS (
  SELECT
    angler,
    time,
    lake,
    weight,
    weight_oz
  FROM cte_Ranks
  WHERE
    rank = 1
)
SELECT
  RANK() OVER (
    ORDER BY weight_oz Desc
  ),
  angler,
  time,
  lake,
  weight
FROM cte_BiggestBass
ORDER BY rank Desc
