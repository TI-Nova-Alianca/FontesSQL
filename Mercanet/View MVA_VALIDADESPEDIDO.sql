ALTER VIEW  MVA_VALIDADESPEDIDO AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001   25/06/2013  TIAGO           CRIACAO
-- 1.0002   31/07/213   tiago           trunca data
---------------------------------------------------------------------------------------------------
 SELECT DB_PEDV_ID      ID_VALPED,
		DB_PEDV_VIGINI  VIGENCIAINICIAL_VALPED,
		DB_PEDV_VIGFIM  VIGENCIAFINAL_VALPED,
		DB_PEDV_VALINI  VALIDADEINICIAL_VALPED,
		DB_PEDV_VALFIM  VALIDADEFINAL_VALPED
   FROM DB_PEDIDO_VAL
  where DB_PEDV_VIGFIM >= cast(getdate() as date)
