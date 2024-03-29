
-- Descricao: Retorna tabela de uma linha com 2 colunas contendo avisos e erros que impediriam a geracao de nota de um pedido de venda.
-- Autor....: Robert Koch
-- Data.....: 27/05/2014
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FPEDIDO_OK_PARA_EMBARQUE] 
-- PARAMETROS DE CHAMADA
(
	@FILIAL  AS VARCHAR(2),
	@PEDIDO  AS VARCHAR(6),
	@MODULO  AS VARCHAR(3)
)
RETURNS TABLE
AS
	RETURN 
	
	SELECT CASE 
	            WHEN SUM(CASE C5_VABLOQ WHEN '' THEN 0 ELSE 1 END) = 0 THEN ''
	            ELSE 'BLQ.GERENCIAL;'
	       END + CASE 
	                  WHEN SUM(CASE C9_BLEST WHEN '' THEN 0 ELSE 1 END) = 0 THEN 
	                       ''
	                  ELSE 'BLQ.ESTQ.;'
	             END + CASE 
	                        WHEN SUM(CASE C9_BLCRED WHEN '' THEN 0 ELSE 1 END) = 
	                             0 THEN ''
	                        ELSE 'BLQ.CREDITO;'
	                   END + CASE 
	                              WHEN SUM(CASE C9_BLVEND WHEN '' THEN 0 ELSE 1 END) 
	                                   = 0 THEN ''
	                              ELSE 'BLQ.VENDAS;'
	                         END + CASE 
	                                    WHEN SUM(CASE C9_BLOQUEI WHEN '' THEN 0 ELSE 1 END) 
	                                         = 0 THEN ''
	                                    ELSE 'OUTROS BLOQ.;'
	                               END + CASE 
	                                          WHEN (
	                                                   SELECT COUNT(*)
	                                                   FROM   SC6010 SC6_2
	                                                   WHERE  SC6_2.C6_FILIAL = 
	                                                          @FILIAL
	                                                          AND SC6_2.C6_NUM = 
	                                                              @PEDIDO
	                                                          AND SC6_2.D_E_L_E_T_ = 
	                                                              ''
	                                                          AND SC6_2.C6_BLQ != 
	                                                              'R'
	                                                          AND SC6_2.C6_QTDVEN 
	                                                              > SC6_2.C6_QTDENT
	                                                          AND NOT EXISTS (
	                                                                  SELECT 
	                                                                         C9_FILIAL
	                                                                  FROM   
	                                                                         SC9010 
	                                                                         SC9_2
	                                                                  WHERE  
	                                                                         SC9_2.C9_PEDIDO = 
	                                                                         SC6_2.C6_NUM
	                                                                         AND 
	                                                                             SC9_2.D_E_L_E_T_ = 
	                                                                             ''
	                                                                         AND 
	                                                                             SC9_2.C9_FILIAL = 
	                                                                             SC6_2.C6_FILIAL
	                                                                         AND 
	                                                                             SC9_2.C9_ITEM = 
	                                                                             SC6_2.C6_ITEM
	                                                              )
	                                               ) = 0 THEN ''
	                                          ELSE 'LIBER.PARCIAL; '
	                                     END AS AVISOS,
	       CASE 
	            WHEN @MODULO = 'FAT' AND SC5.C5_TRANSP = '' THEN 'FALTA TRANSP; '
	            ELSE ''
	       END + CASE 
	                  WHEN (
	                           SC5.C5_VAFEMB != SC5.C5_FILIAL
	                           OR SC5.C5_FILIAL IN ('14')
	                       ) AND (
	                           SELECT COUNT(*)
	                           FROM   ZZ6010 ZZ6
	                           WHERE  ZZ6.ZZ6_FILIAL = '  '
	                                  AND ZZ6.ZZ6_CODPRO = '04'
	                                  AND ZZ6.D_E_L_E_T_ = ''
	                                  AND ZZ6.ZZ6_EMPDES = '01'
	                                  AND (
	                                          (
	                                              SC5.C5_VAFEMB != SC5.C5_FILIAL
	                                              AND ZZ6.ZZ6_FILDES = SC5.C5_VAFEMB
	                                          )
	                                          OR (
	                                                 SC5.C5_FILIAL IN ('14')
	                                                 AND ZZ6.ZZ6_FILDES = SC5.C5_FILIAL
	                                             )
	                                      )
	                                  AND ZZ6.ZZ6_ATIVO = 'S'
	                                  AND ZZ6.ZZ6_RODADO != 'S'
	                       ) > 0 THEN 'FALTA TR.ALM.RET;'
	                  ELSE ''
	             END + CASE 
	                        WHEN @MODULO = 'FAT' AND SC5.C5_TPCARGA = '1'
	                             THEN 'Pedido usa carga;'
	                        ELSE ''
	                   END 
 + CASE 
	                        WHEN @MODULO = 'FAT' AND EXISTS (
	                                 SELECT *
	                                 FROM   DAI010 DAI
	                                 WHERE  DAI.D_E_L_E_T_ = ''
	                                        AND DAI.DAI_FILIAL = SC5.C5_FILIAL
	                                        AND DAI.DAI_PEDIDO = SC5.C5_NUM
	                             ) THEN 'Faturar via OMS;'
	                        ELSE ''
	                   END 
	                   AS ERROS
	FROM   SC9010 SC9,
	       SC5010 SC5
	WHERE  SC9.C9_FILIAL = @FILIAL
	       AND SC9.D_E_L_E_T_ = ' '
	       AND SC9.C9_PEDIDO = @PEDIDO
	       AND SC9.C9_NFISCAL = ''
	       AND SC5.C5_FILIAL = SC9.C9_FILIAL
	       AND SC5.D_E_L_E_T_ = ' '
	       AND SC5.C5_NUM = SC9.C9_PEDIDO
	GROUP BY
	       SC5.C5_TRANSP,
	       SC5.C5_FILIAL,
	       SC5.C5_VAFEMB,
	       SC5.C5_VAPEMB,
	       SC5.C5_NUM, SC5.C5_TPCARGA


