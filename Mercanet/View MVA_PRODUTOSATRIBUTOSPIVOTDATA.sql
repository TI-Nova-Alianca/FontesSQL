ALTER VIEW MVA_PRODUTOSATRIBUTOSPIVOTDATA AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		    AUTOR    ALTERACAO
-- 1.0000	04/11/2013 	Alencar	 CRIACAO
-- 1.0001 04/11/2013  Alencar  Envia a data do produto
---------------------------------------------------------------------------------------------------
SELECT codigo_produ   produto_codigo,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2000') at_2000,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2001') at_2001,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2002') at_2002,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2003') at_2003,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2004') at_2004,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2005') at_2005,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2007') at_2007,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2008') at_2008,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2009') at_2009,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2010') at_2010,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2011') at_2011,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2012') at_2012,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2013') at_2013,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2014') at_2014,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2015') at_2015,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2016') at_2016,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2017') at_2017,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2018') at_2018,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2019') at_2019,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2020') at_2020,
    (SELECT db_proda_valor FROM db_produto_atrib WHERE db_proda_codigo = codigo_produ AND db_proda_atrib = '2021') at_2021,
    VPROD.DATAALTER           DATAALTER,
    USU.USUARIO
   FROM DB_USUARIO USU, MVA_PRODUTOS vprod
  WHERE usu.usuario = vprod.USUARIO;
