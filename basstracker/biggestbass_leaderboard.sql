;with cteMaxLargeMouth as (
  select angler, max(weight_oz) as MaxLargeMouthWeight
  from basstracker
  where bass_type = 'largemouth'
  group by angler
), cteMaxSmallMouth as (
  select angler, max(weight_oz) as MaxSmallMouthWeight
  from basstracker
  where bass_type = 'smallmouth'
  group by angler
), cteCombinedSmallMouthAndLargeMouth as (
  select angler, MaxLargeMouthWeight as Weight
  from cteMaxLargeMouth
  union all
  select angler, MaxSmallMouthWeight
  from cteMaxSmallMouth
), cteTotalWeight as (
  select angler, sum(Weight) as TotalWeightOfAnglersMaxLargeAndMaxSmallMouth
  from cteCombinedSmallMouthAndLargeMouth
  group by angler
), cteMaxWeight as (
  select max(TotalWeightOfAnglersMaxLargeAndMaxSmallMouth) as MaxTotalWeight
  from cteTotalWeight
), cteOuncesBehind as (
 select angler, MaxTotalWeight - TotalWeightOfAnglersMaxLargeAndMaxSmallMouth as OuncesBehind
 from cteTotalWeight tw 
 cross join cteMaxWeight mw  
 )
select 
  a.angler,
  concat(floor(l.MaxLargeMouthWeight/16), '-', mod(l.MaxLargeMouthWeight,16)) as largemouth_weight,
  concat(floor(s.MaxSmallMouthWeight/16), '-', mod(s.MaxSmallMouthWeight,16)) as smallmouth_weight,
  concat(floor(w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth/16), '-', mod(w.TotalWeightOfAnglersMaxLargeAndMaxSmallMouth,16)) as total_weight,
  concat(floor(b.OuncesBehind/16), '-', mod(b.OuncesBehind,16)) as behind
from basstracker_anglers a
left join cteMaxLargeMouth l on l.angler = a.angler
left join cteMaxSmallMouth s on s.angler = a.angler
left join cteTotalWeight w on w.angler = a.angler
left join cteOuncesBehind b on b.angler = a.angler
