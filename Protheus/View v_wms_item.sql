SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_wms_item]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de cadastro com o FullWMS.
-- Autor: Robert Koch
-- Data:  14/11/2014
-- Historico de alteracoes:
-- 07/06/2018 - Robert - Unior para exportar tambem para empresa 02 (almox.02-insumos/embalagens)
--                     - Busca lastro e camadas no SB1 e nao mais no DC2 e DC3
-- 05/07/2018 - Robert - Exporta apenas tipo ME para a empresa 2
-- 22/03/2022 - Robert - Criada coluna dias_validade cfe. chamado 18698 da Full
-- 25/03/2022 - Robert - Campo B1_P_BRT substituido por B1_PESBRU
--                     - Criado campo peso_liq
--

-- Selecao de itens para a empresa 1 (logistica)
SELECT RTRIM(B1_COD) AS coditem,
       RTRIM(B1_DESC) AS descricao,
       '' AS referencia,
       RTRIM(B1_UM) AS um,
       --B1_P_BRT AS peso,
       B1_PESBRU AS peso,
       1 AS lote_mult,
       CASE WHEN SB1.B1_PRVALID = 0 THEN 'N' ELSE 'S' END AS contr_validade,
       'N' AS contr_serie,
       'S' AS contr_lote,
       CASE B1_VAFORAL
            WHEN 'S' THEN 'I'
            ELSE 'A'
       END AS situacao,
       ISNULL(SB5.B5_LARG * SB5.B5_COMPR * SB5.B5_ESPESS / 1000000, 0) AS cubagem,	-- estou assumindo que vai ser cadastrado em centimetros.
	  SB1.B1_VAPLLAS as lastro,
	  SB1.B1_VAPLCAM as qtdlastro,
       SB1.B1_VAPLLAS * SB1.B1_VAPLCAM as qtd_palete,
       CASE B1_TIPO
            WHEN 'PA' THEN 'S'
            ELSE 'N'
       END AS inspecao,
       1 AS empresa,  -- AX 01 = empresa 1
       SB1.B1_PRVALID as dias_validade,
       B1_PESO AS peso_liq
FROM   SB1010 SB1
       LEFT JOIN SB5010 SB5
            ON  (
                    SB5.D_E_L_E_T_ = ''
                    AND SB5.B5_FILIAL = SB1.B1_FILIAL
                    AND SB5.B5_COD = SB1.B1_COD
                )
WHERE  SB1.D_E_L_E_T_ = ''
       AND B1_FILIAL = '  '
       AND SB1.B1_VAFULLW = 'S'
       AND SB1.B1_MSBLQL != '1'

/* Por enquanto nao vamos implementar no AX 02. Robert, 22/03/2022
union ALL

-- Selecao de itens para a empresa 2 (almox.02 (embalagens/insumos)
SELECT RTRIM(B1_COD) AS coditem,
       RTRIM(B1_DESC) AS descricao,
       '' AS referencia,
       RTRIM(B1_UM) AS um,
       B1_P_BRT AS peso,
       1 AS lote_mult,
       CASE WHEN SB1.B1_PRVALID = 0 THEN 'N' ELSE 'S' END AS contr_validade,
       'N' AS contr_serie,
       CASE WHEN SB1.B1_RASTRO = 'L' THEN 'S' ELSE 'N' END as contr_lote, --'S' AS contr_lote,
       CASE SB1.B1_MSBLQL
            WHEN '1' THEN 'I'
            ELSE 'A'
       END AS situacao,
       ISNULL(SB5.B5_LARG * SB5.B5_COMPR * SB5.B5_ESPESS / 1000000, 0) AS cubagem,	-- estou assumindo que vai ser cadastrado em centimetros.
	   SB1.B1_VAPLLAS as lastro,
	   SB1.B1_VAPLCAM as qtdlastro,
       SB1.B1_VAPLLAS * SB1.B1_VAPLCAM as qtd_palete,
       CASE B1_TIPO
            WHEN 'PA' THEN 'S'
            ELSE 'N'
       END AS inspecao,
       2 AS empresa  -- AX 02 = empresa 2
FROM   SB1010 SB1
       LEFT JOIN SB5010 SB5
            ON  (
                    SB5.D_E_L_E_T_ = ''
                    AND SB5.B5_FILIAL = SB1.B1_FILIAL
                    AND SB5.B5_COD = SB1.B1_COD
                )
WHERE  SB1.D_E_L_E_T_ = ''
       AND B1_FILIAL = '  '
       AND SB1.B1_TIPO IN ('ME')
       --AND SB1.B1_VAFULLW = 'S'
	   AND SB1.B1_MSBLQL != '1'
*/

GO
