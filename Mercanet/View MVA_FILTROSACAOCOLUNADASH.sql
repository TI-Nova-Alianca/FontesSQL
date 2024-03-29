---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/02/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FILTROSACAOCOLUNADASH AS
 select CONSULTA		consulta_FILAD,
		COLUNA			coluna_FILAD,
		DASH_DESTINO	dashDestino_FILAD,
		FILTRO_DESTINO	filtroDestino_FILAD,
		COLUNA_ORIGEM	colunaOrigem_FILAD,
		co.USUARIO
   from DB_CONS_FILTR_ACAO_DASH, MVA_CONSULTAS co
  where co.CODIGO_CONSU = CONSULTA
