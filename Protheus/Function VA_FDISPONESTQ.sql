--
-- Descricao: Retorna tabela com disponibilidade de estoques.
-- Autor....: Robert Koch
-- Data.....: 21/11/2011
--
-- Historico de alteracoes:
-- 27/05/2013 - Robert - Incluida coluna de saldo em poder de terceiros.
-- 01/02/2014 - Robert - Incluida coluna de saldo de terceiros em nosso poder.
-- 06/05/2014 - Robert - Incluida coluna de pedidos de venda liberados.
-- 19/05/2014 - Robert - Incluida coluna de saldos a enderecar.
-- 11/09/2014 - Robert - Passa a considerar somente OPs firmes.
-- 06/11/2015 - Robert - Descricao do produto aumentada de 60 para 70 caracteres.
--                     - Renomeada para VA_FDISPONESTQ
-- 16/11/2017 - Robert - Nao considerava conteudo 'S' no campo C6_BLQ
--

ALTER FUNCTION [dbo].[VA_FDISPONESTQ]
(
	@FILINI         AS VARCHAR(2),
	@FILFIM         AS VARCHAR(2),
	@PRODINI        AS VARCHAR(15),
	@PRODFIM        AS VARCHAR(15),
	@LOCALINI       AS VARCHAR(2),
	@LOCALFIM       AS VARCHAR(2),
	@TIPOINI        AS VARCHAR(2),
	@TIPOFIM        AS VARCHAR(2),
	@UM_SOLICITADA  AS VARCHAR(2)
)

RETURNS @TMP TABLE -- DEFINE TABELA TEMPORARIA A SER RETORNADA PELA FUNCAO
        (
            DATA_POSICAO VARCHAR(8) DEFAULT '' NOT NULL,
            FILIAL VARCHAR(2) DEFAULT '' NOT NULL,
            ACONDICIONAMENTO VARCHAR(8) DEFAULT '' NOT NULL,
            PRODUTO VARCHAR(15) DEFAULT '' NOT NULL,
            DESCRICAO VARCHAR(70) DEFAULT '' NOT NULL,	-- PELO MENOS DO TAMANHO DO B1_DESC PARA EVITAR ERRO 'STRING WILL BE TRUNCATED'
            LOCAL VARCHAR(2) DEFAULT '' NOT NULL,
            LITROS_POR_UNID FLOAT DEFAULT 0 NOT NULL,
            UNID_MEDIDA VARCHAR(2) DEFAULT '' NOT NULL,
            QUANT FLOAT DEFAULT 0 NOT NULL,
            EMP_ENTR_FUT FLOAT DEFAULT 0 NOT NULL,
            EMP_PD_VENDA FLOAT DEFAULT 0 NOT NULL,
            EMP_OP FLOAT DEFAULT 0 NOT NULL,
            RESERVAS FLOAT DEFAULT 0 NOT NULL,
            EM_TERC FLOAT DEFAULT 0 NOT NULL,
            DE_TERC FLOAT DEFAULT 0 NOT NULL,
            EMP_PD_VENDA_LIB FLOAT DEFAULT 0 NOT NULL,
            A_ENDERECAR FLOAT DEFAULT 0 NOT NULL
        )
AS



