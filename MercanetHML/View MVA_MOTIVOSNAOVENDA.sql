---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSNAOVENDA AS
SELECT DB_TBMNVD_CODIGO      CODIGO_MOTNV,
       DB_TBMNVD_DESCR       DESCRICAO_MOTNV,
       DB_TBMNVD_COMENTARIO  COMENTARIO_MOTNV,
       DB_TBMNVD_JUSTNVISITA justnVisita_MOTNV
  FROM DB_TB_MOTIVO_NAOVD
