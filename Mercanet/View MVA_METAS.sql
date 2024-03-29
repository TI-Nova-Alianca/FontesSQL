---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   15/01/2013  TIAGO PRADELLA  CONDICAO DE DATA MAIS DE ANO E MES ATUAL
-- 1.0003   22/01/2013  TIAGO PRADELLA  INCLUIDO SUB-SELECT PARA PEGAR QUANTIDADE DA META REAL
-- 1.0004   15/04/2013  Tiago			alterado o campo DB_METAR_QTDE para DB_METAR_QTDE_VDA no item QUANTIDADEVENDA_META
-- 1.0005   07/03/2016  tiago           alterado join com a mva_representantes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_METAS AS
 SELECT DB_METAC_ANOMES						ANOMES_META,
		COTA.DB_PERC_DATAINI				DATAINICIAL_META,
		COTA.DB_PERC_DATAFIN				DATAFINAL_META,
		DB_METAC_PRODUTO					PRODUTO_META,
		DB_METAC_EMPRESA					EMPRESA_META,
		ISNULL(DB_METAC_QTDE, 0) -    ISNULL((SELECT SUM(DB_METAR_QTDE_VDA) 
												FROM DB_METAS_REAL 
											   WHERE DB_METAC_REPRES = DB_METAR_REPRES 
												 AND DB_METAC_ANOMES = DB_METAR_ANOMES
												 AND DB_METAC_PRODUTO = DB_METAR_PRODUTO
												 AND DB_METAC_EMPRESA = DB_METAR_EMPRESA), 0)      QUANTIDADEVENDA_META,
		ISNULL(DB_METAC_VALOR, 0) -   ISNULL((SELECT SUM(DB_METAR_VALOR)
											    FROM DB_METAS_REAL 
											   WHERE DB_METAC_REPRES = DB_METAR_REPRES 
											     AND DB_METAC_ANOMES = DB_METAR_ANOMES
											     AND DB_METAC_PRODUTO = DB_METAR_PRODUTO
											     AND DB_METAC_EMPRESA = DB_METAR_EMPRESA), 0)     VALORVENDA_META,
		ISNULL(DB_METAC_QTDBONI, 0) - ISNULL((SELECT SUM(DB_METAR_QTDBONI)
											    FROM DB_METAS_REAL 
											   WHERE DB_METAC_REPRES = DB_METAR_REPRES 
											     AND DB_METAC_ANOMES = DB_METAR_ANOMES
											     AND DB_METAC_PRODUTO = DB_METAR_PRODUTO
											     AND DB_METAC_EMPRESA = DB_METAR_EMPRESA), 0) QUANTIDADEBONIFICACAO_META,
		ISNULL(DB_METAC_VLRBONI, 0) - ISNULL((SELECT SUM(DB_METAR_VLRBONI)
											    FROM DB_METAS_REAL 
											   WHERE DB_METAC_REPRES = DB_METAR_REPRES 
											     AND DB_METAC_ANOMES = DB_METAR_ANOMES
											     AND DB_METAC_PRODUTO = DB_METAR_PRODUTO
											     AND DB_METAC_EMPRESA = DB_METAR_EMPRESA), 0) VENDABONIFICACAO_META,
		usu.USUARIO							USUARIO
   FROM DB_METAS_COTA T LEFT JOIN DB_PERIODO_COTA COTA ON (COTA.DB_PERC_CODIGO = T.DB_METAC_ANOMES), 
        db_usuario usu
  WHERE DB_METAC_ANOMES >= SUBSTRING(CONVERT(VARCHAR, GETDATE(), 111), 1,7)
	and exists (select 1 from MVA_REPRESENTANTES where CODIGO_REPRES = t.db_metac_repres and usu.usuario = usuario)
