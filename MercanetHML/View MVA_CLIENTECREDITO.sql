---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   17/03/2014  tiago           incluido campo data de ultimo faturamento
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTECREDITO AS
SELECT DB_CLICR_CODIGO                                 CODIGO_CLIEN,
       DB_CLICR_ESPEC                                  ESPECIAL_CLIEN,
       DB_CLICR_AVALCRED                               ESPECIALAVALIACREDITO_CLIEN,
       DB_CLICR_CRITCRED                               ESPECIALCRITERIOSCREDITO_CLIEN,
       DB_CLICR_PEDABERTO                              VALORPEDIDOSEMABERTO_CLIEN,
       DB_CLICR_TITABERTO                              VALORTITULOSEMABERTO_CLIEN,
       DB_CLICR_TITATRASO                              VALORTITULOSEMATRASO_CLIEN,
       DB_CLICR_JURATRASO                              VALORJUROSEMATRASO_CLIEN,
       DB_CLICR_LIMCREDAP                              LIMITECREDITO_CLIEN,
       DB_CLICR_DATAALTER                              DATAALTERACAO_CLIEN,
	   ISNULL((SELECT MAX(DB_NOTA_DT_EMISSAO) 
	             FROM DB_NOTA_FISCAL
				WHERE DB_NOTA_CLIENTE = DB_CLICR_CODIGO
				  AND DB_NOTA_FATUR = 0), '')    	   DATAULTIMOFATURAMENTO_CLIEN,
       USUARIO
     FROM DB_CLIENTE_CREDITO, DB_USUARIO USU
    WHERE EXISTS
                 (SELECT 1
                    FROM DB_CLIENTE_REPRES, MVA_REPRESENTANTES R
                   WHERE DB_CLIR_CLIENTE = DB_CLICR_CODIGO
                     AND DB_CLIR_REPRES = R.CODIGO_REPRES
                     AND USU.USUARIO = R.USUARIO)
