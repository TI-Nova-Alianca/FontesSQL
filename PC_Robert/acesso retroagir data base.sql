SELECT USR_DTBASE  -- indica se O USUARIO configura troca de data base
	, USR_REDTBS  -- indica dias que O USUARIO pode retroagir data base
	, USR_AVDTBS  -- indica dias que O USUARIO pode avancar data base
	, *
FROM SYS_USR
WHERE USR_CODIGO = 'felipe.prado'
order by USR_CODIGO
;
SELECT GR__DTBASE  -- indica se O GRUPO configura troca de data base
	, GR__REDTBS  -- indica dias que O GRUPO pode retroagir data base
	, GR__AVDTBS  -- indica dias que O GRUPO pode avancar data base
	, *
FROM SYS_GRP_GROUP
where GR__ID in ('000103','000099','000102')
;
select ZZU_VALID, *
FROM ZZU010
WHERE D_E_L_E_T_ = ''
AND ZZU_USER = '000678'
and ZZU_GRUPO = '084'
