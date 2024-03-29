ALTER VIEW MVA_VARIAVEIS  AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	12/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT VARIAVEL				VARIAVEL_VAR,
       DB_VARIAVEIS.NOME	NOME_VAR,
	   PROCESSAMENTO		PROCESSAMENTO_VAR,
	   FORMULA				FORMULA_VAR,
	   CONSULTA_DINAMICA	CONSULTADINAMICA_VAR,
	   COLUNA_CONSULTA      colunaConsulta_VAR,
	   VALOR_TOTAL			valorTotal_VAR,
	   usu.usuario
  FROM DB_VARIAVEIS, DB_USUARIO USU
  where exists (
				SELECT 1
				FROM DB_USUARIO_MOBILE
				WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') >= 9
				           then 1
						   else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) > '2019'
						             then 1
									 else 0 end
						   end) = 1				
				  AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO
				)			
union
SELECT VARIAVEL				VARIAVEL_VAR,
       DB_VARIAVEIS.NOME	NOME_VAR,
	   PROCESSAMENTO		PROCESSAMENTO_VAR,
	   replace(FORMULA, '¬', ' ')				FORMULA_VAR,
	   CONSULTA_DINAMICA	CONSULTADINAMICA_VAR,
	   COLUNA_CONSULTA      colunaConsulta_VAR,
	   VALOR_TOTAL			valorTotal_VAR,
	   usu.usuario
  FROM DB_VARIAVEIS, DB_USUARIO USU
  where    exists (
					SELECT 1
					FROM DB_USUARIO_MOBILE
					WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) <= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') < 9
				           then 1
						   else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) < '2019'
						             then 1
									 else 0 end
						   end) = 1
					 AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO
				   )
