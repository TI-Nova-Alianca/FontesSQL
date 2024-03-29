ALTER VIEW MVA_CAMPOSETAPAOCULTOS AS
  select camposOcultos.SEQUENCIA			sequencia_CAMPOC,
		 camposOcultos.CODIGO_FLUXO			codigoFluxo_CAMPOC,
		 camposOcultos.CODIGO_ETAPA			codigoEtapa_CAMPOC,
		 camposOcultos.CAMPO_OCULTO			campoOculto_CAMPOC,
		 camposOcultos.ABA_OCULTA			abaOculta_CAMPOC,
		 camposOcultos.AREA_OCULTA			areaOculta_CAMPOC,
		 camposOcultos.TIPO					tipo_CAMPOC,
		 camposOcultos.CAMPO				campo_CAMPOC,
		 camposOcultos.ABA					aba_CAMPOC,
		 camposOcultos.AREA					area_CAMPOC,
		 camposOcultos.OPERADOR				operador_CAMPOC,
		 camposOcultos.VALOR				valor_CAMPOC,
		 camposOcultos.CONSULTA				consulta_CAMPOC,
		 camposOcultos.CRITERIO				criterio_CAMPOC,
		 camposOcultos.CRITERIO_OCULTA		criterioOculta_CAMPOC,
		 camposOcultos.CONSULTA_MOBILE		consultaMobile_CAMPOC,
		 mvaCamposEtapa.usuario
	from DB_FLU_ETA_CAMPOS_OCULTOS 			camposOcultos,
		 MVA_CAMPOS_ETAPA					mvaCamposEtapa
   where camposOcultos.ABA_OCULTA   = mvaCamposEtapa.ABA_ETCAM
     and camposOcultos.AREA_OCULTA  = mvaCamposEtapa.AREA_ETCAM
	 and camposOcultos.CAMPO_OCULTO = mvaCamposEtapa.CAMPO_ETCAM
	 and camposOcultos.CODIGO_FLUXO = mvaCamposEtapa.FLUXO_ETCAM
	 and camposOcultos.CODIGO_ETAPA = mvaCamposEtapa.ETAPA_ETCAM
