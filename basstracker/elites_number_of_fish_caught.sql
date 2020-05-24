  SELECT
    RANK() OVER (ORDER BY COUNT(*) Desc),
    angler,
    lake,
    COUNT(*)
  FROM basstracker
  WHERE
    date = '$date'
    and event = 'elites'
    and (angler = 'jason.vue'
    or angler = 'chewy.lee'
    or angler = 'cubby.xiong'
    or angler = 'lee.thao'
    or angler = 'lee.vue')
  GROUP BY angler, lake
  ORDER BY angler, count
