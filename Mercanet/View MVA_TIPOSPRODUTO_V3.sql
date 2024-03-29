
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   08/11/2012  tiago pradella  colocada cond~icao DB_GRUPO_USU_TPROD
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_TIPOSPRODUTO_V3 AS

with USU_SESSION  AS (select usuario
						from DB_USUARIO_SESSIONID
					   where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID))


SELECT TIPOPROD.DB_TBTPR_CODIGO CODIGO_TPPRO,
       TIPOPROD.DB_TBTPR_DESCR  DESCRICAO_TPPRO,
       USU.USUARIO
  FROM DB_USUARIO           USU,
       DB_GRUPO_USUARIOS    GRUPO_USU,
       DB_GRUPO_USU_TPROD   GRUPO_TPPROD,
       DB_TB_TPPROD         TIPOPROD,
	   USU_SESSION
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND GRUPO_TPPROD.GRUPO_USUARIO = GRUPO_USU.CODIGO
   AND TIPOPROD.DB_TBTPR_CODIGO   = GRUPO_TPPROD.TIPO_PRODUTO
   AND USU_SESSION.usuario = USU.USUARIO
								

UNION

 SELECT TIPOPROD.DB_TBTPR_CODIGO CODIGO_TPPRO,
        TIPOPROD.DB_TBTPR_DESCR  DESCRICAO_TPPRO,
        USU.USUARIO
   FROM DB_USUARIO           USU,
        DB_GRUPO_USUARIOS    GRUPO_USU,
        DB_TB_TPPROD         TIPOPROD,
		USU_SESSION
  WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
    AND not EXISTS (SELECT 1
	            FROM DB_GRUPO_USU_TPROD
				WHERE GRUPO_USUARIO = GRUPO_USU.CODIGO   )
	AND  USU_SESSION.usuario = USU.USUARIO
