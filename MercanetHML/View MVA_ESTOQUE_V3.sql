
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	08/10/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------


ALTER VIEW MVA_ESTOQUE_V3  AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

 SELECT DB_ESTAL_EMPRESA    EMPRESA_ESTO ,
		DB_ESTAL_ALMOXAR    ALMOXARIFADO_ESTO,
		DB_ESTAL_PRODUTO    PRODUTO_ESTO,
		DB_ESTAL_QTDE_VDA   QUANTIDADEVENDA_ESTO,
		DB_ESTAL_QTDE_EST   QUANTIDADEESTOQUE_ESTO,
		DB_ESTAL_QTDE_ORD   QUANTIDADEORDEM_ESTO,
		DB_ESTAL_QTDE_RESER quantidadeReservada_ESTO,
		PROD.USUARIO
   FROM DB_ESTOQUE_ALMOX, PROD
  WHERE DB_ESTAL_PRODUTO = PROD.PRODUTO
