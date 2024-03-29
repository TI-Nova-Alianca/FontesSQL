---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   22/11/2012  TIAGO PRADELAA  INCLUIDO NOVOS CAMPOS DISCREPAN
-- 1.0002   29/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO PRECO UNIDADES
-- 1.0003   04/12/2012  TIAGO PRADELLA  INCLUIDO CAMPO DE NUMEROP DECIMAIS
-- 1.0004   09/01/2013  TIAGO PRADELLA  INCLUIDO VALIDA LISTA PARA VALIDAR O CAMPO DA EMPRESA
-- 1.0005   25/01/2013  TIAGO PRADELLA  INCLUIDO CAMPOS DE LISTA
-- 1.0006   15/04/2013  TIAGO           INCLUIDO CAMPO DE AVALIACAO
-- 1.0007   20/12/2013  TIAGO           ALTERADO FILTRO DE DATA, PARA PEGAR SOMENTE A DATA SEM A HORA
-- 1.0008   12/05/2014  TIAGO           ALTERADO ALIAS PARA CAMPOS: DB_PRECO_PRM_VALOR E DB_PRECO_PRM_TPVLR
-- 1.0009   21/05/2014  tiago           incluido campo AREAATUACAO
-- 1.0010   22/07/2014  tiago           incluido campo lista bonificacao
-- 1.0011   23/10/2014  tiago           incluido campo TIPODATA_LIPRE
-- 1.0012   21/11/2014  tiago           incluido campo repres
-- 1.0013   01/12/2014  tiago           incluido campo tipo venda, OptanteSimples
-- 1.0014   18/03/2015  tiago           incluido nvl no campo DB_PRECO_UTIDATA
-- 1.0015   27/04/2015  tiago           alterado o campo data alter para buscar primeiro do campo DB_PRECO_DT_ALTER, n�o havendo valor deve pegar do campo DB_PRECO_ALT_CORP 
-- 1.0016   03/08/2015  tiago           incluido campo vendor
-- 1.0017   15/02/2015  tiago           incluido campo tipopedido
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LISTAPRECO_V4 AS
SELECT PRECO.DB_PRECO_CODIGO                  CODIGO_LIPRE,
       PRECO.DB_PRECO_DESCR                   DESCRICAO_LIPRE,
       ISNULL(PRECO.DB_PRECO_PROMOCAO,0)      PROMOCIONAL_LIPRE,
       ISNULL(PRECO.DB_PRECO_PRM_VALOR,0)     VALORMINPROMOCIONAL_LIPRE,
       ISNULL(PRECO.DB_PRECO_PRM_TPVLR,0)     TIPOVALORMINPROMOCIONAL_LIPRE,
       DB_PRECO_DT_ALTER                      DATAALTERACAO_LIPRE,
       DB_PRECO_DATA_INI                      DATAINICIAL_LIPRE,
       DB_PRECO_DATA_FIN                      DATAFINAL_LIPRE,
	   isnull(DB_PRECO_USOPEDIDO, 0)                     USOPEDIDO_LIPRE,
	   case when isnull(DB_PRECO_DT_ALTER, 0) > isnull(DB_PRECO_ALT_CORP, 0) then DB_PRECO_DT_ALTER else DB_PRECO_ALT_CORP end  DATAALTER,
	   DB_PRECO_LST_PMC                       LISTAPMC_LIPRE,
	   DB_PRECO_DMENOR                        DISCREPANCIAMENOR_LIPRE,
       DB_PRECO_DMAIOR                        DISCREPANCIAMAIOR_LIPRE,
	   DB_PRECO_QTDEUN                        PRECOUNIDADES_LIPRE,
	   ISNULL(DB_PRECO_NRODEC, 0)             NUMERODECIMAIS_LIPRE,
	   DB_PRECO_ALT_DESCI                     AVALIACAODESCONTOITEM_LIPRE,
	   isnull(DB_PRECO_PDV, 0)                tipoVenda_LIPRE,
	   isnull(DB_PRECO_OPTSIMPLE, 0)          OptanteSimples_LIPRE,
	   CASE DB_PRECO_VENDOR WHEN 'S' THEN 1 ELSE 0 END vendor_LIPRE,
	   -------------------------------------------------------
	   DB_PRECO_REGCOM                        REGIAOCOMERCIAL,
	   DB_PRECO_RAMOS                         RAMOATIVIDADE ,
	   DB_PRECO_OPERS                         OPERACAOVENDA,
	   DB_PRECO_PRM_CPGTO + DB_PRECO_PRM_CPGT1 CONDICAOPAGAMENTO,
	   DB_PRECO_ESTADOS                       ESTADO,
	   DB_PRECO_CLIENTES                      CLIENTE,
	   DB_PRECO_EMPRESA                       EMPRESA,
	   DB_PRECO_PAIS                          PAIS,
	   DB_PRECO_TPFRETE                       TIPOFRETE,
	   DB_PRECO_AREAATU                       AREAATUACAO,
	   DB_PRECO_LST_BONI					  LISTABONIFICACAO_LIPRE,
	   isnull(DB_PRECO_UTIDATA, 0)            TIPODATA_LIPRE,
	   DB_PRECO_REPRES                        REPRESENTANTE,
	   DB_PRECO_LTPPED                        TIPOPEDIDO,
	   DB_PRECO_LST_PMIN					  LISTAPRECO,
       USU.USUARIO
  FROM DB_USUARIO         USU,
       DB_GRUPO_USUARIOS  GRUPO_USU,
       DB_FILTRO_GRUPOUSU FILTRO,
       DB_PRECO           PRECO
