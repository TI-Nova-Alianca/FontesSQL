ALTER VIEW MVA_ORCAMENTOPOLITICAS AS
 select 
		DB_ORCD_NRO				orcamento_ORCPO,
		DB_ORCD_SEQIT			sequencia_ORCPO,
		DB_ORCD_INDDESCTO		indice_ORCPO,
		DB_ORCD_DESCONTO		percentualAplicado_ORCPO,
		DB_ORCD_DCTOPOL			percentualCalculado_ORCPO,
		DB_ORCD_TPPOL			tipoPolitica_ORCPO,
		DB_ORCD_CODPOL			politica_ORCPO,
		DB_ORCD_TPDESC			tipoPercentual_ORCPO,
		DB_ORCD_SEQAPLIQ		sequenciaAplicacao_ORCPO,
		DB_ORCD_MODDCTO			alteradoUsuario_ORCPO,
		DB_ORCD_POLMANUAL		politicaManual_ORCPO,
		DB_ORCD_DESCMAXLISTA	descMaxLista_ORCPO,
		MVA_ORCAMENTOS.dataalter,
		MVA_ORCAMENTOS.usuario
   from DB_ORCAMENTO_DPOL,
        MVA_ORCAMENTOS
  where DB_ORCD_NRO = numero_ORC
