---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	09/05/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTESORDENSCOMPRA AS
SELECT CLIENTE         CLIENTE_CORDC,
	   ORDEM_COMPRA    ORDEMCOMPRA_CORDC,
	   C.USUARIO       USUARIO
  FROM DB_CLIENTE_ORDEM_COMPRA, 
       MVA_CLIENTE C
 WHERE C.CODIGO_CLIEN = CLIENTE
