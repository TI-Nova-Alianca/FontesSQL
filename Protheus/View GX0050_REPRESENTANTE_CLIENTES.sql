


CREATE   view [dbo].[GX0050_REPRESENTANTE_CLIENTES]
AS
SELECT
    A1_COD AS GX0050_COD_CLIENTE
   ,A1_CGC AS GX0050_CNPJ
   ,A1_NOME AS GX0050_NOME
   ,A1_MUN AS GX0050_MUNICIPIO
   ,A1_EST AS GX0050_ESTADO
   ,A1_MSBLQL AS GX0050_STATUS_CLI
   ,A3_COD AS GX0050_COD_REPRES
   ,A3_NOME AS GX0050_NOME_REPRES
   ,A3_TEL AS GX0050_FONE_REPRES
   ,A3_EMAIL AS GX0050_EMIL_REPRES
   ,A3_ATIVO AS GX0050_STATUS_REPRES
FROM SA3010 SA3
left JOIN SA1010 SA1
    ON (SA1.A1_VEND = SA3.A3_COD 
			AND SA1.D_E_L_E_T_ = ''
            AND A1_MSBLQL = '2')
WHERE SA3.D_E_L_E_T_ = ''
--AND SA3.A3_COD = '382'


