ALTER VIEW MVA_DESCCONTROLADO  AS
 select	CODIGO			codigo_DESCCONT,
		DESCRICAO		descricao_DESCCONT,
		DATA_INICIAL	dataInicial_DESCCONT,
		DATA_FINAL		dataFinal_DESCCONT
   from DB_DESCCONTROLADO
  where cast(DATA_FINAL as date) >= cast(getdate() as date)