BEGIN
	-- INSERE POSICAO ATUAL NA TABELA TEMPORARIA
	    INSERT INTO @TMP
	      (
	        FILIAL,
	        ACONDICIONAMENTO,
	        PRODUTO,
	        DESCRICAO,
	        LOCAL,
	        LITROS_POR_UNID,
	        UNID_MEDIDA,
	        QUANT,
	        EM_TERC,
	        DE_TERC
	      )
	    SELECT B2_FILIAL AS FILIAL,
	           CASE SB1.B1_GRPEMB
	                WHEN '18' THEN 'GRANEL'
	                ELSE 'ENVASADO'
	           END AS ACONDICIONAMENTO,
	           B1_COD AS PRODUTO,
	           RTRIM(B1_DESC) AS DESCRICAO,
	           B2_LOCAL AS LOCAL,
	           SB1.B1_LITROS,
	           SB1.B1_UM AS UNID_MEDIDA,
	           B2_QATU AS QUANT,
	           SB2.B2_QNPT,
	           SB2.B2_QTNP
	    FROM   SB1010 SB1,
	           SB2010 SB2
	    WHERE  SB2.D_E_L_E_T_ = ''
	           AND SB2.B2_COD = SB1.B1_COD
	           AND SB2.B2_FILIAL BETWEEN @FILINI AND @FILFIM
	           AND SB2.B2_LOCAL BETWEEN @LOCALINI AND @LOCALFIM
	           AND SB1.D_E_L_E_T_ = ''
	           AND SB1.B1_FILIAL = '  '
	           AND SB1.B1_COD BETWEEN @PRODINI AND @PRODFIM
	           AND SB1.B1_TIPO BETWEEN @TIPOINI AND @TIPOFIM
	
	-- BUSCA EMPENHOS EM VENDA PARA ENTREGA FUTURA.
	    UPDATE @TMP
	    SET    EMP_ENTR_FUT = ISNULL(
	               (
	                   SELECT SUM(ADB_QUANT - ADB_QTDEMP)
	                   FROM   ADB010 ADB,
	                          ADA010 ADA
	                   WHERE  ADA.D_E_L_E_T_ = ''
	                          AND ADA.ADA_FILIAL = ADB.ADB_FILIAL
	                          AND ADA.ADA_NUMCTR = ADB.ADB_NUMCTR
	                          AND ADA.ADA_STATUS IN ('B', 'C') -- B=aprovado; C=parc.entregue
	                          AND ADB.D_E_L_E_T_ = ''
	                          AND ADB.ADB_FILIAL = FILIAL
	                          AND ADB.ADB_LOCAL = LOCAL
	                          AND ADB.ADB_CODPRO = PRODUTO
	               ),
	               0
	           )
	;
	
	
	-- BUSCA EMPENHOS EM PEDIDOS DE VENDA.
	    UPDATE @TMP
	    SET    EMP_PD_VENDA = ISNULL(
	               (
	                   SELECT SUM(C6_QTDVEN - C6_QTDENT)
	                   FROM   SC6010 SC6
	                   WHERE  SC6.D_E_L_E_T_ = ''
	                          AND SC6.C6_FILIAL = FILIAL
	                          AND SC6.C6_PRODUTO = PRODUTO
	                          AND SC6.C6_LOCAL = LOCAL
--	                          AND SC6.C6_BLQ != 'R' -- Eliminado residuo
	                          AND SC6.C6_BLQ NOT in ('R', 'S') -- Eliminado residuo e bloqueio manual
	                          AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	               ),
	               0
	           )
	;
	
	
	-- BUSCA EMPENHOS EM PEDIDOS DE VENDA LIBERADOS.
	    UPDATE @TMP
	    SET    EMP_PD_VENDA_LIB = ISNULL(
	               (
	                   SELECT SUM(C9_QTDLIB)
	                   FROM   SC9010 SC9
	                   WHERE  SC9.D_E_L_E_T_ = ''
	                          AND SC9.C9_FILIAL = FILIAL
	                          AND SC9.C9_PRODUTO = PRODUTO
	                          AND SC9.C9_LOCAL = LOCAL
	                          AND SC9.C9_NFISCAL = ''
	               ),
	               0
	           )
	;


	-- BUSCA EMPENHOS EM ORDENS DE PRODUCAO.
	    UPDATE @TMP
	    SET    EMP_OP = ISNULL(
	               (
	                   SELECT SUM(D4_QUANT)
	                   FROM   SD4010 SD4
	                   WHERE  SD4.D_E_L_E_T_ = ''
	                          AND SD4.D4_FILIAL = FILIAL
	                          AND SD4.D4_COD = PRODUTO
	                          AND SD4.D4_LOCAL = LOCAL
	                          AND EXISTS (
	                                  SELECT *
	                                  FROM   SC2010 SC2
	                                  WHERE  SC2.D_E_L_E_T_ = ''
	                                         AND SC2.C2_FILIAL = SD4.D4_FILIAL
	                                         AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD = SD4.D4_OP
	                                         AND SC2.C2_DATRF = ''
	                                         AND SC2.C2_TPOP = 'F'
	                              )
	               ),
	               0
	           )
	;
	
	
	-- BUSCA EMPENHOS EM RESERVAS PARA FATURAMENTO.
	    UPDATE @TMP
	    SET    RESERVAS = ISNULL(
	               (
	                   SELECT SUM(C0_QUANT)
	                   FROM   SC0010 SC0
	                   WHERE  SC0.D_E_L_E_T_ = ''
	                          AND SC0.C0_FILIAL = FILIAL
	                          AND SC0.C0_PRODUTO = PRODUTO
	                          AND SC0.C0_LOCAL = LOCAL
	               ),
	               0
	           )
	;
	
	
	-- BUSCA SALDOS A ENDERECAR.
	    UPDATE @TMP
	    SET    A_ENDERECAR = ISNULL(
	               (
	                   SELECT SUM(DA_SALDO)
	                   FROM   SDA010 SDA
	                   WHERE  SDA.D_E_L_E_T_ = ''
	                          AND SDA.DA_FILIAL = FILIAL
	                          AND SDA.DA_PRODUTO = PRODUTO
	                          AND SDA.DA_LOCAL = LOCAL
	               ),
	               0
	           )
	;


	-- CONVERTE PARA UNIDADE DE MEDIDA SOLICITADA (CRIAR TRATAMENTO PARA CADA CASO)
	IF (@UM_SOLICITADA = 'LT')
	    UPDATE @TMP
	    SET    UNID_MEDIDA = @UM_SOLICITADA,
	           QUANT = QUANT * LITROS_POR_UNID,
	           EMP_ENTR_FUT = EMP_ENTR_FUT * LITROS_POR_UNID,
	           EMP_PD_VENDA = EMP_PD_VENDA * LITROS_POR_UNID,
	           EMP_OP = EMP_OP * LITROS_POR_UNID,
	           RESERVAS = RESERVAS * LITROS_POR_UNID
	
	RETURN
END

