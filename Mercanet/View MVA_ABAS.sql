---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ABAS AS
 select distinct 
		aba.CODIGO_CADASTRO		codigo_ABA,
		aba.ABA					aba_ABA,
		aba.LABEL				label_ABA,
		aba.ORDEM				ordem_ABA,
		MVA_TELAS.usuario
   from DB_WEB_ABAS aba
      , MVA_TELAS
	  , DB_USUARIO USU
  where MVA_TELAS.codigo_TELA = aba.CODIGO_CADASTRO
        and MVA_TELAS.usuario = USU.USUARIO
        and exists (SELECT 1
				  FROM DB_USUARIO_MOBILE
				 WHERE (case when  SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2019' and replace(SUBSTRING(VERSAO_UTILIZADA, 6, 2), '.', '') >= 2
				           then 1
						   else case when   SUBSTRING(VERSAO_UTILIZADA, 1, 4) > '2019'
						             then 1
									 else 0 end
						   end) = 1				
				  AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO		)
   UNION
 select distinct 
		aba.CODIGO_CADASTRO		codigo_ABA,
		aba.ABA					aba_ABA,
		aba.LABEL				label_ABA,
		aba.ORDEM				ordem_ABA,
		MVA_CAMPOS.usuario
   from DB_WEB_ABAS aba
      , MVA_CAMPOS, DB_USUARIO USU
  where MVA_CAMPOS.aba_CAMP = aba.ABA
    and MVA_CAMPOS.codigo_CAMP = aba.CODIGO_CADASTRO
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
