---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	27/05/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PERGUNTASPARAPESQOPCOES AS
select po.CODIGO_PERGUNTA		codigopergunta_pespero,
       po.SEQUENCIA				sequencia_pespero,
	   po.OPCAO					opcao_pespero,
	   po.PADRAO				padrao_pespero,
	   po.APRESENTA_COMPLEMENTO complemento_pespero,
	   po.TAMANHO_COMPLEMENTO	tamanhocompl_pespero,
	   usu.usuario
  from DB_PESQ_PERGUNTAS_OPCOES po, db_usuario usu
 where exists (select 1
                 from MVA_PERGUNTASPARAPESQUISAS
				where CODIGO_PESPER = po.CODIGO_PERGUNTA
				  and usu.usuario = MVA_PERGUNTASPARAPESQUISAS.usuario)
