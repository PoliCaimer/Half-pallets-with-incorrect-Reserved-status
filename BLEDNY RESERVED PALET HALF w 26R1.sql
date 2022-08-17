--DATE: 01/01/2022
--ID: BLEDNY RESERVED PALET HALF w 26R1
--FREQUENCY: when needed
--PURPOSE: PROBLEMATIC HALF PALLETS IN SILO2
--FROM: DC310
--FOR: DC310 - SU
--AUTHOR: AADDE
--REPORT: NO
--ORIGINAL FROM : AADDE

SELECT 
a.mha, 
a.rack, 
a.horcoor, 
a.vercoor, 
a.l34seqno, 
a.ecarrno, 
a.reserved, 
b.l54uniq, 
b.ordno, 
b.l54state 

FROM
(
    SELECT 
    mha, 
    rack, 
    horcoor, 
    vercoor, 
    l34seqno, 
    ecarrno, 
    reserved, 
    --LEAD(reserved) OVER (PARTITION BY rack, horcoor, vercoor ORDER BY reserved) AS kontrola,
    
    CASE 
    WHEN (LEAD(reserved) OVER (PARTITION BY rack, horcoor, vercoor ORDER BY l34seqno)) = '0' THEN 'zle' 
    END as "check"
    
    FROM
    ASTRO_VIEW_CNT_LOCG08

    WHERE
    mha = '26R1'
    AND ldct in ('H1','H2')
) a

JOIN

(
    SELECT 
    ecarrno, 
    l54uniq, 
    ordno, 
    l54state

    FROM 
    ASTRO_VIEW_CNT_W08L54
) b

ON 
a.ecarrno = b.ecarrno 

WHERE 
"check" = 'zle'

ORDER BY
rack, 
horcoor, 
vercoor