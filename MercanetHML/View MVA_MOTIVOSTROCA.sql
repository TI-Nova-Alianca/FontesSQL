ALTER VIEW  MVA_MOTIVOSTROCA AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	04/09/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT DB_MOTT_CODIGO	    CODIGO_MOTTR,
	   DB_MOTT_DESCRICAO	DESCRICAO_MOTTR
  FROM DB_MOTIVO_TROCA
