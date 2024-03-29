---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTEITENSCONTROLADOS AS
SELECT CODIGO_CLIEN          CLIENTE_CLIIC, 
       MVA_CLIENTE.DATAALTER DATAALTER , 
	   DB_GRIC_CODIGO        ITEM_CLIIC, 
	   USUARIO 
  FROM DB_GRPITEM_CONTR, 
       MVA_CLIENTE  
 WHERE ISNULL(ITEMCONTROLADO, '') != ''
   AND (DBO.MERCF_VALIDA_LISTA (DB_GRIC_CODIGO , ITEMCONTROLADO, 0, ',')) = 1
