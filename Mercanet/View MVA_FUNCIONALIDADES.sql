---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	11/11/2014	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FUNCIONALIDADES  AS
SELECT FUNCIONALIDADE	FUNCIONALIDADE_PERMF,
	   LABEL	        LABEL_PERMF,
	   EXIBIR	        EXIBIR_PERMF,
	   TELA				TELA_PERMF,
	   TIPO				TIPO_PERMF,
	   ORDEM			ordem_PERMF,
	   EXIBE_FICHA_CLIENTE	exibeFichaCliente_PERMF,
	   LABEL_FICHA_CLIENTE	labelFichaCliente_PERMF,
	   USU.USUARIO
  FROM DB_MOB_FUNCIONALIDADES, DB_USUARIO USU
 WHERE DB_MOB_FUNCIONALIDADES.GRUPO_USUARIO = USU.GRUPO_USUARIO
