---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSINVESTIMENTO AS
select CODIGO			codigo_MOTINV
	 , DESCRICAO		descricao_MOTINV
	 , CATEGORIA		categoria_MOTINV
	 , BLOQUEIA_PEDIDO	bloqueiaPedido_MOTINV
  from DB_MOTIVO_INVEST_DESCTO
 where isnull(INATIVO, 0) <> 1
