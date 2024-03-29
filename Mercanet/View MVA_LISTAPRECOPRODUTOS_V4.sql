---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   07/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO DATA DEW ALTERACAO
-- 1.003    20/02/2013  tiago           incluido funcao MERCF_PIECE validando o campo valor_string,
--                                      pegando somente a parte da lista que corresponde ao grupo
-- 1.004    21/02/2013  tiago           condicao para trazer familias que pertencam ao grupo cadastrado para o usuario
-- 1.005    10/06/2013  tiago           incluido campo uf
-- 1..06    08/10/2013  tiago           incluido campo de empresa faturamento
-- 1.007    16/02/2014  tiago           converte para varchar a sequencia
-- 1.008    05/06/2014  tiago           incluido campo preco minimo
-- 1.009    08/06/2015  tiago           valida parametro MOB_SITUACAOPRODUTO, para a situacao do produto
-- 1.010    24/09/2015  tiago           retirado filtro de repres, esta sende realizado na view de produtos
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LISTAPRECOPRODUTOS_V4 AS
SELECT DB_PRECOP_CODIGO   LISTAPRECO_LIPRP,
       DB_PRECOP_PRODUTO  PRODUTO_LIPRP,
       DB_PRECOP_VALOR    PRECO_LIPRP,
  	   cast(DB_PRECOP_SEQ as varchar)      SEQUENCIA_LIPRP,
  	   DB_PRECOP_DTVALI   DATAINICIAL_LIPRP,
  	   DB_PRECOP_DTVALF   DATAFINAL_LIPRP,  	   
	   CASE  WHEN isnull(DB_PRECOP_DTALTER, 0) > isnull(DB_PRECOP_ALT_CORP, 0) THEN DB_PRECOP_DTALTER ELSE DB_PRECOP_ALT_CORP END DATAALTER,
	   DB_PRECOP_DESCTO   DESCONTO_LIPRP,
	   DB_PRECOP_ESTADO   UF_LIPRP,
	   DB_PRECOP_EMPFAT   EMPRESAFATURAMENTO_LIPRP,
	   DB_PRECOP_VLRMIN   PRECOMINIMO_LIPRP,
	   isnull(DB_PRECOP_INFCOMIS, 0)	informaComissao_LIPRP,
	   DB_PRECOP_PERCCOMIS			percentualComissao_LIPRP,
	   isnull(DB_PRECOP_DESCMAX, 0) descontoMaximo_LIPRP,
	   DB_PRECOP_EMPRESAS EMPRESA,
  	   PRODUSU.USUARIO
  FROM DB_PRECO_PROD PRECO,
       DB_PRODUTO_USUARIO PRODUSU,   
	   MVA_LISTAPRECO	   
 WHERE DB_PRECOP_DTVALF >= cast(getdate() as date)   
   AND DB_PRECOP_SITUACAO in('A', 'a')   
   AND MVA_LISTAPRECO.CODIGO_LIPRE = DB_PRECOP_CODIGO
   AND MVA_LISTAPRECO.usuario      = PRODUSU.usuario   
   AND DB_PRECOP_PRODUTO           = PRODUSU.produto
