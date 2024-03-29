

ALTER VIEW MVA_PRODUTOSIMAGENS_DELETE_V3  AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario, DATAALTER
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

SELECT CODIGO_PRODUTO             PRODUTO_PRIMG,
       ID_IMAGEM                  IMAGEM_PRIMG,
	   DATA_ALTER                 DATAALTER,
	   P.USUARIO                  USUARIO
  FROM DB_PRODUTO_IMAGEM, PROD P
 WHERE P.PRODUTO = CODIGO_PRODUTO
   AND SITUACAO = 'I'
