-- -- 1.009    08/06/2015  tiago          valida parametro MOB_SITUACAOPRODUTO, para a situacao do produto
CREATE  VIEW MVA_PRODUTOS_DELETE AS
SELECT DB_PROD_CODIGO CODIGO_PRODU,
       DB_PROD_ULT_ALTER DATAALTER
  FROM DB_PRODUTO
WHERE  dbo.MERCF_VALIDA_LISTA(upper(DB_PROD_SITUACAO), (select max(db_prms_valor) from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPRODUTO'), 0, ',') <> 1
