---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	20/10/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_POLITICASBONIITENSBONI AS
SELECT ID                  ID_POLBONIIB,
       REGRA			   REGRA_POLBONIIB,
       TIPO				   TIPO_POLBONIIB,
       AVALIACAO		   AVALIACAO_POLBONIIB,
       NIVEL			   NIVEL_POLBONIIB,
       CODIGO			   CODIGO_POLBONIIB,
       SUBCODIGO		   SUBCODIGO_POLBONIIB,
       FORMATO_INCLUSAO	   FORMATOINCLUSAO_POLBONIIB,
       QUANTIDADE		   QUANTIDADE_POLBONIIB
  FROM DB_POLBONI_ITENS_BONI, MVA_POLITICASBONIREGRASFILTROS
WHERE REGRA = REGRA_POLBONIRF
  and SITUACAO = 1
