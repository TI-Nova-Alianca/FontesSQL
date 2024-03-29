ALTER VIEW MVA_AREAGEOABRANGENCIA AS
 SELECT CODIGO_AREA		codigo_AGEO,
		SEQUENCIA	    sequencia_AGEO,
		ESTADO	        estado_AGEO,
		CIDADE	        cidade_AGEO,
		BAIRRO	        bairro_AGEO,
		CEP_INICIAL	    cepInicial_AGEO,
		CEP_FINAL	    cepFinal_AGEO,
		repres.usuario
   FROM DB_AREA_GEO_ABRANG, MVA_REPRESENTANTES repres 
  WHERE CODIGO_AREA = repres.areaGeografica_REPRES
