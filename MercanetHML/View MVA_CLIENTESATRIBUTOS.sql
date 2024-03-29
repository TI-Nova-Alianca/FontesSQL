---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   27/05/2013  tiago           incluido campo de descricao
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTESATRIBUTOS AS
SELECT DB_CLIA_CODIGO   CLIENTE_ATCLI,
	   DB_CLIA_ATRIB    ATRIBUTO_ATCLI,
	   DB_CLIA_VALOR    VALOR_ATCLI,
	   MVA_CLIENTE.DATAALTER DATAALTER,
	   AT03_descricao   descricao_ATCLI,
	   USUARIO
  FROM DB_CLIENTE_ATRIB left join mat03 on    
		                                AT03_ATRIB = DB_CLIA_ATRIB
									and AT03_CODIGO = DB_CLIA_VALOR,
	   MVA_CLIENTE	   
 WHERE DB_CLIA_CODIGO = CODIGO_CLIEN
