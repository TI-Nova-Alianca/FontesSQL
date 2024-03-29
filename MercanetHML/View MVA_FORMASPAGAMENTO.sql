---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	06/02/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FORMASPAGAMENTO AS
SELECT DB_FOPG_CODIGO           CODIGO_FORPG,
       DB_FOPG_DESCR            DESCRICAO_FORPG,
       DB_FOPG_SERVICO_CREDITO  servicoCredito_FORPG,
	   USU.USUARIO
  FROM DB_TB_FORMA_PGTO, DB_USUARIO USU
