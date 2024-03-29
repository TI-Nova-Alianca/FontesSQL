
ALTER VIEW  MVA_ALBUMPRODUTO_V3 AS

---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

select CODIGO_ALBUM		  album_ALPRO,
	   CODIGO_PRODUTO	  produto_ALPRO,
	   DATA_ATUALIZACAO	  dataalter,
	   EXCLUIDO		      excluido_ALPRO,
	   prod.USUARIO	   
 from DB_ALBUM_PRODUTO, prod
where CODIGO_PRODUTO = prod.PRODUTO

