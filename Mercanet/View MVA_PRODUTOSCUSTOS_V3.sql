
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	11/12/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_PRODUTOSCUSTOS_V3 AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario, DATAALTER
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

 SELECT DB_CUSTO_PRODUTO		PRODUTO_PRODCU,
		DB_CUSTO_ANO			ANO_PRODCU,
		DB_CUSTO_MES		    MES_PRODCU,
		DB_CUSTO_TIPO		    TIPO_PRODCU,	
		DB_CUSTO_EMPRESA		EMPRESA_PRODCU,
		DB_CUSTO_MATPRIM		CUSTOMATERIAPRIMA_PRODCU ,		
		DB_CUSTO_MAOOBRA		CUSTOMAOOBRA_PRODCU,
		DB_CUSTO_FIXO           CUSTOFIXO_PRODCU,
		PR.USUARIO		
   FROM DB_CUSTO_PROD, PROD PR
  WHERE PR.PRODUTO = DB_CUSTO_PRODUTO
    AND CONVERT(DATE, CAST(DB_CUSTO_ANO AS VARCHAR) + '/' + REPLICATE ( '0' ,2 - LEN(DB_CUSTO_MES) )  + CAST(DB_CUSTO_MES AS VARCHAR) + '/01', 111)  >=  CONVERT(DATE, DATEADD(MONTH, -1,DATEADD(MM, DATEDIFF(MM,0,DATEADD (MM, 0, GETDATE())), 0)), 111)
	and CONVERT(DATE, CAST(DB_CUSTO_ANO AS VARCHAR) + '/' + REPLICATE ( '0' ,2 - LEN(DB_CUSTO_MES) )  + CAST(DB_CUSTO_MES AS VARCHAR) + '/01', 111)  <= DATEADD(d, -DAY(GETDATE()),DATEADD(m,1,GETDATE()))
	AND (SELECT ISNULL(DB_PRM_LCPED_ANAL, 0) FROM DB_PARAMETRO) <> 0
