---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   22/10/2012  TIAGO PRADELLA  COLOCADA CONDICAO 'ISNULL = 0' NOS CAMPOS DB_TBPGTO_GERAFAT E DB_TBPGTO_TIPOCOB
-- 1.003    23/11/2012  TIAGO PRADELLA  ALTERADO PARA TRAZER SITUACAO = 'NULL', QUE � VALIDA
-- 1.004    25/01/2013  TIAGO PRADELLA  INCLUIDO CAMPOS DE LISTA
-- 1.005    03/09/2013  TIAGO           INCLUIDO CAMPOS DE CLIENTES E RAMO ATIVIDADE
-- 1.006    22/01/2014  TIAGO           INCLUIDO NOVOS CAMPOS PROJETO CARGA PESADA
-- 1.007    30/052014   TIAGO           INCLUIDO CAMPO DIAS_CPGTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONDICOESPAGAMENTO AS
   SELECT DISTINCT COND_PGTO.DB_TBPGTO_COD	       CODIGO_CPGTO,
          COND_PGTO.DB_TBPGTO_DESCR	               DESCRICAO_CPGTO,
          COND_PGTO.DB_TBPGTO_PRZMED	           PRAZOMEDIO_CPGTO,
          COND_PGTO.DB_TBPGTO_NPARC	               NUMEROPARCELAS_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_BLOQPED, 0)   AVALIACAOCREDITO_CPGTO,
          ISNULL(DB_TBPGTO_MIXVDA, 0)              SOMENTEMIXVENDA_CPGTO,
		  ISNULL(DB_TBPGTO_TPCOMERC, 0)            TIPOCOMERCIAL_CPGTO,
		  ISNULL(DB_TBPGTO_GERAFAT, 0)             GERAFATURAMENTO_CPGTO,
		  ISNULL(DB_TBPGTO_TIPOCOB, 0)             TIPOCOBRANCA_CPGTO,
          ISNULL(DB_TBPGTO_ACRESC, 0)              ACRESCIMO_CPGTO,		  
		  ISNULL(COND_PGTO.DB_TBPGTO_TAXA_FIN, 0)  TAXAFINANCEIRA_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_PORTADOR, 0)  PORTADOR_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_VENDOR, 0)    VENDOR_CPGTO, 
		  CASE WHEN REPLACE(cast(DB_TBPGTO_DIAS1 as varchar)  + '/' + cast(DB_TBPGTO_DIAS2 as varchar)  + '/' + cast(DB_TBPGTO_DIAS3 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS4 as varchar)  + '/' + cast(DB_TBPGTO_DIAS5 as varchar)  + '/' + cast(DB_TBPGTO_DIAS6 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS7 as varchar)  + '/' + cast(DB_TBPGTO_DIAS8 as varchar)  + '/' + cast(DB_TBPGTO_DIAS9 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS10 as varchar) + '/' + cast(DB_TBPGTO_DIAS11 as varchar) + '/' + cast(DB_TBPGTO_DIAS12 as varchar), '/0', '') = '0' 
            THEN NULL ELSE
                        (REPLACE(cast(DB_TBPGTO_DIAS1 as varchar)  + '/' + cast(DB_TBPGTO_DIAS2 as varchar)  + '/' + cast(DB_TBPGTO_DIAS3 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS4 as varchar)  + '/' + cast(DB_TBPGTO_DIAS5 as varchar)  + '/' + cast(DB_TBPGTO_DIAS6 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS7 as varchar)  + '/' + cast(DB_TBPGTO_DIAS8 as varchar)  + '/' + cast(DB_TBPGTO_DIAS9 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS10 as varchar) + '/' + cast(DB_TBPGTO_DIAS11 as varchar) + '/' + cast(DB_TBPGTO_DIAS12 as varchar), '/0', ''))   END DIAS_CPGTO, 
		 cast(isnull(DB_TBPGTO_PERC1, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC2, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC3, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC4, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC5, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC6, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC7, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC8, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC9, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC10, 0) as varchar) + '/' + cast(isnull(DB_TBPGTO_PERC11, 0) as varchar) + '/' + cast(isnull(DB_TBPGTO_PERC12, 0) as varchar)		percentuais_CPGTO ,         
		  -----------------------------------------
		  DB_TBPGTO_EMPRESAS	                   EMPRESA,
		  DB_TBPGTO_LCLSCOM	                       CLASSICOMERCIAL,
		  DB_TBPGTO_LSTTPPED	                   TIPOPEDIDO,
		  DB_TBPGTO_PORTS	                       PORTADOR,
		  DB_TBPGTO_CLIENTES                       CLIENTE,
	      DB_TBPGTO_RAMOATIV                       RAMOATIVIDADE,
		  DB_TBPGTO_INFORMATIVA                    INFORMATIVA_CPGTO,
		  DB_TBPGTO_EXIGEDIAS1					   exigeDias1_CPGTO,
		  DB_TBPGTO_EXIGEOBS					   exigeObservacao_CPGTO,
		  DB_TBPGTO_FORMATOPARCELA				   formatoParcela_CPGTO,
		  DB_TBPGTO_NAODUPMINIMA                   naoDupMinima_CPGTO,
		  DB_TBPGTO_NAOLIMCREDUTILIZADO			   naoLimiteCredUtilizado_CPGTO,
		  DB_TBPGTO_LSTREP						   REPRESENTANTE,
		  DB_TBPGTO_FILTROUNIFICADO				   validaFiltros_CPGTO,
          USU.USUARIO USUARIO		  
     FROM DB_USUARIO		 USU,
          DB_GRUPO_USUARIOS  GRUPO_USU,
          DB_FILTRO_GRUPOUSU FILTRO,
          DB_TB_CPGTO		 COND_PGTO
    WHERE GRUPO_USU.CODIGO = USU.GRUPO_USUARIO
      AND FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
      AND FILTRO.ID_FILTRO = 'CONDPGTO'               -- CONDICAOPAGAMENTO
      AND FILTRO.VALOR_NUM = COND_PGTO.DB_TBPGTO_COD
	  AND (COND_PGTO.DB_TBPGTO_SITUACAO = 'A' OR ISNULL(COND_PGTO.DB_TBPGTO_SITUACAO, '') = '' )
	  AND (DBO.MERCF_VALIDA_LISTA( USU.CODIGO_ACESSO, COND_PGTO.DB_TBPGTO_LSTREP, 0 , ',') = 1 OR COND_PGTO.DB_TBPGTO_FILTROUNIFICADO = 1)
	  AND ISNULL(
		(SELECT VALOR_NUM
		   FROM DB_FILTRO_GRUPOUSU FILTRO
          WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
            AND FILTRO.ID_FILTRO = 'VALIDAFILTROCPGTO')
		, 0) = 0
   UNION
   SELECT DISTINCT COND_PGTO.DB_TBPGTO_COD		   CODIGO_CPGTO,
          COND_PGTO.DB_TBPGTO_DESCR		           DESCRICAO_CPGTO,
          COND_PGTO.DB_TBPGTO_PRZMED 	           PRAZOMEDIO_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_NPARC, 0)	   NUMEROPARCELAS_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_BLOQPED, 0)   AVALIACAOCREDITO_CPGTO,
          ISNULL(DB_TBPGTO_MIXVDA, 0)              SOMENTEMIXVENDA_CPGTO,
		  ISNULL(DB_TBPGTO_TPCOMERC, 0)            TIPOCOMERCIAL_CPGTO,
		  ISNULL(DB_TBPGTO_GERAFAT, 0)             GERAFATURAMENTO_CPGTO,
		  ISNULL(DB_TBPGTO_TIPOCOB, 0)             TIPOCOBRANCA_CPGTO,
		  ISNULL(DB_TBPGTO_ACRESC, 0)              ACRESCIMO_CPGTO,
		  ISNULL(COND_PGTO.DB_TBPGTO_TAXA_FIN, 0)  TAXAFINANCEIRA_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_PORTADOR, 0)  PORTADOR_CPGTO,
          ISNULL(COND_PGTO.DB_TBPGTO_VENDOR, 0)    VENDOR_CPGTO, 
		  CASE WHEN REPLACE(cast(DB_TBPGTO_DIAS1 as varchar)  + '/' + cast(DB_TBPGTO_DIAS2 as varchar)  + '/' + cast(DB_TBPGTO_DIAS3 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS4 as varchar)  + '/' + cast(DB_TBPGTO_DIAS5 as varchar)  + '/' + cast(DB_TBPGTO_DIAS6 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS7 as varchar)  + '/' + cast(DB_TBPGTO_DIAS8 as varchar)  + '/' + cast(DB_TBPGTO_DIAS9 as varchar) + '/' + 
                            cast(DB_TBPGTO_DIAS10 as varchar) + '/' + cast(DB_TBPGTO_DIAS11 as varchar) + '/' + cast(DB_TBPGTO_DIAS12 as varchar), '/0', '') = '0' 
            THEN NULL ELSE
                        (REPLACE(cast(DB_TBPGTO_DIAS1 as varchar)  + '/' + cast(DB_TBPGTO_DIAS2 as varchar)  + '/' + cast(DB_TBPGTO_DIAS3 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS4 as varchar)  + '/' + cast(DB_TBPGTO_DIAS5 as varchar)  + '/' + cast(DB_TBPGTO_DIAS6 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS7 as varchar)  + '/' + cast(DB_TBPGTO_DIAS8 as varchar)  + '/' + cast(DB_TBPGTO_DIAS9 as varchar) + '/' + 
                                 cast(DB_TBPGTO_DIAS10 as varchar) + '/' + cast(DB_TBPGTO_DIAS11 as varchar) + '/' + cast(DB_TBPGTO_DIAS12 as varchar), '/0', ''))   END DIAS_CPGTO,
		  cast(isnull(DB_TBPGTO_PERC1, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC2, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC3, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC4, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC5, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC6, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC7, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC8, 0) as varchar)  + '/' + cast(isnull(DB_TBPGTO_PERC9, 0) as varchar) + '/' + 
			cast(isnull(DB_TBPGTO_PERC10, 0) as varchar) + '/' + cast(isnull(DB_TBPGTO_PERC11, 0) as varchar) + '/' + cast(isnull(DB_TBPGTO_PERC12, 0) as varchar)		percentuais_CPGTO ,
		  -----------------------------------------
		  DB_TBPGTO_EMPRESAS	                   EMPRESA,
		  DB_TBPGTO_LCLSCOM	                       CLASSICOMERCIAL,
		  DB_TBPGTO_LSTTPPED	                   TIPOPEDIDO,
		  DB_TBPGTO_PORTS	                       PORTADOR,
		  DB_TBPGTO_CLIENTES                       CLIENTE,
	      DB_TBPGTO_RAMOATIV                       RAMOATIVIDADE,
		  DB_TBPGTO_INFORMATIVA                    INFORMATIVA_CPGTO,
		  DB_TBPGTO_EXIGEDIAS1					   exigeDias1_CPGTO,
		  DB_TBPGTO_EXIGEOBS					   exigeObservacao_CPGTO,
		  DB_TBPGTO_FORMATOPARCELA				   formatoParcela_CPGTO,
		  DB_TBPGTO_NAODUPMINIMA                   naoDupMinima_CPGTO,
		  DB_TBPGTO_NAOLIMCREDUTILIZADO			   naoLimiteCredUtilizado_CPGTO,
		  DB_TBPGTO_LSTREP						   REPRESENTANTE,
		  DB_TBPGTO_FILTROUNIFICADO				   validaFiltros_CPGTO,
          USUARIO
     FROM DB_USUARIO		USU,
          DB_GRUPO_USUARIOS GRUPO_USU,
          DB_TB_CPGTO		COND_PGTO
    WHERE GRUPO_USU.CODIGO = USU.GRUPO_USUARIO
	 AND (COND_PGTO.DB_TBPGTO_SITUACAO = 'A' OR ISNULL(COND_PGTO.DB_TBPGTO_SITUACAO, '') = '' )
	 AND (NOT EXISTS (SELECT 1
                        FROM DB_FILTRO_GRUPOUSU FILTRO
                       WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
                         AND FILTRO.ID_FILTRO = 'CONDPGTO') -- CONDICAOPAGAMENTO;;;;
                          OR 
                     (SELECT ISNULL(VALOR_NUM, 0)
                        FROM DB_FILTRO_GRUPOUSU FILTRO
                       WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
                         AND FILTRO.ID_FILTRO = 'VALIDAFILTROCPGTO') = 1 )
