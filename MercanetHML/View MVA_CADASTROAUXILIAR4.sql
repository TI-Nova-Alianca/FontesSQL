ALTER VIEW MVA_CADASTROAUXILIAR4 AS
 select CODIGO		codigo_AUX4,
		DESCRICAO	descricao_AUX4,
		ABREVIATURA abreviatura_AUX4,
		SITUACAO	situacao_AUX4
   from DB_AUX_4
  where SITUACAO = 1
