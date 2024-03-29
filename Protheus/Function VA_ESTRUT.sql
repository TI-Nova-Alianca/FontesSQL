--
-- Descricao: Retorna estrutura do produto (em niveis, mas nao 'explodida')
-- Autor....: Robert koch
-- Data.....: 16/09/2012
-- Creditos.: Craig Freedman (http://blogs.msdn.com/b/craigfr/archive/2007/10/25/recursive-ctes.aspx)
--
-- Historico de alteracoes:
--

create FUNCTION [dbo].[VA_ESTRUT]
(
	@FILIAL   AS VARCHAR(2),
	@PRODUTO  AS VARCHAR(15),
	@DATAREF  AS VARCHAR(8)
)
RETURNS TABLE
AS


RETURN 

WITH ESTRUT(NIVEL, G1_COD, G1_COMP) AS 
(
    SELECT 0 AS NIVEL,
           SG1.G1_COD,
           SG1.G1_COMP
    FROM   SG1010 SG1
    WHERE  SG1.D_E_L_E_T_ = ''
           AND SG1.G1_FILIAL = @FILIAL
           AND G1_COD = @PRODUTO
           AND G1_INI <= @DATAREF
           AND G1_FIM >= @DATAREF
    UNION ALL
    SELECT NIVEL + 1,
           SG1.G1_COD,
           SG1.G1_COMP
    FROM   SG1010 SG1,
           ESTRUT E
    WHERE  SG1.D_E_L_E_T_ = ''
           AND SG1.G1_FILIAL = @FILIAL
           AND G1_INI <= @DATAREF
           AND G1_FIM >= @DATAREF
           AND SG1.G1_COD = E.G1_COMP
)
SELECT *
FROM   ESTRUT;

