ALTER VIEW MVA_CONCEITOSLUCFXACUM  AS
 select codigo			codigo_CFAC,
		sequencia		sequencia_CFAC,
		faixa_inicial	faixaInicial_CFAC,
		faixa_final		faixaFinal_CFAC,
		situacao_pedido	situacao_CFAC
   from db_conc_luc_fxacum
