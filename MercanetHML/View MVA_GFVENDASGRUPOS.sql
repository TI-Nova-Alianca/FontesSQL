ALTER VIEW MVA_GFVENDASGRUPOS AS
select DB_GFVDAG_CODIGO  codigo_GFVDAG,
	   DB_GFVDAG_GRUPO   grupo_GFVDAG,
	   MVA_FORCAVENDAS.usuario
  from DB_GRP_FVENDAS_GRUPOS,
       MVA_FORCAVENDAS
 where codigo_FVENDA = DB_GFVDAG_CODIGO
