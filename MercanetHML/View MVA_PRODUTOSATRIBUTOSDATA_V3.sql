

ALTER VIEW MVA_PRODUTOSATRIBUTOSDATA_V3 as

---------------------------------------------------------------------------------------------------
-- VERSAO  DATA    AUTOR      ALTERACAO
-- 1.0000  15/10/2012  TIAGO PRADELLA  CRIACAO
-- 1.0001  04/11/2013  Alencar  Envia a data do produto
---------------------------------------------------------------------------------------------------

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario, DATAALTER
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))


SELECT DB_PRODA_CODIGO     PRODUTO_ATPRO,
       DB_PRODA_ATRIB        ATRIBUTO_ATPRO,
       DB_PRODA_VALOR        VALOR_ATPRO,
       VPROD.DATAALTER       DATAALTER,
       USU.USUARIO
  FROM DB_PRODUTO_ATRIB,
       DB_USUARIO     USU,
       PROD vprod
 where vprod.PRODUTO = db_proda_codigo
   and usu.usuario = vprod.USUARIO