WHERE GRUPO_USU.CODIGO        = USU.GRUPO_USUARIO
   AND FILTRO.CODIGO_GRUPO     = USU.GRUPO_USUARIO
   AND UPPER(FILTRO.ID_FILTRO) = 'LISTAPRECO'                   -- LISTA PRECO
   AND FILTRO.VALOR_STRING     = PRECO.DB_PRECO_CODIGO
   AND PRECO.DB_PRECO_SITUACAO = 'A'
   AND PRECO.DB_PRECO_DATA_FIN >= CAST(GETDATE() AS DATE)
   UNION
   SELECT PRECO.DB_PRECO_CODIGO              CODIGO_LIPRE,
          PRECO.DB_PRECO_DESCR               DESCRICAO_LIPRE,
          ISNULL(PRECO.DB_PRECO_PROMOCAO,0)  PROMOCIONAL_LIPRE,
          ISNULL(PRECO.DB_PRECO_PRM_VALOR,0) VALORMINPROMOCIONAL_LIPRE,
          ISNULL(PRECO.DB_PRECO_PRM_TPVLR,0) TIPOVALORMINPROMOCIONAL_LIPRE,
          DB_PRECO_DT_ALTER                  DATAALTERACAO_LIPRE,
          DB_PRECO_DATA_INI                  DATAINICIAL_LIPRE,
          DB_PRECO_DATA_FIN                  DATAFINAL_LIPRE,
		  isnull(DB_PRECO_USOPEDIDO, 0)                 USOPEDIDO_LIPRE,
		  case when isnull(DB_PRECO_DT_ALTER, 0) > isnull(DB_PRECO_ALT_CORP, 0) then DB_PRECO_DT_ALTER else DB_PRECO_ALT_CORP end  DATAALTER,
		  DB_PRECO_LST_PMC                   LISTAPMC_LIPRE,
		  DB_PRECO_DMENOR                    DISCREPANCIAMENOR_LIPRE,
          DB_PRECO_DMAIOR                    DISCREPANCIAMAIOR_LIPRE,
		  DB_PRECO_QTDEUN                    PRECOUNIDADES_LIPRE,
		  ISNULL(DB_PRECO_NRODEC, 0)         NUMERODECIMAIS_LIPRE,
		  DB_PRECO_ALT_DESCI                 AVALIACAODESCONTOITEM_LIPRE,
		  isnull(DB_PRECO_PDV, 0)            tipoVenda_LIPRE,
		   isnull(DB_PRECO_OPTSIMPLE, 0)     OptanteSimples_LIPRE,
		   CASE DB_PRECO_VENDOR WHEN 'S' THEN 1 ELSE 0 END vendor_LIPRE,
		  -------------------------------------------------------
		  DB_PRECO_REGCOM                    REGIAOCOMERCIAL,
		  DB_PRECO_RAMOS                     RAMOATIVIDADE ,
		  DB_PRECO_OPERS                     OPERACAOVENDA,
		  DB_PRECO_PRM_CPGTO + DB_PRECO_PRM_CPGT1 CONDICAOPAGAMENTO,
		  DB_PRECO_ESTADOS                   ESTADO,
		  DB_PRECO_CLIENTES                  CLIENTE,
		  DB_PRECO_EMPRESA                   EMPRESA,
		  DB_PRECO_PAIS                      PAIS,
		  DB_PRECO_TPFRETE                   TIPOFRETE,
		  DB_PRECO_AREAATU                   AREAATUACAO,
		  DB_PRECO_LST_BONI					 LISTABONIFICACAO_LIPRE,
		  isnull(DB_PRECO_UTIDATA, 0)        TIPODATA_LIPRE,
		  DB_PRECO_REPRES                    REPRESENTANTE,
		  DB_PRECO_LTPPED                    TIPOPEDIDO,
		  DB_PRECO_LST_PMIN					  LISTAPRECO,
          USU.USUARIO
     FROM DB_USUARIO        USU,
          DB_GRUPO_USUARIOS GRUPO_USU,
          DB_PRECO          PRECO,
		  MVA_EMPRESAS      EMP
    WHERE GRUPO_USU.CODIGO = USU.GRUPO_USUARIO
        AND PRECO.DB_PRECO_DATA_FIN >= CAST(GETDATE() AS DATE)
      AND PRECO.DB_PRECO_SITUACAO = 'A'
	  AND USU.USUARIO = EMP.USUARIO
      AND NOT EXISTS
         (SELECT 1
            FROM DB_FILTRO_GRUPOUSU FILTRO
           WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
             AND FILTRO.ID_FILTRO = 'LISTAPRECO')
