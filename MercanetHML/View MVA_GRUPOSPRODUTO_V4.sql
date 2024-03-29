---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   20/02/2013  tiago           incluido funcao MERCF_PIECE validando o campo valor_string,
--                                      pegando somente a parte da lista que corresponde ao grupo 
-- 1.0003   18/02/2014  tiago           alterado join das tabelas para quem nao tem grupo informado
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_GRUPOSPRODUTO_V4 AS
SELECT distinct GRUPO.DB_GRUPO_COD        CODIGO_GRPRO,
       GRUPO.DB_GRUPO_DESCRICAO  DESCRICAO_GRPRO,
       GRUPO.DB_GRUPO_FAMILIA    FAMILIA_GRPRO,
       produsu.USUARIO
  FROM DB_TB_GRUPO         GRUPO,
       db_produto_usuario   produsu,
       db_produto prod
 WHERE prod.db_prod_codigo = produsu.produto    
   and prod.db_prod_grupo   = GRUPO.DB_GRUPO_COD
   and prod.db_prod_familia = GRUPO.DB_GRUPO_FAMILIA
