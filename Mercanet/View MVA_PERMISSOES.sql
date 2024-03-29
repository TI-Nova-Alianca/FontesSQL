---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/02/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   07/03/2013  tiago           incluido campo de sequencia
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PERMISSOES AS
SELECT CAMPO_TELA             CAMPOTELA_PERM,
	   SEQUENCIA			  SEQUENCIA_PERM,
	   PERMITE_VISUALIZACAO   VISUALIZACAO_PERM,
	   PERMITE_EDICAO         PERMITEEDICAO_PERM,
	   PER.OBRIGATORIO        OBRIGATORIO_PERM,
	   USU.USUARIO
  FROM DB_MOB_PERMISSOES PER, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO
 WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
   AND PER.GRUPO_USUARIO = USU.GRUPO_USUARIO
