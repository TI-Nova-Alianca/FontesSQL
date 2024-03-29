---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDO_LUCRATIVIDADE AS
 select 
		PEDIDO						pedido_PEDLUC,
		ITEM						item_PEDLUC,
		LUCCOFINS					cofins_PEDLUC,
		LUCCORRETAGEM				corretagem_PEDLUC,
		LUCCPMF						cpmf_PEDLUC,
		LUCCUSTOADMINISTRATIVO		custoAdministrativo_PEDLUC,
		LUCCUSTOCOMERCIAL			custoComercial_PEDLUC,
		LUCCUSTOFINANCEIRO			custoFinanceiro_PEDLUC,
		LUCCUSTOFIXOINDUSTRIAL		custoFixoIndustrial_PEDLUC,
		LUCCUSTOMAODEOBRA			custoMaoObra_PEDLUC,
		LUCCUSTOMATERIAPRIMA		custoMateriaPrima_PEDLUC,
		LUCCUSTOTRANSFERENCIA		custoTransferencia_PEDLUC,
		LUCDEBITOSCLIENTE			debitosCliente_PEDLUC,
		LUCDESCONTOFISCAL			descontoFiscal_PEDLUC,
		LUCDESCONTOPROMOCIONAL		descontoPromocional_PEDLUC,
		LUCDESCONTOTROCA			descontoTroca_PEDLUC,
		LUCFATOR					fator_PEDLUC,
		LUCFRETE					frete_PEDLUC,
		LUCOUTRASINCIDENCIAS		outrasIncidencias_PEDLUC,
		LUCOUTROS					outrosImpostos_PEDLUC,
		LUCPIS						pis_PEDLUC,
		LUCPUBLICIDADE				publicidade_PEDLUC,
		LUCTAXAFRETE				taxaFrete_PEDLUC,
		LUCVALOR1					valor1_PEDLUC,
		LUCVALOR2					valor2_PEDLUC,
		LUCVALOR3					valor3_PEDLUC,
		LUCVALOR4					valor4_PEDLUC,
		LUCVALOR5					valor5_PEDLUC,
		LUCVLRCUSTOFRETE			valorCustoFrete_PEDLUC,
		LUCVLRDESCONTOFISCAL		valorDescontoFiscal_PEDLUC,
		LUCVLRICMS					valorIcms_PEDLUC,		
		LUCADVALOREM				advalorem_PEDLUC,
		MVA_PEDIDOS.usuario,
		MVA_PEDIDOS.dataalter
   from DB_PEDIDO_LUCRA, MVA_PEDIDOS
  where MVA_PEDIDOS.CODIGO_PEDID = DB_PEDIDO_LUCRA.PEDIDO
