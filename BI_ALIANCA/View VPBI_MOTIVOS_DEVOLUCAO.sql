
-- View para o PowerBI ler dados dos demais sistemas
-- Data: 31/03/2022
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_MOTIVOS_DEVOLUCAO]
AS
SELECT ZX5_02MOT, ZX5_02DESC
FROM protheus.dbo.ZX5010
WHERE D_E_L_E_T_ = ''
AND ZX5_FILIAL = '  '
AND ZX5_TABELA = '02'

