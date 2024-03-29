---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   21/09/2016  tiago           valida parametro DEV_NUMMESESNOTA
-- 1.0003   24/10/2016  tiago           envia notas onde DB_NOTA_FATUR = 0
-- 1.0004   24/10/216   tiago           valida parametro DEV_TIPONOTA
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_NOTASFISCAISSIMPLIFICADO AS	
 SELECT DB_NOTA_NRO         NUMERO_NTSIMP,
		DB_NOTA_SERIE       SERIE_NTSIMP,
		DB_NOTA_EMPRESA     EMPRESA_NTSIMP,
		DB_NOTA_CLIENTE     CLIENTE_NTSIMP,
		DB_NOTA_DT_EMISSAO  DATAEMISSAO_NTSIMP,
		USU.USUARIO
   FROM DB_NOTA_FISCAL,	
        DB_USUARIO USU
  WHERE EXISTS (SELECT 1
                  FROM MVA_CLIENTE
				 WHERE CODIGO_CLIEN = DB_NOTA_CLIENTE
				   AND USU.USUARIO = MVA_CLIENTE.USUARIO)
	AND DB_NOTA_DT_EMISSAO > DATEADD(MONTH, -(select top 1 cast(DB_PRMS_VALOR as int) - 1 from DB_PARAM_SISTEMA where db_prms_id = 'DEV_NUMMESESNOTA'),DATEADD(MM, DATEDIFF(MM,0,DATEADD (MM, 0, GETDATE())), 0))
	and dbo.mercf_valida_lista(DB_NOTA_FATUR, (select db_prms_valor situacao from DB_PARAM_SISTEMA  where db_prms_id = 'DEV_TIPONOTA'), 0, ',') = 1
