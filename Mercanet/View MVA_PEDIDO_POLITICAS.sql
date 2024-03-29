---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDO_POLITICAS AS
 select DB_PEDD_NRO				pedido_PEDPO,
		DB_PEDD_SEQIT			sequencia_PEDPO,
		DB_PEDD_INDDESCTO		indice_PEDPO,
		DB_PEDD_DESCONTO		percentualAplicado_PEDPO,
		DB_PEDD_DCTOPOL			percentualCalculado_PEDPO,
		DB_PEDD_TPPOL			tipoPolitica_PEDPO,
		DB_PEDD_CODPOL			politica_PEDPO,
		DB_PEDD_TPDESC			tipoPercentual_PEDPO,
		DB_PEDD_SEQAPLIQ		sequenciaAplicacao_PEDPO,
		DB_PEDD_MODDCTO			alteradoUsuario_PEDPO,
		DB_PEDD_NCALCCOMIS		naoCalculaComissao_PEDPO,
		DB_PEDD_VALORPOL		valorPOL_PEDPO,
		DB_PEDD_POLMANUAL		politicaManual_PEDPO,
		DB_PEDD_DESCMAXLISTA	descMaxLista_PEDPO,
		MVA_PEDIDOS.USUARIO,
		MVA_PEDIDOS.dataalter
   from DB_PEDIDO_DESCONTO, MVA_PEDIDOS
  where MVA_PEDIDOS.CODIGO_PEDID = DB_PEDD_NRO
