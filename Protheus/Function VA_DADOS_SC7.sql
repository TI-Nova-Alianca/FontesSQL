--
-- Descricao: Retorna tabela com dados de pedidos de compras.
-- Autor....: Robert Koch
-- Data.....: 15/06/2012
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_DADOS_SC7]

-- PARAMETROS DE CHAMADA
(
	@FILINI      AS VARCHAR(2),
--	@FILFIM      AS VARCHAR(2),
	@PEDITEMINI  AS VARCHAR(10)
--	@PEDITEMFIM  AS VARCHAR(10)

)-- DEFINE TABELA TEMPORARIA A SER RETORNADA PELA FUNCAO
RETURNS @TMP TABLE 
        (
            FILIAL VARCHAR(2) DEFAULT '' NOT NULL,
            NUMERO VARCHAR(6) DEFAULT '' NOT NULL,
            ITEM VARCHAR(4) DEFAULT '' NOT NULL,
            FORNECEDOR VARCHAR(6) DEFAULT '' NOT NULL,
            LOJA VARCHAR(2) DEFAULT '' NOT NULL,
            OBRA VARCHAR(1) DEFAULT '' NOT NULL,
            TIPO VARCHAR(1) DEFAULT '' NOT NULL,
            PROD_SERV VARCHAR(1) DEFAULT '' NOT NULL,
            NOME_FORNEC VARCHAR(40) DEFAULT '' NOT NULL,
            PRODUTO VARCHAR(15) DEFAULT '' NOT NULL,
            DESCRICAO VARCHAR(110) DEFAULT '' NOT NULL,
            QUANTIDADE FLOAT DEFAULT 0 NOT NULL,
            QUANT_ENTREGUE FLOAT DEFAULT 0 NOT NULL,
            UN_MEDIDA VARCHAR(2) DEFAULT '' NOT NULL,
            PRECO_UNIT FLOAT DEFAULT 0 NOT NULL,
            SOLIC_COMPRA VARCHAR(6) DEFAULT '' NOT NULL,
            ITEM_SOLIC VARCHAR(4) DEFAULT '' NOT NULL,
            CONTR_PARCERIA VARCHAR(6) DEFAULT '' NOT NULL,
            ITEM_CONTRATO VARCHAR(4) DEFAULT '' NOT NULL,
            USUARIO VARCHAR(20) DEFAULT '' NOT NULL,
            OBSERVACAO VARCHAR(120) DEFAULT '' NOT NULL,
            RESIDUO VARCHAR(1) DEFAULT '' NOT NULL,
            DT_EMISSAO VARCHAR(8) DEFAULT '' NOT NULL,
            DT_ENTREGA VARCHAR(8) DEFAULT '' NOT NULL,
            NF_COMPRA VARCHAR(6) DEFAULT '' NOT NULL,
            SERIE_NF VARCHAR(3) DEFAULT '' NOT NULL,
            ITEM_NF VARCHAR(4) DEFAULT '' NOT NULL,
            TIT_TIPO VARCHAR(2) DEFAULT '' NOT NULL,
            TIT_NUM VARCHAR(6) DEFAULT '' NOT NULL,
            TIT_PREF VARCHAR(3) DEFAULT '' NOT NULL,
            TIT_PARC VARCHAR(1) DEFAULT '' NOT NULL,
            TIT_VENCTO VARCHAR(8) DEFAULT '' NOT NULL,
            TIT_VALOR FLOAT DEFAULT 0 NOT NULL,
            TIT_SALDO FLOAT DEFAULT 0 NOT NULL,
            TIT_HIST VARCHAR(25) DEFAULT '' NOT NULL,
            TIT_IRRF FLOAT DEFAULT 0 NOT NULL,
            TIT_ISS FLOAT DEFAULT 0 NOT NULL
        )
AS


