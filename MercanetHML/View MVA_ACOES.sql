---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	27/05/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ACOES AS
SELECT DB_ACOES.CODIGO	CODIGO_ACAO,
       CLIENTE			CLIENTE_ACAO,
	   APLICAR_PESQUISA PESQUISAAPLICADA_ACAO,
	   DATA_INICIAL     DATAINICIAL_ACAO,
	   DATA_FINAL		DATAFINAL_ACAO,
	   SITUACAO			SITUACAO_ACAO,
	   DATA_SITUACAO	DATASITUACAO_ACAO,	
	   USU.USUARIO
  FROM DB_ACOES, DB_USUARIO USU
 WHERE USU.USUARIO = DB_ACOES.USUARIO
   and cast(DATA_FINAL as date) >= cast(getdate() as date)
   and SITUACAO = 0
