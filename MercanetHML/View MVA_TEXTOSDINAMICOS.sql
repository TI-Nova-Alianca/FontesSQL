---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	29/05/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TEXTOSDINAMICOS AS
SELECT CODIGO			CODIGO_TEXDI,
	   NOME				NOME_TEXDI,
	   CONTEUDO			CONTEUDO_TEXDI,
	   TELA_DINAMICA	TELADINAMICA_TEXDI
  FROM DB_TEXTO_IMPRESSAO
