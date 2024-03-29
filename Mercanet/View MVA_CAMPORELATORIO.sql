ALTER VIEW MVA_CAMPORELATORIO  AS
---------------------------------------------------------------------------------------------------------------------------------------
-- versao   data        autor          alteracao
-- 1.002    05/06/2014  tiago          alterado campo TAMANHO_CAMPOREL
-- 1.003    15/09/2015  tiago          alterado join entre as tabelas, colocando um like, pois agora o valor pode vir no formato 'DADOS_1', 'DADOS_2'
---------------------------------------------------------------------------------------------------------------------------------------
   SELECT CAMPO.MODELO            AS MODELO_CAMPOREL,
          CAMPO.AREA			  AS AREA_CAMPOREL,
          CAMPO.CAMPO			  AS CAMPO_CAMPOREL,
          CAMPO.COLUNA			  AS COLUNA_CAMPOREL,
          CAMPO.ORDEM			  AS ORDEM_CAMPOREL,
          CAMPO.LABEL             AS LABEL_CAMPOREL,
          CAMPO.EXIBE_DESCRICAO   AS EXIBEDESCRICAO_CAMPOREL,
          CAMPO.COR_FONTE		  AS CORFONTE_CAMPOREL,
          CAMPO.EXIBE_TOTALIZADOR AS EXIBETOTALIZADOR_CAMPOREL,
          CAMPO.EXIBE_NULO		  AS EXIBENULO_CAMPOREL,
          CAMPO.ALINHAMENTO       AS ALINHAMENTO_CAMPOREL,
          CAMPOSIS.DESCRICAO	  AS DESCRICAO_CAMPOREL,
          CAMPO.TAMANHO           AS TAMANHO_CAMPOREL,
          CAMPOSIS.DESCRICAO_PARAMSISTEMA AS DESCPARAMSISTEMA_CAMPOREL,
		  CAMPO.VARIAVEL          AS variavel_CAMPOREL,
          USU.USUARIO		      AS USUARIO
     FROM DB_CAMPO_RELATORIO CAMPO,
          DB_SIS_CAMPOS_REL CAMPOSIS,
          DB_USUARIO USU
    WHERE CAMPO.MODELO IN (SELECT MODELO_MODREL
                             FROM MVA_MODELORELATORIO
                            WHERE USUARIO = USU.USUARIO
							  and CAMPOSIS.TIPO_MODELO = tipomodelo_modrel)
	  AND CAMPO.AREA like CAMPOSIS.AREA + '%'
	  AND CAMPO.CAMPO = CAMPOSIS.CAMPO
	  union all
	  SELECT CAMPO.MODELO            AS MODELO_CAMPOREL,
          CAMPO.AREA			  AS AREA_CAMPOREL,
          CAMPO.CAMPO			  AS CAMPO_CAMPOREL,
          CAMPO.COLUNA			  AS COLUNA_CAMPOREL,
          CAMPO.ORDEM			  AS ORDEM_CAMPOREL,
          CAMPO.LABEL             AS LABEL_CAMPOREL,
          CAMPO.EXIBE_DESCRICAO   AS EXIBEDESCRICAO_CAMPOREL,
          CAMPO.COR_FONTE		  AS CORFONTE_CAMPOREL,
          CAMPO.EXIBE_TOTALIZADOR AS EXIBETOTALIZADOR_CAMPOREL,
          CAMPO.EXIBE_NULO		  AS EXIBENULO_CAMPOREL,
          CAMPO.ALINHAMENTO       AS ALINHAMENTO_CAMPOREL,
          ''	  AS DESCRICAO_CAMPOREL,
          CAMPO.TAMANHO           AS TAMANHO_CAMPOREL,
          ''					  AS DESCPARAMSISTEMA_CAMPOREL,
		  CAMPO.VARIAVEL          AS variavel_CAMPOREL,
          USU.USUARIO		      AS USUARIO
     FROM DB_CAMPO_RELATORIO CAMPO,          
          DB_USUARIO USU
    WHERE CAMPO.MODELO IN (SELECT MODELO_MODREL
                             FROM MVA_MODELORELATORIO
                            WHERE USUARIO = USU.USUARIO
							  and tipomodelo_modrel IN (1,2))  
	 and isnull(CAMPO.VARIAVEL, '') <> ''
