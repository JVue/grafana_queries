SELECT
  concat(cast(sum(weight_oz) / 16 as varchar), '-', cast(sum(weight_oz) - (sum(weight_oz)/16) * 16 as varchar)) AS weight
FROM basstracker
WHERE
  angler = '$angler'
  and date = '$date'
