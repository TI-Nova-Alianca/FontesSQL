--
-- Descricao: Retorna tabela com dados das ultimas n compras do produto
-- Autor....: Robert koch
-- Data.....: 08/12/2008
--
-- Historico de alteracoes:
-- 14/01/2009 - Robert - Incluida coluna com valor do conhecimento de frete
-- 30/01/2011 - Robert - Incluidas colunas extras para conferencias do usuario.
--                     - Calculo do frete passa a ser dividido pelo total do produto
--                       na NF origem (casos raros onde o mesmo produto consta mais
--                       de uma vez (ex. NF 003741).
-- 28/08/2012 - Robert - Passa a usar subquery para deixar o valor do frete jah calculado,
--                       para que possa ser usado no calculo do custo de reposicao.
--                     - Passa a abater PIS e COFINS do custo de reposicao calculado.
-- 28/04/2013 - Robert - Passa a receber parametros de filial inicial e final.
-- 08/01/2020 - Robert - Incluida coluna D1_CUSTO.
-- 01/05/2020 - Robert - Ordenava resultado por [D1_DTDIGIT DESC]. Agora passa a ser [D1_DTDIGIT DESC, D1_DOC, D1_FORNECE] para algum caso de 2 notas no mesmo dia.
-- 03/07/2020 - Robert - Criada coluna SEQ com a numeracao sequencial, para auxiliar quando quiser saber se estou na ultima (1) compra, penultima (2), antepenultima (3)...
--

ALTER FUNCTION [dbo].[VA_ULTCOMP]
(
	@FILINI         AS VARCHAR(2),
	@FILFIM         AS VARCHAR(2),
	@PRODUTO        AS VARCHAR(15),
	@QT_ULT_COMPRAS AS INT
)
RETURNS TABLE
AS

RETURN 
SELECT TOP(@QT_ULT_COMPRAS)
		ROW_NUMBER() OVER (ORDER BY D1_DTDIGIT DESC, SUB.D1_FORNECE, SUB.D1_DOC) AS SEQ
		, SUB.*,
       -- ACRESCENTA COLUNA COM O CUSTO DE REPOSICAO UNITARIO CALCULADO.
       (
           SUB.D1_TOTAL +
           SUB.D1_SEGURO +
           SUB.D1_DESPESA - 
           SUB.D1_VALDESC -
           CASE SUB.F4_CREDICM -- CREDITA ICMS CFE. PARAMETRIZADO NO TES
                WHEN 'S' THEN SUB.D1_VALICM
                ELSE 0
           END
           + SUB.CONHFRETE
           - SUB.D1_VALIMP6
           - SUB.D1_VALIMP5
       )
       / SUB.D1_QUANT AS CUSREPUNI
FROM   (
           -- DEFINE SUBQUERY PARA CALCULAR O VALOR DO FRETE ANTES DE USA-LO NO CALCULO DO CUSTO DE REPOSICAO.
           SELECT TOP(@QT_ULT_COMPRAS) 
                  SD1.D1_FILIAL,
                  SD1.D1_DOC,
                  SD1.D1_SERIE,
                  SD1.D1_FORNECE,
                  SD1.D1_LOJA,
                  SD1.D1_ITEM,
                  SD1.D1_DTDIGIT,
                  SD1.D1_TOTAL,
                  SD1.D1_VALFRE,
                  SD1.D1_SEGURO,
                  SD1.D1_DESPESA,
                  SD1.D1_VALDESC,
                  SD1.D1_VALIPI,
                  SD1.D1_VALICM,
                  SD1.D1_QUANT,
                  SD1.D1_TIPO,
                  SF4.F4_CODIGO,
                  SF4.F4_CREDICM,
                  -- ACRESCENTA COLUNA COM VALOR DO CONHECIMENTO DE FRETE.
                  (
                      SELECT ISNULL(
                                 SUM(
                                     SD1F.D1_TOTAL - 
                                     CASE SF4F.F4_CREDICM -- CREDITA ICMS CFE. PARAMETRIZADO NO TES
                                          WHEN 'S' THEN SD1F.D1_VALICM
                                          ELSE 0
                                     END
                                 ),
                                 0
                             ) * SD1.D1_QUANT
                      FROM   SF8010 SF8,
                             SD1010 SD1F,
                             SF4010 SF4F
                      WHERE  SF8.F8_NFORIG = SD1.D1_DOC
                             AND SF8.F8_SERORIG = SD1.D1_SERIE
                             AND SF8.F8_FORNECE = SD1.D1_FORNECE
                             AND SF8.F8_LOJA = SD1.D1_LOJA
                             AND SF8.D_E_L_E_T_ = ''
                             AND SF8.F8_FILIAL = SD1.D1_FILIAL
                             AND SF8.F8_TIPO = 'F'
                             AND SD1F.D1_DOC = SF8.F8_NFDIFRE
                             AND SD1F.D1_SERIE = SF8.F8_SEDIFRE
                             AND SD1F.D1_FORNECE = SF8.F8_TRANSP
                             AND SD1F.D1_LOJA = SF8.F8_LOJTRAN
                             AND SD1F.D1_COD = SD1.D1_COD
                             AND SD1F.D_E_L_E_T_ = ''
                             AND SD1F.D1_FILIAL = SD1.D1_FILIAL
                             AND SF4F.F4_CODIGO = SD1F.D1_TES
                             AND SF4F.D_E_L_E_T_ = ''
                             AND SF4F.F4_FILIAL = '  '
                  ) / (
                      -- MULTIPLICA VALOR DO FRETE PELA QUANTIDADE DO ITEM E DIVIDE PELA QUANT.TOTAL DA NF DE
                      -- COMPRA PARA ATENDER CASOS ONDE O MESMO PRODUTO CONSTA MAIS DE UMA VEZ NA NF DE ENTRADA
                      -- E O FRETE DEVE SER RATEADO ENTRE TODOS ELES, POIS O CONHECIMENTO DE FRETE EH AMARRADO
                      -- COM A NF ORIGINAL APENAS PELO CODIGO DO PRODUTO E NAO PELO ITEM DA NOTA.
                      SELECT SUM(TODOS.D1_QUANT)
                      FROM   SD1010 TODOS
                      WHERE  TODOS.D1_FILIAL = SD1.D1_FILIAL
                             AND TODOS.D_E_L_E_T_ = ''
                             AND TODOS.D1_DOC = SD1.D1_DOC
                             AND TODOS.D1_SERIE = SD1.D1_SERIE
                             AND TODOS.D1_FORNECE = SD1.D1_FORNECE
                             AND TODOS.D1_LOJA = SD1.D1_LOJA
                             AND TODOS.D1_COD = SD1.D1_COD
                             AND TODOS.D1_TES = SD1.D1_TES
                  ) AS CONHFRETE,
                  SD1.D1_VALIMP6,
                  SD1.D1_VALIMP5,
				  SD1.D1_CUSTO
           FROM   SF4010 SF4,
                  SD1010 SD1
           WHERE  SD1.D1_COD = @PRODUTO
                  AND SD1.D_E_L_E_T_ = ''
                  AND SD1.D1_FILIAL BETWEEN @FILINI AND @FILFIM
                  AND SD1.D1_TIPO = 'N'
                  AND SD1.D1_QUANT != 0
                  AND SF4.D_E_L_E_T_ = ''
                  AND SF4.F4_FILIAL = '  '
                  AND SF4.F4_CODIGO = SD1.D1_TES
                  AND SF4.F4_ESTOQUE = 'S'
                  AND SF4.F4_DUPLIC = 'S'
           ORDER BY
                  D1_DTDIGIT DESC
       ) AS SUB
ORDER BY
       D1_DTDIGIT DESC, D1_DOC, D1_FORNECE;



