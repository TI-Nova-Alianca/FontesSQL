---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AREASABAS AS
select distinct
        area.CODIGO_CADASTRO		codigo_AREA,
		area.ABA					aba_AREA,
		area.AREA					area_AREA,
		area.TIPO_AREA				tipoArea_AREA,
		area.ORDEM					ordem_AREA,
		area.DESCRICAO				descricao_AREA,
		area.EXIBE_DOIS_BOTOESATIV  exibeDoisBotoes_AREA,
		area.LABEL_INCLUIRATIV		labelIncAtiv_AREA,
		area.LABEL_INCLUIR_FINATIV  labelIncFinAtiv_AREA,
		area.LABEL_CANCELARATIV		labelCancAtiv_AREA,
		FORMATO_VISUALIZACAO		formatoVis_AREA,
		FORMATO_CAMPO_PRINCIPAL		formatoCampoPrincipal_AREA,
		EXPANDIR_RETRAIR			expandirRetrair_AREA,
		FORMATO_INSERCAO			formatoInsercao_AREA,
		COR_FONTE					corFonte_AREA,
		COR_FUNDO					corFundo_AREA,
		GERA_PEDIDO					geraPedido_AREA,
		CORRESPOND_GERA_PEDIDO		correspondGeraPed_AREA,
		SALVAR_INCLUIR				salvarIncluir_AREA,
		SALVAR_INCLUIR_FINATIV		salvarIncFinAtiv_AREA,
		SALVAR_CANCELAR				salvarCancAtiv_AREA,
		LABEL_BOTAO_CARRINHO		labelBotaoCarrinho_AREA,
		LABEL_TITULO_CARRINHO		labelTituloCarrinho_AREA,
		aba.usuario
   from DB_WEB_AREAS_ABAS area
      , MVA_ABAS aba
	  , DB_USUARIO USU
  where aba.codigo_ABA = area.CODIGO_CADASTRO
	and aba.aba_ABA = area.ABA
	and aba.usuario = USU.USUARIO
    and exists (SELECT 1
				  FROM DB_USUARIO_MOBILE
				 WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') >= 2
				           then 1
						   else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) > '2019'
						             then 1
									 else 0 end
						   end) = 1				
				  AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO)
  UNION
 select distinct
        area.CODIGO_CADASTRO		codigo_AREA,
		area.ABA					aba_AREA,
		area.AREA					area_AREA,
		area.TIPO_AREA				tipoArea_AREA,
		area.ORDEM					ordem_AREA,
		area.DESCRICAO				descricao_AREA,
		area.EXIBE_DOIS_BOTOESATIV  exibeDoisBotoes_AREA,
		area.LABEL_INCLUIRATIV		labelIncAtiv_AREA,
		area.LABEL_INCLUIR_FINATIV  labelIncFinAtiv_AREA,
		area.LABEL_CANCELARATIV		labelCancAtiv_AREA,
		FORMATO_VISUALIZACAO		formatoVis_AREA,
		FORMATO_CAMPO_PRINCIPAL		formatoCampoPrincipal_AREA,
		EXPANDIR_RETRAIR			expandirRetrair_AREA,
		FORMATO_INSERCAO			formatoInsercao_AREA,
		COR_FONTE					corFonte_AREA,
		COR_FUNDO					corFundo_AREA,
		GERA_PEDIDO					geraPedido_AREA,
		CORRESPOND_GERA_PEDIDO		correspondGeraPed_AREA,
		SALVAR_INCLUIR				salvarIncluir_AREA,
		SALVAR_INCLUIR_FINATIV		salvarIncFinAtiv_AREA,
		SALVAR_CANCELAR				salvarCancAtiv_AREA,
		LABEL_BOTAO_CARRINHO		labelBotaoCarrinho_AREA,
		LABEL_TITULO_CARRINHO		labelTituloCarrinho_AREA,
		MVA_CAMPOS.usuario
   from DB_WEB_AREAS_ABAS area
      , MVA_CAMPOS
	  , DB_USUARIO USU
  where MVA_CAMPOS.codigo_CAMP = area.CODIGO_CADASTRO
	and MVA_CAMPOS.ABA_CAMP = area.ABA
	and MVA_CAMPOS.AREA_CAMP = area.AREA
	and MVA_CAMPOS.usuario = USU.USUARIO
	and exists (SELECT 1
				  FROM DB_USUARIO_MOBILE
				 WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) <= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') <= 1
				        then 1
						else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) < '2019'
						            then 1
									else 0 end
						end) = 1
					AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO)
