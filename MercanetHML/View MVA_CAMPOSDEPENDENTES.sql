ALTER VIEW MVA_CAMPOSDEPENDENTES  AS
 select distinct depen.SEQUENCIA	sequencia_CDEPEND,
		depen.CODIGO_FLUXO			codigoFluxo_CDEPEND,
		depen.CODIGO_ETAPA			codigoEtapa_CDEPEND,
		depen.CAMPO_DEPENDENTE		campoDepend_CDEPEND,
		depen.ABA_DEPENDENTE		abaDepend_CDEPEND,
		depen.AREA_DEPENDENTE		areaDepend_CDEPEND,
		depen.VALOR_DEPENDENTE		valorDepend_CDEPEND,
		depen.CAMPO					campo_CDEPEND,
		depen.ABA					aba_CDEPEND,
		depen.AREA					area_DEPEND,
		depen.OPERADOR				operador_CDEPEND,
		depen.VALOR					valor_CDEPEND,
		depen.CRITERIO				criterio_CDEPEND,
		depen.CRITERIO_DEPENDENTE	criterioDepend_CDEPEND,
		usuario
   from DB_FLU_ETA_CAMPOS_DEPENDENTE depen, MVA_AREASABAS
  where aba_AREA = ABA_DEPENDENTE
	and area_AREA = AREA_DEPENDENTE
