---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/11/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDOAUTOMATICOCOLUNAS AS
SELECT  CODIGO             CODIGO_PEAUC,
		PEDIDO_AUTOMATICO  PEDIDOAUTOMATICO_PEAUC,
		COLUNA_PEDIDO      COLUNAPEDIDO_PEAUC,
		COLUNA_CONSULTA    COLUNACONSULTA_PEAUC
  FROM  DB_MOB_PED_AUT_COL
