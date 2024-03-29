---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		  AUTOR			    ALTERACAO
-- 1.0001	15/10/2012	  TIAGO PRADELLA	CRIACAO
-- 1.0001   29/04/2016    tiago             retirado filtro do representatntes, pois na view de rotas ja tras somente as do repres
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPESQUISAROTAS  AS
SELECT DB_SHOPR_CODIGO      SHOPPINGPESQUISA_SPROT,
          DB_SHOPR_ROTAS    ROTA_SPROT,
          USU.USUARIO
  FROM DB_SHOPPING_ROTAS,       
          DB_USUARIO USU,
          db_rotas     
 WHERE DB_ROTAS.DB_ROTA_TIPO IN (2, 3)
   AND DB_SHOPPING_ROTAS.DB_SHOPR_ROTAS IN (SELECT CODIGO_ROTA
                                              FROM MVA_ROTAS
                                             WHERE USU.USUARIO = USUARIO) 
   and DB_SHOPPING_ROTAS.DB_SHOPR_ROTAS = db_rotas.DB_ROTA_CODIGO
