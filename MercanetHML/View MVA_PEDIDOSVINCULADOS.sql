---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	04/09/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDOSVINCULADOS AS
SELECT DB_PEDV_PEDIDO	  PEDIDOBONIFICACAO_PEDVI,
       DB_PEDV_PEDVINC	  PEDIDOVENDAVINCULADO_PEDVI,
	   CLI.USUARIO
  FROM DB_PEDIDO_VINCBON, MVA_CLIENTE CLI, DB_PEDIDO
 WHERE DB_PED_NRO = DB_PEDV_PEDIDO
   AND DB_PED_CLIENTE = CLI.CODIGO_CLIEN
