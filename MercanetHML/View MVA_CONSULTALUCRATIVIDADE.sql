ALTER VIEW MVA_CONSULTALUCRATIVIDADE AS
 select codigo				codigo_CONLUC,
		nome				nome_CONLUC,
		consulta			consulta_CONLUC,
		coluna_consulta		colunaConsulta_CONLUC,
		coluna_lucra		colunaLucratividade_CONLUC,
		campo_lucra			campoLucratividade_CONLUC
   from db_mob_cons_lucra
