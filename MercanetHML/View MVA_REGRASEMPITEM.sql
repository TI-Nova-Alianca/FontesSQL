ALTER VIEW MVA_REGRASEMPITEM AS
SELECT REI.CODIGO    			CODIGO_EMPI,
	   REI.TIPO_REGRA       	TIPOREGRA_EMPI,
	   REI.SITUACAO         	SITUACAO_EMPI,
	   REI.DESCRICAO			descricao_EMPI
  FROM DB_REGRAS_EMP_ITEM		REI	   
 WHERE REI.SITUACAO 	   		= 0
   AND REI.DATA_FINAL >= GETDATE()
