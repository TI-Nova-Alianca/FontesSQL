---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	08/10/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ESTOQUE_V4  AS
 SELECT DB_ESTAL_EMPRESA    EMPRESA_ESTO ,
		DB_ESTAL_ALMOXAR    ALMOXARIFADO_ESTO,
		DB_ESTAL_PRODUTO    PRODUTO_ESTO,
		DB_ESTAL_QTDE_VDA   QUANTIDADEVENDA_ESTO,
		DB_ESTAL_QTDE_EST   QUANTIDADEESTOQUE_ESTO,
		DB_ESTAL_QTDE_ORD   QUANTIDADEORDEM_ESTO,
		DB_ESTAL_QTDE_RESER quantidadeReservada_ESTO,
		USUARIO
   FROM DB_ESTOQUE_ALMOX, DB_PRODUTO_USUARIO
  WHERE DB_ESTAL_PRODUTO = PRODUTO
