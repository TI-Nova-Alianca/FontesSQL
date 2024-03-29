ALTER VIEW MVA_MOEDACOTACAO AS
SELECT DB_MOEC_CODIGO			codigo_MOEC,
       DB_MOEC_DATA				data_MOEC,
	   DB_MOEC_VALOR			valor_MOEC,
       MVA_MOEDA.USUARIO
  FROM DB_MOEDA_COTACAO, MVA_MOEDA
 WHERE DB_MOEC_CODIGO = codigo_MOE
   and cast(DB_MOEC_DATA as date) >= cast(getdate() - cast((select db_prms_valor from DB_PARAM_SISTEMA where db_prms_id = 'PED_NUMDIASBUSCARCOTACAOMOEDA') as int) as date)
