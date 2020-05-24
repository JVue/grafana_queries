SELECT
  weight
FROM basstracker
WHERE
  weight_oz = (
    SELECT
      MAX(weight_oz)
    FROM basstracker
    WHERE
      date = '$date'
      and angler = '$angler'
  )
