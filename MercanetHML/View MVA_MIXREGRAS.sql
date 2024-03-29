---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	21/10/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MIXREGRAS AS
 SELECT MR.CODIGO_MIX	     CODIGOMIX_MIXR,
		MR.SEQUENCIA	     SEQUENCIA_MIXR,
		MR.PRODUTO	         PRODUTO_MIXR,
		MR.QTDE_MINIMA	     QUANTIDADEMINIMA_MIXR,
		MR.QTDE_MAXIMA	     QUANTIDADEMAXIMA_MIXR,
		MR.QTDE_SUG_VENDA	 QUANTIDADESUGERIDA_MIXR,
		MR.QTDE_SUG_BONIF	 QUANTIDADESUGBONIF_MIXR,
		MR.COND_PAGAMENTO	 CONDICAOPAGAMENTO_MIXR,
		MR.LISTA_PRECO	     LISTAPRECO_MIXR,
		MR.PRODUTO_PAI		 PRODUTOPAI_MIXR,
		MR.PERC_PARTICIPACAO PERCPARTICIPACAO_MIXR,
		MR.PRECO			 PRECO_MIXR
   FROM DB_MIXVENDA_REGRAS MR, MVA_MIX
  WHERE CODIGO_MIXV = CODIGO_MIX
