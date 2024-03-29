---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAMPOS AS
  select campos.CODIGO_CADASTRO				codigo_CAMP,
		 campos.ABA							aba_CAMP,
		 campos.AREA						area_CAMP,
		 campos.CAMPO						campo_CAMP,
		 campos.COLUNA						coluna_CAMP,
		 campos.ORDEM						ordem_CAMP,
		 campos.COLUNA_GRID					colunaGrid_CAMP,
		 campos.LABEL						label_CAMP,
		 0									editavel_CAMP,
		 0									obrigatorio_CAMP,
		 campos.DESTAQUE					destaque_CAMP,
		 campos.COR_FONTE					corFonte_CAMP,
		 campos.FONTE						fonte_CAMP,
		 campos.APRESENTACAO_FONTE			apresentacaoFonte_CAMP,
		 campos.TIPO_COMPONENTE				tipoComponente_CAMP,
		 campos.TAMANHO						tamanho_CAMP,
		 campos.TIPO_GRID					tipoGrid_CAMP,
		 campos.VARIAVEL					variavel_CAMP,
		 campos.NOME_TABELA					nomeTabela_CAMP,
		 campos.CONSULTA_DINAMICA_MOBILE	consultaDinamica_CAMP,
		 campos.CORRESPOND_COLUNAS_MOBILE	correspondConsDinamica_CAMP,
		 campos.COLUNA_CONSULTA_MOBILE		colunaConsulta_CAMP,
		 COLUNA_ORIGEM_COPIA				colunaOrigemCopia_CAMP,
	     APRESENTA_TOTALIZADOR				apresentaTotalizador_CAMP,
	     APRESENTA_AGRUPADOR				apresentaAgrupador_CAMP,
	     APRESENTACAO_SISTEMA				apresentacaoSistema_CAMP,
		 campos.VALOR_UNICO_GRID            valorUnicoGrid_CAMP,
		 USU.usuario,
		 campos.COR_TEXTO					corTexto_CAMP,
		 campos.DADOS_DISTINTOS             dadosRepetidos_CAMP,
		 NUMERO_MAXIMO_ANEXOS				numeroMaxAnexos_CAMP,
		 campos.FORMULA						formula_CAMP,
		 campos.NUMERO_DECIMAIS				numeroDec_CAMP,
		 campos.GRAVA_CAMPO_ETAPA			gravaCampoEta_CAMP,
		 TAMANHO_TELA						tamanhoTela_CAMP,
		 campos.DASHBOARD					dashboard_CAMP,
		 campos.VALOR_RETORNO				valorRetorno_CAMP,
		 campos.PERMITE_VALOR_NEGATIVO		permiteValorNegativo_CAMP,
		 campos.CONSULTA_DINAMICA_CAMPO		consultaDinCampo_CAMP,
		 campos.COLUNA_CONSULTA_GRAVA		colunaConsGrava_CAMP,
		 campos.ICONE						icone_CAMP,
		 campos.CAMPO_AGRUPADOR				campoAgrupador_CAMP,
		 campos.VALIDAR_REGISTROS_GRID		validarRegistrosGrid_CAMP,
		 campos.ANEXO_FORMATO				anexoFormato_CAMP,
		 campos.PEDIDO_AUTOMATICO			pedidoAutomatico_CAMP,
		 campos.MASCARA						mascara_CAMP,
		 CONSULTA_DINAMICA_CAMPO_MOB		consultaDinCampoMob_CAMP,
		 COLUNA_CONSULTA_GRAVA_MOB			colunaConsGravaMob_CAMP,
		 campos.APRESENTACAO_TELA			apresentacaoTela_CAMP
	from DB_WEB_CAMPOS campos	    
		,DB_USUARIO USU
   where campos.CAMPO in (select campo
							from DB_FLU_ETA_CAMPOS,
								 MVA_TELAS
						   where MVA_TELAS.fluxo_TELA = DB_FLU_ETA_CAMPOS.CODIGO_FLUXO				  
				             and MVA_TELAS.usuario = USU.USUARIO)	  
	and exists (SELECT 1
				  FROM DB_USUARIO_MOBILE
				 WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') >= 2
				           then 1
						   else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) > '2019'
						             then 1
									 else 0 end
						   end) = 1				
				  AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO)
	 and (APRESENTACAO_SISTEMA <> 2 OR ISNULL(APRESENTACAO_SISTEMA, '') = '')
  UNION
  select campos.CODIGO_CADASTRO				codigo_CAMP,
		 campos.ABA							aba_CAMP,
		 campos.AREA						area_CAMP,
		 campos.CAMPO						campo_CAMP,
		 campos.COLUNA						coluna_CAMP,
		 campos.ORDEM						ordem_CAMP,
		 campos.COLUNA_GRID					colunaGrid_CAMP,
		 campos.LABEL						label_CAMP,
		 campo_flu.EDITAVEL					editavel_CAMP,
		 campo_flu.OBRIGATORIO				obrigatorio_CAMP,
		 campos.DESTAQUE					destaque_CAMP,
		 campos.COR_FONTE					corFonte_CAMP,
		 campos.FONTE						fonte_CAMP,
		 campos.APRESENTACAO_FONTE			apresentacaoFonte_CAMP,
		 campos.TIPO_COMPONENTE				tipoComponente_CAMP,
		 campos.TAMANHO						tamanho_CAMP,
		 campos.TIPO_GRID					tipoGrid_CAMP,
		 campos.VARIAVEL					variavel_CAMP,
		 campos.NOME_TABELA					nomeTabela_CAMP,
		 campos.CONSULTA_DINAMICA_MOBILE	consultaDinamica_CAMP,
		 campos.CORRESPOND_COLUNAS_MOBILE	correspondConsDinamica_CAMP,
		 campos.COLUNA_CONSULTA_MOBILE		colunaConsulta_CAMP,
		 COLUNA_ORIGEM_COPIA				colunaOrigemCopia_CAMP,
	     APRESENTA_TOTALIZADOR				apresentaTotalizador_CAMP,
	     APRESENTA_AGRUPADOR				apresentaAgrupador_CAMP,
	     APRESENTACAO_SISTEMA				apresentacaoSistema_CAMP,
		 campos.VALOR_UNICO_GRID            valorUnicoGrid_CAMP,
		 MVA_TELAS.usuario,
		 campos.COR_TEXTO					corTexto_CAMP,
		 campos.DADOS_DISTINTOS             dadosRepetidos_CAMP,
		 NUMERO_MAXIMO_ANEXOS				numeroMaxAnexos_CAMP,
		 campos.FORMULA						formula_CAMP,
		 campos.NUMERO_DECIMAIS				numeroDec_CAMP,
		 campos.GRAVA_CAMPO_ETAPA			gravaCampoEta_CAMP,
		 TAMANHO_TELA						tamanhoTela_CAMP,
		 campos.DASHBOARD					dashboard_CAMP,
		 campos.VALOR_RETORNO				valorRetorno_CAMP,
		 campos.PERMITE_VALOR_NEGATIVO		permiteValorNegativo_CAMP,
		 campos.CONSULTA_DINAMICA_CAMPO		consultaDinCampo_CAMP,
		 campos.COLUNA_CONSULTA_GRAVA		colunaConsGrava_CAMP,
		 campos.ICONE						icone_CAMP,
		 campos.CAMPO_AGRUPADOR				campoAgrupador_CAMP,
		 campos.VALIDAR_REGISTROS_GRID		validarRegistrosGrid_CAMP,
		 campos.ANEXO_FORMATO				anexoFormato_CAMP,
		 campos.PEDIDO_AUTOMATICO			pedidoAutomatico_CAMP,
		 campos.MASCARA						mascara_CAMP,
		 CONSULTA_DINAMICA_CAMPO_MOB		consultaDinCampoMob_CAMP,
		 COLUNA_CONSULTA_GRAVA_MOB			colunaConsGravaMob_CAMP,
		 campos.APRESENTACAO_TELA			apresentacaoTela_CAMP
	from DB_WEB_CAMPOS campos
	   , DB_FLUXOS
	   , DB_FLU_ETAPAS  etapas
	   , DB_FLU_ETA_CAMPOS campo_flu
	   , MVA_TELAS
	   , DB_USUARIO USU
   where DB_FLUXOS.TELA			= tela_TELA
	 and DB_FLUXOS.TIPO			= tipo_TELA
	 and etapas.CODIGO_FLUXO	= DB_FLUXOS.FLUXO
	 and etapas.ETAPA_INICIAL	= 1
	 and campo_flu.CODIGO_FLUXO = etapas.CODIGO_FLUXO
	 and campo_flu.CODIGO_ETAPA = etapas.CODIGO_ETAPA
	 and campo_flu.VISIVEL		= 1	 	 
	 and campos.ABA				= campo_flu.aba
	 and campos.AREA			= campo_flu.area
	 and campos.campo			= campo_flu.CAMPO
	 and campos.CODIGO_CADASTRO	= MVA_TELAS.codigo_TELA
	 and MVA_TELAS.usuario      = USU.USUARIO
	 and (APRESENTACAO_SISTEMA <> 2 OR ISNULL(APRESENTACAO_SISTEMA, '') = '')
     and exists (SELECT 1
				  FROM DB_USUARIO_MOBILE
				 WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) <= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') <= 1
				        then 1
						else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) < '2019'
						            then 1
									else 0 end
						end) = 1
					AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO)
