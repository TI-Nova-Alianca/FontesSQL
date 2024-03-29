---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/08/2015  tiago           incluido campo periodicidade
-- 1.0002   21/09/2015  tiago           traz pesquisas que tem rota informada ou que nao tem nenhum informada e sao validas
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPESQUISA  AS
 SELECT DB_SHOPP_CODIGO    CODIGO_SHOP,
	     DB_SHOPP_DESCR     DESCRICAO_SHOP,
	     DB_SHOPP_VESTOQUE  OBRIGATORIOESTOQUE_SHOP,
	     DB_SHOPP_VFRENTES  OBRIGATORIOFRENTES_SHOP,
	     DB_SHOPP_VOBSERV   OBRIGATORIOOBSERVACAO_SHOP,
	     DB_SHOPP_VOCORR    OBRIGATORIOOCORRENCIA_SHOP,
	     DB_SHOPP_VPOSICAO  OBRIGATORIOPOSICAO_SHOP,
	     USU.USUARIO     
  FROM DB_SHOPPING_PESQ,
       DB_USUARIO    USU
 where db_shopp_dtvalf >= getdate()
   and not exists (    select 1 from DB_SHOPPING_ROTAS where db_shopr_codigo = DB_SHOPP_CODIGO)
union    
SELECT DB_SHOPP_CODIGO    CODIGO_SHOP,
	     DB_SHOPP_DESCR     DESCRICAO_SHOP,
	     DB_SHOPP_VESTOQUE  OBRIGATORIOESTOQUE_SHOP,
	     DB_SHOPP_VFRENTES  OBRIGATORIOFRENTES_SHOP,
	     DB_SHOPP_VOBSERV   OBRIGATORIOOBSERVACAO_SHOP,
	     DB_SHOPP_VOCORR    OBRIGATORIOOCORRENCIA_SHOP,
	     DB_SHOPP_VPOSICAO  OBRIGATORIOPOSICAO_SHOP,
	     USUARIO     
  FROM DB_SHOPPING_PESQ,
       mva_shoppingpesquisarotas
 where db_shopp_dtvalf >= getdate()
   and DB_SHOPP_CODIGO =  SHOPPINGPESQUISA_SPROT
