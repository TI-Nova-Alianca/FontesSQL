ALTER VIEW MVA_BLOQ_V_VALORES AS
 select codigo			codigo_BLOQVV,
		sequencia		sequencia_BLOQVV,
		agrupamento		agrupamento_BLOQVV,
		valor			valor_BLOQVV,
		data_inicial	dataInicial_BLOQVV,
		data_final		dataFinal_BLOQVV
   from db_bloq_v_valores
      , MVA_BLOQ_V_AGRUPAMENTO
  where cast(data_final as date) >= cast(GETDATE() as date)
    and MVA_BLOQ_V_AGRUPAMENTO.codigo_BLOQV = db_bloq_v_valores.codigo
