---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSDEVOLUCAO AS	
 SELECT DB_TBMDEV_CODIGO    CODIGO_MOTDEV,
		DB_TBMDEV_DESCRI    DESCRICAO_MOTDEV
  FROM DB_TB_MOT_DEV
