---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/01/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   23/02/2015  tiago           incluido o distinct
-- 1.0003   3/08/2015   tiago           melhora de performance
-- 1.0004   07/03/2016  tiago           alterado join com a mva_representantes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PREVISAOPRODUCAO AS
SELECT DB_PREVP_PRODUTO    PRODUTO_PREVPROD, 
		DB_PREVP_SEQ        SEQUENCIA_PREVPROD, 
		DB_PREVP_TIPO       TIPO_PREVPROD, 
		DB_PREVP_ANO        ANO_PREVPROD, 
		DB_PREVP_NRO        NUMERO_PREVPROD, 
		DB_PREVP_EMPRESA    EMPRESA_PREVPROD, 
		DB_PREVP_QTDE_EST   QUANTIDADEESTOQUE_PREVPROD, 
		DB_PREVP_QTDE_VDA   QUANTIDADEVENDA_PREVPROD, 
		DB_PREVP_GRPREP     GRUPOPREVISAOREPRES_PREVPROD, 
		DB_PREVP_DATAALTER  DATAATUALIZACAO_PREVPROD,
		DB_PREVP_GRPREP		grupoRep_PREVPROD,
		DB_PREVP_LOTE		lote_PREVPROD,
		isnull(DB_PREVP_ALMOXAR, '')	almoxar_PREVPROD,
		DB_PREVP_RAMO		ramo_PREVPROD,
		DB_PREVP_ORDCOM		ordCom_PREVPROD,
		usu.USUARIO 
   FROM DB_PREVISAO_PRODUC,
        db_usuario usu, 
        MVA_PERIODOPRODUCAO PERIODO 
  WHERE DB_PREVP_NRO  = PERIODO.NUMERO_PERPROD 
    AND DB_PREVP_TIPO = PERIODO.TIPO_PERPROD 
    AND DB_PREVP_ANO  = PERIODO.ANO_PERPROD
	and (exists (select 1 from MVA_REPRESENTANTES where  GRUPOESTOQUE_REPRES  = DB_PREVP_GRPREP and usu.usuario = MVA_REPRESENTANTES.USUARIO) or DB_PREVP_GRPREP = ' ')
