ALTER VIEW  MVA_SERIESGRAFICOCONSULTA  AS
SELECT  CONSULTA        CONSULTA_SERIE,
		SERIE           SERIE_SERIE,
		X               X_SERIE,
		Y               Y_SERIE,
		INVERTER_SERIE  INVERTERSERIEPORX_SERIE,
		TIPO_GRAFICO    TIPOGRAFICO_SERIE,
		USU.USUARIO
   FROM DB_CONS_GRAFICO,
        DB_USUARIO   USU 
  where exists (select 1 from MVA_CONSULTAS where usuario = usu.USUARIO and CONSULTA = codigo_consu )
