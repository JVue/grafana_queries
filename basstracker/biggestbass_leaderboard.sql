WITH cteMaxLargeMouth AS (
  SELECT
    angler,
    max(weight_oz) AS MaxLargeMouthWeight
  FROM basstracker
  WHERE
    bass_type = 'largemouth'
    and date like '%/$year'
  GROUP BY angler
), cteMaxSmallMouth AS (
  SELECT
    angler,
    max(weight_oz) AS MaxSmallMouthWeight
  FROM basstracker
  WHERE
    bass_type = 'smallmouth'
    and date like '%/$year'
  GROUP BY angler
), cteCombinedSmallMouthAndLargeMouth AS (
  SELECT
    angler,
    MaxLargeMouthWeight AS Weight
  FROM cteMaxLargeMouth
  UNION ALL
  SELECT
    angler,
    MaxSmallMouthWeight
  FROM cteMaxSmallMouth
), cteTotalWeight AS (
  SELECT
    angler,
    sum(Weight) AS TotalWeightOfAnglersMaxLargeAndMaxSmallMouth
  FROM cteCombinedSmallMouthAndLargeMouth
  GROUP BY angler
), cteMaxWeight AS (
  SELECT
    max(TotalWeightOfAnglersMaxLargeAndMaxSmallMouth) as MaxTotalWeight
  FROM cteTotalWeight
), cteOuncesBehind AS (
  SELECT
    angler,
    MaxTotalWeight - TotalWeightOfAnglersMaxLargeAndMaxSmallMouth AS OuncesBehind
  FROM cteTotalWeight tw 
  CROSS JOIN cteMaxWeight mw  
), cteFinalResults AS (
  SELECT a.angler,
    concat(floor(l.MaxLargeMouthWeight/16), '-', mod(l.MaxLargeMouthWeight,16)) AS largemouth_weight,
    concat(floor(s.MaxSmallMouthWeight/16), '-', mod(s.MaxSmallMouthWeight,16)) AS smallmouth_weight,
    concat(floor(w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth/16), '-', mod(w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth,16)) AS total_weight,
    concat(floor(b.OuncesBehind/16), '-', mod(b.OuncesBehind,16)) AS behind,
    w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth AS total_weight_oz
  FROM basstracker_anglers a
  LEFT JOIN cteMaxLargeMouth l ON l.angler = a.angler
  LEFT JOIN cteMaxSmallMouth s ON s.angler = a.angler
  LEFT JOIN cteTotalWeight w ON w.angler = a.angler
  LEFT JOIN cteOuncesBehind b ON b.angler = a.angler
  WHERE 
    w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth IS NOT null
    and (a.angler = 'jason.vue' 
    or a.angler = 'chewy.lee'
    or a.angler = 'cubby.xiong'
    or a.angler = 'daniel.zimmerschied'
    or a.angler = 'sue.her'
    or a.angler = 'kevin.rush'
    or a.angler = 'douglas.zimmerschied'
    or a.angler = 'chue.her')
)
SELECT
  RANK() OVER(ORDER BY total_weight_oz desc),
  angler,
  largemouth_weight,
  smallmouth_weight,
  total_weight,
  behind
FROM cteFinalResults
ORDER BY rank asc
