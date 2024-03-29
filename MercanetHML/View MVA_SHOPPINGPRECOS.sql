---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   19/10/2012  TIAGO PRADELLA  MUDANCA DO TIPO DE DADO DATE PARA DATETIME
-- 1.0002   07/03/2016  tiago           alterado join com a mva_representantes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPRECOS AS
 SELECT DB_SHOP_PESQUISA                    SHOPPINGPESQUISA_SHPRE,
		DB_SHOP_CLIENTE                     CLIENTE_SHPRE,
		CAST(CONVERT(DATEtime , DB_SHOP_DATA) AS VARCHAR)    DATA_SHPRE,
		DB_SHOP_PRODME                      PRODUTOMERCADO_SHPRE,
		DB_SHOP_CONCOR                      CONCORRENTE_SHPRE,
		DB_SHOP_REPRES                      REPRESENTANTE_SHPRE,
		DB_SHOP_PRECO                       PRECO_SHPRE,
		DB_SHOP_FRENTES                     FRENTES_SHPRE,
		DB_SHOP_POSICAO                     POSICAO_SHPRE,
		DB_SHOP_PROMOTOR                    PROMOTOR_SHPRE,
		DB_SHOP_OBSERV                      OBSERVACAO_SHPRE,
		DB_SHOP_OCORRENCIA                  OCORRENCIA_SHPRE,
		DB_SHOP_ESTOQUE                     ESTOQUE_SHPRE,		
		usu.USUARIO
   FROM db_usuario usu,  DB_SHOPPING
  WHERE DB_SHOP_PESQUISA IN ( SELECT CODIGO_SHOP FROM MVA_SHOPPINGPESQUISA WHERE usu.USUARIO = USUARIO)
	and exists (select 1 from MVA_REPRESENTANTES where CODIGO_REPRES = DB_SHOP_REPRES and usu.usuario = MVA_REPRESENTANTES.USUARIO)
