---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   08/11/2012  TIAGO PRADELLA  ACRESCENTADA TABELA DB_MOB_TRANSMI_CONS
-- 1.0003   01/02/2013  ALENCAR         ACRESCENTADO CAMPO ALERTA
-- 1.0004   14/11/2014  TIAGO           INCLUIDO CAMPO PROCESSAMENTO E QUERY
-- 1.0005   25/02/2015  TIAGO           TRAZ OS DADOS DAS CONSULTAS ONDE O PROCESSAMENTO E 1
-- 1.0006   22/04/2015  tiago           incluido campo: longitude e latitude
-- 1.0007   19/08/2015  tiago           incluido campo codigo atributo
-- 1.0008   24/03/2016  tiago           incluido campo permiteExportar
-- 1.0009   25/04/2016  tiago           incluido campos formaApresentacao_CONSU, numeroColunas_CONSU
-- 1.0010   15/02/2017  tiago           incluido campo card
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSULTAS AS
 SELECT C.CODIGO           CODIGO_CONSU,
		C.NOME             NOME_CONSU,
		C.DESCRICAO        DESCRICAO_CONSU,
		C.COLUNA_RETORNO   COLUNARETORNO_CONSU,
		C.RETORNO_MULTIPLO RETORNOMULTIPLO_CONSU,
		C.RETORNO_IMEDIATO RETORNOIMEDIATO_CONSU,
		C.LOCAL            LOCAL_CONSU,
		C.TIPO_RETORNO     TIPORETORNO_CONSU,
		C.ALERTA           ALERTA_CONSU,
		PROCESSAMENTO      PROCESSAMENTO_CONSU,
		CASE WHEN PROCESSAMENTO = 1
		THEN QUERY ELSE '' END         QUERY_CONSU,
		latitude            latitude_CONSU,
		longitude           longitude_CONSU,
		CODIGO_ATRIBUTO     codigoAtributo_CONSU,
		PERMITE_EXPORTAR    permiteExportar_CONSU,
		FORMA_APRESENTACAO  formaApresentacao_CONSU,
		NUMERO_COLUNAS      numeroColunas_CONSU,
		(select top 1 DB_CONS_CARD.CARD from DB_CONS_CARD where DB_CONS_CARD.CONSULTA =  c.CODIGO)                card_CONSU,
		EXPANDIR_AGRUPA     expandirAgrupa_CONSU,
		C.FORMATO_ORDENACAO formatoOrdenacao_CONSU,
		MANTER_ORDENACAO    manterOrdenacao_CONSU,
		ISNULL(C.FILTRO_COLUNAS, 0)	FiltroColunas_CONSU,
		EXECUTA_FILTRO_PADRAO    ExecutaFiltroPadrao_CONSU,
		AGRUPADOR				agrupador_CONSU ,
		PERCMINAGRUP			percMinAgrup_CONSU ,
		USU.USUARIO
   FROM DB_CONS_DINAMICAS C,
		DB_USUARIO    USU,
		DB_MOB_TRANSMI_CONS B
  WHERE USU.CODIGO = B.USUARIO
	AND C.CODIGO = B.CONSULTA
