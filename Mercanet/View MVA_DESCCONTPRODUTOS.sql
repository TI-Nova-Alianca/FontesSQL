ALTER VIEW MVA_DESCCONTPRODUTOS  AS
select CODIGO   codigo_DESCCONTPROD,
	   PRODUTO	produto_DESCCONTPROD,
	   MVA_PRODUTOS.USUARIO
  from DB_DESCCONTPRODUTOS
      ,MVA_PRODUTOS
	  ,MVA_DESCCONTROLADO
 where CODIGO_PRODU = PRODUTO
   and CODIGO = codigo_DESCCONT
