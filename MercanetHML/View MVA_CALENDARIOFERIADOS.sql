---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CALENDARIOFERIADOS AS
SELECT DB_CALFRD_DATA    DATA_CFERI,
	   DB_CALFRD_TIPO    TIPO_CFERI,
	   DB_CALFRD_LOCAL   LOCAL_CFERI,
	   USU.USUARIO
  FROM DB_CALEND_FERIADO,
       DB_USUARIO    USU
 WHERE CAST(DB_CALFRD_DATA AS DATE) >= CAST(GETDATE() AS DATE)
