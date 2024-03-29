ALTER VIEW MVA_CAMPOSOBRIGA  AS
 select CODIGO_FLUXO    codigoFluxo_COBR,
		CODIGO_ETAPA    codigoEtapa_COBR,
		SEQUENCIA       sequencia_COBR,
		CAMPO_OBRIGA    campoObriga_COBR,
		ABA_OBRIGA      abaObriga_COBR,
		AREA_OBRIGA     areaObriga_COBR,
		TIPO            tipo_COBR,
		CAMPO           campo_COBR,
		ABA             aba_COBR,
		AREA            area_COBR,
		OPERADOR        operador_COBR,
		VALOR           valor_COBR,
		CONSULTA        consulta_COBR,
		CRITERIO        criterio_COBR,
		CRITERIO_OBRIGA criterioObriga_COBR,
		CONSULTA_MOBILE	consultaMobile_COBR,
		MVA_CAMPOS_ETAPA.usuario
   from DB_FLU_ETA_CAMPOS_OBRIGA ob,
        MVA_CAMPOS_ETAPA
  where ob.ABA_OBRIGA   = MVA_CAMPOS_ETAPA.ABA_ETCAM
    and ob.AREA_OBRIGA  = MVA_CAMPOS_ETAPA.AREA_ETCAM
	and ob.CAMPO_OBRIGA = MVA_CAMPOS_ETAPA.CAMPO_ETCAM
	and ob.CODIGO_FLUXO = MVA_CAMPOS_ETAPA.FLUXO_ETCAM
	and ob.CODIGO_ETAPA = MVA_CAMPOS_ETAPA.ETAPA_ETCAM
