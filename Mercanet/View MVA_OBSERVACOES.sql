ALTER VIEW MVA_OBSERVACOES  AS
 select codigo		codigo_OBS,
		titulo		titulo_OBS,
		tipo		tipo_OBS,
		observacao	observacao_OBS	
   from db_observacoes_doc