BEGIN
	-- INSERE DADOS DE NOTAS DE ENTRADA.
	INSERT INTO @TMP
	  (
	    FILIAL,
	    NUMERO,
	    ITEM,
	    NF_COMPRA,
	    SERIE_NF,
	    ITEM_NF,
	    TIT_TIPO,
	    TIT_NUM,
	    TIT_PREF,
	    TIT_PARC,
	    TIT_VENCTO,
	    TIT_VALOR,
	    TIT_SALDO,
	    TIT_IRRF,
	    TIT_ISS,
	    TIT_HIST
	  )
	SELECT D1_FILIAL,
	       D1_PEDIDO,
	       D1_ITEMPC,
	       ISNULL(SD1.D1_DOC, ''),
	       ISNULL(SD1.D1_SERIE, ''),
	       ISNULL(SD1.D1_ITEM, ''),
	       ISNULL(TIT.E2_TIPO, ''),
	       ISNULL(TIT.E2_NUM, ''),
	       ISNULL(TIT.E2_PREFIXO, ''),
	       ISNULL(TIT.E2_PARCELA, ''),
	       ISNULL(TIT.E2_VENCREA, ''),
	       ISNULL(TIT.E2_VALOR * SD1.D1_TOTAL / SF1.F1_VALMERC, 0),  -- PROPORCIONA PELO TOTAL DA NOTA, POIS O TITULO NO SE2 REFERE-SE `A NOTA INTEIRA.
	       ISNULL(TIT.E2_SALDO * SD1.D1_TOTAL / SF1.F1_VALMERC, 0),  -- PROPORCIONA PELO TOTAL DA NOTA, POIS O TITULO NO SE2 REFERE-SE `A NOTA INTEIRA.
	       ISNULL(TIT.E2_IRRF * SD1.D1_TOTAL / SF1.F1_VALMERC, 0),  -- PROPORCIONA PELO TOTAL DA NOTA, POIS O TITULO NO SE2 REFERE-SE `A NOTA INTEIRA.
	       ISNULL(TIT.E2_ISS * SD1.D1_TOTAL / SF1.F1_VALMERC, 0),  -- PROPORCIONA PELO TOTAL DA NOTA, POIS O TITULO NO SE2 REFERE-SE `A NOTA INTEIRA.
	       ISNULL(TIT.E2_HIST, '')
	FROM   SF1010 SF1,
	       SD1010 SD1
	       LEFT JOIN SE2010 TIT
	            ON  (
	                    TIT.D_E_L_E_T_ = ''
	                    AND TIT.E2_FILIAL = SD1.D1_FILIAL
	                    AND TIT.E2_PREFIXO = SD1.D1_SERIE
	                    AND TIT.E2_NUM = SD1.D1_DOC
	                    AND TIT.E2_FORNECE = SD1.D1_FORNECE
	                    AND TIT.E2_LOJA = SD1.D1_LOJA
	                    AND TIT.E2_TIPO = 'NF'
	                )
	WHERE  SD1.D_E_L_E_T_ = ''
	       AND SD1.D1_FILIAL = @FILINI --AND @FILFIM
	       AND SD1.D1_PEDIDO + SD1.D1_ITEMPC = @PEDITEMINI --AND @PEDITEMFIM
	       AND SF1.D_E_L_E_T_ = ''
	       AND SF1.F1_FILIAL = SD1.D1_FILIAL
	       AND SF1.F1_FORNECE = SD1.D1_FORNECE
	       AND SF1.F1_LOJA = SD1.D1_LOJA
	       AND SF1.F1_DOC = SD1.D1_DOC
	       AND SF1.F1_SERIE = SD1.D1_SERIE
	;
	
	
	-- INSERE DADOS DE ADIANTAMENTOS DE VALOR.
	INSERT INTO @TMP
	  (
	    FILIAL,
	    NUMERO,
	    ITEM,
	    TIT_TIPO,
	    TIT_NUM,
	    TIT_PREF,
	    TIT_PARC,
	    TIT_VENCTO,
	    TIT_VALOR,
	    TIT_SALDO,
	    TIT_HIST
	  )
	SELECT E2_FILIAL,
	       SUBSTRING(E2_VACHVEX, 4, 6),
	       SUBSTRING(E2_VACHVEX, 10, 4),
	       E2_TIPO,
	       E2_NUM,
	       E2_PREFIXO,
	       E2_PARCELA,
	       E2_VENCREA,
	       E2_VALOR,
	       E2_SALDO,
	       SE2.E2_HIST
	FROM   SE2010 SE2
	WHERE  SE2.D_E_L_E_T_ = ''
	       AND SE2.E2_FILIAL = @FILINI --AND @FILFIM
	       AND SE2.E2_VACHVEX = 'SC7' + @PEDITEMINI --AND 'SC7' + @PEDITEMFIM
	       AND SE2.E2_TIPO = 'PA'
	; 
	
	-- INSERE DADOS DO SC7 PARA CASOS QUE NAO TEM NOTA DE ENTRADA E NEM ADIANTAMENTO DE VALOR.
	INSERT INTO @TMP
	  (
	    FILIAL,
	    NUMERO,
	    ITEM
	  )
	SELECT C7_FILIAL,
	       C7_NUM,
	       C7_ITEM
	FROM   SC7010 SC7
	WHERE  SC7.D_E_L_E_T_ = ''
	       AND SC7.C7_FILIAL = @FILINI --AND @FILFIM
	       AND C7_NUM + C7_ITEM = @PEDITEMINI --AND @PEDITEMFIM
	       AND NOT EXISTS (
	               SELECT *
	               FROM   @TMP
	               WHERE  FILIAL = C7_FILIAL
	                      AND NUMERO = C7_NUM
	                      AND ITEM = SC7.C7_ITEM
	           )
	; 
	
	
	-- COMPLEMENTA DADOS DOS PEDIDOS.
	UPDATE @TMP
	SET    FORNECEDOR = C7_FORNECE,
	       LOJA = C7_LOJA,
	       OBRA = C7_VAOBRA,
	       TIPO = C7_TIPO,
	       PROD_SERV = SC7.C7_VAPROSE,
	       NOME_FORNEC = SA2.A2_NOME,
	       PRODUTO = SC7.C7_PRODUTO,
	       DESCRICAO = SC7.C7_DESCRI,
	       QUANTIDADE = SC7.C7_QUANT,
	       QUANT_ENTREGUE = SC7.C7_QUJE,
	       UN_MEDIDA = SC7.C7_UM,
	       PRECO_UNIT = SC7.C7_PRECO,
	       SOLIC_COMPRA = CASE 
	                           WHEN C7_TIPO = '1' THEN SC7.C7_NUMSC
	                           ELSE ''
	                      END,
	       ITEM_SOLIC = CASE 
	                         WHEN C7_TIPO = '1' THEN SC7.C7_ITEMSC
	                         ELSE ''
	                    END,
	       CONTR_PARCERIA = CASE 
	                             WHEN C7_TIPO = '2' THEN SC7.C7_NUMSC
	                             ELSE ''
	                        END,
	       ITEM_CONTRATO = CASE 
	                            WHEN C7_TIPO = '2' THEN SC7.C7_ITEMSC
	                            ELSE ''
	                       END,
	       USUARIO = CASE C7_USER
	                      WHEN '000129' THEN 'Alexandre'
	                      WHEN '000118' THEN 'Gilmar'
	                      WHEN '000111' THEN 'Anderson'
	                      WHEN '000093' THEN 'Fernando Matana'
	                      WHEN '000090' THEN 'Mateus'
	                      WHEN '000069' THEN 'Thais'
	                      WHEN '000067' THEN 'Robert'
	                      ELSE C7_USER
	                 END,
	       OBSERVACAO = RTRIM(C7_OBS),
	       RESIDUO = C7_RESIDUO,
	       DT_EMISSAO = C7_EMISSAO,
	       DT_ENTREGA = C7_DATPRF
	FROM   SA2010 SA2,
	       SC7010 SC7,
	       @TMP
	WHERE  SC7.D_E_L_E_T_ = ''
	       AND SA2.D_E_L_E_T_ = ''
	       AND SA2.A2_FILIAL = '  '
	       AND SA2.A2_COD = SC7.C7_FORNECE
	       AND SA2.A2_LOJA = SC7.C7_LOJA
	       AND SC7.C7_FILIAL = FILIAL
	       AND SC7.C7_NUM = NUMERO
	       AND SC7.C7_ITEM = ITEM
	; 
	
	RETURN
END

