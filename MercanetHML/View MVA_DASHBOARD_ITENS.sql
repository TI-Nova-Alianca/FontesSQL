---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	09/02/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_DASHBOARD_ITENS AS
 select	DASHBOARD			dashboard_DASHI,
		ITEM				item_DASHI,
		TIPO				tipo_DASHI,
		TITULO				titulo_DASHI,
		COR_FUNDO			corFundo_DASHI,
		CONSULTA			consulta_DASHI,
		APRESENTAR_TABELA	apresentarTabela_DASHI,
		APRESENTAR_GRAFICO	apresentarGrafico_DASHI,
		APRESENTAR_MAPA		apresentarMapa_DASHI,
		APRESENTAR_CARD		apresentarCard_DASHI,
		POSICAO_HORIZONTAL	posicaoHorizontal_DASHI,
		POSICAO_VERTICAL	posicaoVertical_DASHI,
		ALTURA				altura_DASHI,
		CONSULTA_CARD		consultaCard_DASHI,
		MVA_DASHBOARDS.usuario
   from DB_DASHBOARD_ITEM, MVA_DASHBOARDS
  where DASHBOARD = dashboard_DASH
