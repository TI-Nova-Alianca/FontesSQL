---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   08/10/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   05/02/2015  tiago              incluida condicao DB_PED_SITUACAO in (2, 3, 4) 
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SUGESTAOITENSPEDIDO  AS
  SELECT DB_PED_NRO          PEDIDO_SUGI,
         DB_PEDI_SEQUENCIA   SEQUENCIA_SUGI,
		 DB_PEDI_PRODUTO     PRODUTO_SUGI,
		 DB_PEDI_QTDE_ATEND  QUANTIDADEATENDIDA_SUGI,
		 DB_PEDI_TIPO        TIPO_SUGI,
		 DB_PEDI_SITUACAO    SITUACAO_SUGI,
		 DB_PEDI_QTDE_SOLIC  QUANTIDADESOLICITADA_SUGI,
		 DB_PEDI_QTDE_CANC   QUANTIDADECANCELADA_SUGI,
		 DB_PED_CLIENTE      CLIENTE_SUGI,
		 DB_PED_DT_EMISSAO   DATAEMISSAO_SUGI,
		 USUARIO
  FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_USUARIO
 WHERE DB_PED_NRO = DB_PEDI_PEDIDO
   AND DB_PED_REPRES = CODIGO_ACESSO
   AND DB_PED_DT_EMISSAO > GETDATE() -30
   and db_pedi_tipo <> 'B'
   and DB_PED_SITUACAO in (2, 3, 4)
