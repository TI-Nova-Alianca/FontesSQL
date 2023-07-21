
-- https://tdn.totvs.com/pages/releaseview.action?pageId=221546134

WITH C AS (
SELECT SU.USR_ID, SU.USR_CODIGO, SUG.USR_GRUPO, SGG.GR__NOME, SUG.USR_PRIORIZA, SGA.GR__CODACESSO, SGA.GR__DESCACESSO--, SGA.*, SUG.* , SGG.*
FROM SYS_USR SU
	LEFT JOIN SYS_USR_GROUPS SUG 
		LEFT JOIN SYS_GRP_GROUP SGG
		ON (SGG.D_E_L_E_T_ = '' AND SGG.GR__ID = SUG.USR_GRUPO)
		LEFT JOIN SYS_GRP_ACCESS SGA
		ON (SGA.D_E_L_E_T_ = '' AND SGA.GR__ID = SUG.USR_GRUPO AND SGA.GR__ACESSO = 'T')
	ON (SUG.D_E_L_E_T_ = '' AND SUG.USR_ID = SU.USR_ID)
WHERE SU.D_E_L_E_T_ = ''
--AND SU.USR_CODIGO like 'charlene%'
--AND upper (SGG.GR__NOME) like '%FIS%'
AND SU.USR_MSBLQL != '1'
--AND SUG.USR_GRUPO != '000000'
AND SUG.USR_GRUPO in ('000101')
--and USR_CODIGO not like 'cupom%'
and USR_CODIGO not like 'Administrador%'

)
SELECT * --DISTINCT USR_CODIGO--, USR_GRUPO, GR__NOME --distinct USR_CODIGO --GR__CODACESSO, GR__DESCACESSO
FROM C

--WHERE USR_GRUPO = '000161'
--AND NOT EXISTS (SELECT * FROM C AS C2 WHERE C2.USR_GRUPO = '000013' AND C2.GR__CODACESSO = C.GR__CODACESSO)
--WHERE upper (GR__DESCACESSO) LIKE '%ALT%'
ORDER BY GR__NOME, GR__CODACESSO

/*
-- VISAO RAPIDA USUARIOS
SELECT USR_GRPRULE, CASE USR_GRPRULE WHEN '1' THEN 'Priorizar' WHEN '2' THEN 'Desconsiderar' WHEN '3' THEN 'Somar' ELSE '' END as REGRA
	, USR_ID, USR_CODIGO, USR_NOME, USR_DEPTO, USR_CARGO, USR_DTLOGON
	, (SELECT MAX (ENTRADA) FROM VA_USOROT WHERE NOME = UPPER (USR_CODIGO) AND ENTRADA >= '20210101') AS ULTIMO_VA_USOROT
	, (SELECT STRING_AGG (GP.GR__ID + '(' + RTRIM (GP.GR__NOME) + ')', ', ') /*WITHIN GROUP (ORDER BY GU.USR_PRIORIZA, GP.GR__NOME)*/
		FROM SYS_GRP_GROUP GP, SYS_USR_GROUPS GU
		WHERE GP.D_E_L_E_T_ = ''
		AND GP.GR__CODIGO LIKE 'Funcao%'
		and GU.USR_PRIORIZA = '1'
		AND GU.D_E_L_E_T_ = ''
		AND GU.USR_ID = SYS_USR.USR_ID
		AND GP.GR__ID = GU.USR_GRUPO) as PROTHEUS_PERFIS
FROM SYS_USR
WHERE D_E_L_E_T_ = ''
AND USR_MSBLQL != '1'
ORDER BY USR_ID
*/


/* Andamento da migração de usuários 'por setor' para 'por função'
WITH C AS (
SELECT G.GR__ID, G.GR__CODIGO, G.GR__NOME
	,(SELECT count (*)
		FROM SYS_USR_GROUPS U
		WHERE U.D_E_L_E_T_ = ''
		AND U.USR_GRUPO = G.GR__ID) AS QT_USUARIOS
FROM SYS_GRP_GROUP G
WHERE G.D_E_L_E_T_ = ''  -- Nao deletado
AND G.GR__MSBLQL != '1'  -- Nao bloqueado
AND G.GR__NOME NOT LIKE 'Administradores'  -- Grupo de gerencialento do sistema
AND G.GR__NOME NOT LIKE 'Representantes'  -- Representantes nao usam mais o Protheus.
AND G.GR__CODIGO NOT LIKE 'Geral'  -- Acessos gerais (todos os usuarios fazem parte)
AND G.GR__CODIGO NOT LIKE 'Filia%'  -- Especifico para determinar as filiais que o usuario vai acessar
AND G.GR__CODIGO NOT LIKE 'Aprendiz%'  -- Especifico para manores aprendizes
ORDER BY G.GR__ID
)
SELECT SUM (CASE WHEN GR__CODIGO LIKE 'Funcao%' THEN 1 ELSE 0 END) AS QT_USR_MIGRADOS,
SUM (CASE WHEN GR__CODIGO LIKE 'Funcao%' THEN 0 ELSE 1 END) AS QT_USR_PENDENTES
FROM C
*/

