---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   19/11/2012  TIAGO PRADELLA  INCLUSAO DE CAMPOS DE RESTRICAO
-- 1.0003   21/11/2012  TIAGO PRADELLA  INCLISAO CAMPO DE OBSERVACAO
-- 1.0004   05/04/2013  TIAGO           INCLUIDO FILTRO DA MVA_CONFIGURACOES
-- 1.0005   12/01/2016  tiago           alterado para string o valor que e comparado com a view de configuracoes
-- 1.0006   07/03/2016  tiago           alterado join com a mva_representante
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PREVISOESENTREGAFATU  AS 
with config as (SELECT VALOR_CONFIG, usuario FROM MVA_CONFIGURACOES WHERE NOME_CONFIG = 'CALCULOPREVISAO')
SELECT DB_PENT_CODIGO     CODIGO_PENFA,
	   DB_PENT_TIPO       TIPO_PENFA,
	   DB_PENT_CALCDIA    CALCULODIASEMANA_PENFA,
	   DB_PENT_NPERMALT   ALTERADATA_PENFA,
	   DB_PENT_SOMADTFAT  SOMARDATAS_PENFA,
	   DB_PENT_TPAVAL     TIPOAVALIACAO_PENFA,
	   DB_PENT_OBSERV     OBSERVACAO_PENFA,
	   -----------
	   DB_PENT_EMPRESAS   EMPRESA,
	   DB_PENT_CIDADE     CIDADE,
	   DB_PENT_REGCOM     REGIAOCOMERCIAL,
	   DB_PENT_ESTADOS    UF,
	   DB_PENT_LPRECOS    LISTAPRECO,
	   DB_PENT_RAMOS_ATIV RAMOATIVIDADE,
	   DB_PENT_CLAS_COM   CLASSCOMERCIAL,
	   DB_PENT_CLIENTES   CLIENTE,
	   DB_PENT_TPPED      TIPOPEDIDO,
	   DB_PENT_ROTA       ROTA,
	   DB_PENT_REPRES     REPRES,	   
	   usu.USUARIO
  FROM DB_PREVISAO_ENT, db_usuario usu, config
 WHERE (DB_PENT_SITUACAO = 0 OR DB_PENT_SITUACAO IS NULL) 
   AND DB_PENT_DATA_FIM > GETDATE() 
   and exists (select 1 from mva_representantes where ((DBO.MERCF_VALIDA_LISTA (ISNULL(CODIGO_REPRES, 0), DB_PENT_REPRES, 0,',')) = 1 OR ISNULL(CODIGO_REPRES, '') = '') and mva_representantes.usuario = usu.usuario)
   AND DB_PENT_TIPO = 1
   and config.USUARIO = usu.usuario
   and config.VALOR_CONFIG = '0'
   UNION ALL
   SELECT DB_PENT_CODIGO     CODIGO_PENFA,
	   DB_PENT_TIPO       TIPO_PENFA,
	   DB_PENT_CALCDIA    CALCULODIASEMANA_PENFA,
	   DB_PENT_NPERMALT   ALTERADATA_PENFA,
	   DB_PENT_SOMADTFAT  SOMARDATAS_PENFA,
	   DB_PENT_TPAVAL     TIPOAVALIACAO_PENFA,
	   DB_PENT_OBSERV     OBSERVACAO_PENFA,
	   -----------
	   DB_PENT_EMPRESAS   EMPRESA,
	   DB_PENT_CIDADE     CIDADE,
	   DB_PENT_REGCOM     REGIAOCOMERCIAL,
	   DB_PENT_ESTADOS    UF,
	   DB_PENT_LPRECOS    LISTAPRECO,
	   DB_PENT_RAMOS_ATIV RAMOATIVIDADE,
	   DB_PENT_CLAS_COM   CLASSCOMERCIAL,
	   DB_PENT_CLIENTES   CLIENTE,
	   DB_PENT_TPPED      TIPOPEDIDO,
	   DB_PENT_ROTA       ROTA,
	   DB_PENT_REPRES     REPRES,	   
	   usu.USUARIO
  FROM DB_PREVISAO_ENT, db_usuario usu, config
 WHERE (DB_PENT_SITUACAO = 0 OR DB_PENT_SITUACAO IS NULL) 
   AND DB_PENT_DATA_FIM > GETDATE() 
   and exists (select 1 from mva_representantes where ((DBO.MERCF_VALIDA_LISTA (ISNULL(CODIGO_REPRES, 0), DB_PENT_REPRES, 0,',')) = 1 OR ISNULL(CODIGO_REPRES, '') = '') and mva_representantes.usuario = usu.usuario)
   AND DB_PENT_TIPO = 0
   and config.USUARIO = usu.usuario
   and config.VALOR_CONFIG in ('1', '2')
