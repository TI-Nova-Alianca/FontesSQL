---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	05/06/2018	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSOCORRENCIASTIPOS AS
 SELECT CODIGO_MOTIVO CODIGOMOTIVO_MOOTP,
	    CODIGO_TIPO   CODIGOTIPO_MOOTP
   FROM DB_OC_MOTIVO_TIPOS
