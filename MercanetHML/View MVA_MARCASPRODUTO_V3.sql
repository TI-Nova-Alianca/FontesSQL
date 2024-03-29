
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_MARCASPRODUTO_V3 AS

with USU_SESSION  AS (select usuario
						from DB_USUARIO_SESSIONID
					   where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID))



SELECT MARCA.DB_TBMAR_CODIGO   CODIGO_MAPRO,
       MARCA.DB_TBMAR_DESCR    DESCRICAO_MAPRO,
	   DB_TBMAR_AVAL_COTA	   avalCota_MAPRO,
	   DB_TBMAR_AVAL_EST	   avalEst_MAPRO,
       USU.USUARIO
  FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_FILTRO_GRUPOUSU  FILTRO,
       DB_TB_MARCA         MARCA,
	   USU_SESSION
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
   AND FILTRO.ID_FILTRO           = 'MARCAPROD' -- MARCA PRODUTO
   AND FILTRO.VALOR_STRING        = MARCA.DB_TBMAR_CODIGO
   AND USU_SESSION.USUARIO = USU.USUARIO

UNION

SELECT MARCA.DB_TBMAR_CODIGO   CODIGO_MAPRO,
       MARCA.DB_TBMAR_DESCR   DESCRICAO_MAPRO,
	   DB_TBMAR_AVAL_COTA	   avalCota_MAPRO,
	   DB_TBMAR_AVAL_EST	   avalEst_MAPRO,
       USU.USUARIO
  FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_TB_MARCA         MARCA,
	   uSU_SESSION
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
                      WHERE FILTRO.CODIGO_GRUPO  = USU.GRUPO_USUARIO
                        AND upper(FILTRO.ID_FILTRO)    = 'MARCAPROD') -- MARCA PRODUTO;
   AND USU_SESSION.USUARIO = USU.USUARIO

