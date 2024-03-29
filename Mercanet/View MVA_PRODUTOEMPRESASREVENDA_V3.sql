
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_PRODUTOEMPRESASREVENDA_V3 AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario, DATAALTER
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

SELECT DB_PRODUTO.DB_PROD_CODIGO  PRODUTO_PREMP,
       E.DB_TBEMP_CODIGO          EMPRESAREVENDA_PREMP,
	   CASE  WHEN ISNULL(DB_PROD_ULT_ALTER, 0) > ISNULL(DB_PROD_ALT_CORP, 0) THEN DB_PROD_ULT_ALTER ELSE DB_PROD_ALT_CORP END DATAALTER, 
       USU.USUARIO AS USUARIO
  FROM DB_PRODUTO, 
       DB_USUARIO    USU, 
	   DB_TB_EMPRESA E
 WHERE DB_PRODUTO.DB_PROD_CODIGO IN (SELECT PRODUTO
                                       FROM PROD)
   AND (DBO.MERCF_VALIDA_LISTA (E.DB_TBEMP_CODIGO,
                            DB_PRODUTO.DB_PROD_EMPREV,
                            0,
                            ',')) = 1 
   AND ISNULL(DB_PRODUTO.DB_PROD_EMPREV, '') <> ''

