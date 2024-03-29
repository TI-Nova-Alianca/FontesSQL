


-- View para o PowerBI ler dados dos demais sistemas
-- Data: 31/03/2022
-- Autor: Robert Koch
--
-- Historico de alteracoes:
-- 06/04/2022 - Robert - Incluidos campos B2_COD e B2_LOCAL
--                     - Removido filtro de B1_TIPO (passa a buscar todos, para uso por outras consultas alem do comercial)
-- 08/12/2022 - Robert - Passa a exportar B2_QATU - B2_RESERVA AS B2_QATU
--                     - Filtra B1_MSBLQL != '1'
-- 04/01/2023 - Robert - Filtra apenas B2_FILIAL=01 e B2_LOCAL=01
--

ALTER VIEW [dbo].[VPBI_SALDOS_ESTOQUES]
AS 
SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU - B2_RESERVA AS B2_QATU, SB1.B1_UM
FROM protheus.dbo.SB2010 SB2
	, protheus.dbo.SB1010 SB1
WHERE SB2.D_E_L_E_T_ = ''
AND SB2.B2_FILIAL = '01'
AND SB2.B2_LOCAL = '01'
AND SB1.D_E_L_E_T_ = ''
AND SB1.B1_FILIAL = '  '
AND SB1.B1_COD = SB2.B2_COD
AND SB1.B1_MSBLQL != '1'

