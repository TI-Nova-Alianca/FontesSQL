SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_wms_transportadoras]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de cadastro com o FullWMS.
-- Autor: Robert Koch
-- Data:  12/12/2014
-- Historico de alteracoes:
--

SELECT RTRIM(SA4.A4_COD) AS codtransp,
       RTRIM(SA4.A4_NOME) AS descr,
       RTRIM(SA4.A4_CGC) AS cnpj,
       RTRIM(SA4.A4_INSEST) AS inscrestadual,
       RTRIM(CASE A4_END WHEN '' THEN 'ESTRADA GERARDO SANTIN GUARESE' ELSE SA4.A4_END END) AS endereco,
       RTRIM(CASE A4_BAIRRO WHEN '' THEN 'LAGOA BELA' ELSE SA4.A4_BAIRRO END) as bairro,
       RTRIM(CASE A4_MUN WHEN '' THEN 'FLORES DA CUNHA' ELSE SA4.A4_MUN END) as cidade,
       RTRIM(CASE A4_EST WHEN '' THEN 'RS' ELSE SA4.A4_EST END) as uf,
       RTRIM(CASE A4_CEP WHEN '' THEN '99999999' ELSE SA4.A4_CEP END) as cep,
       1 AS empresa
FROM   SA4010 SA4
WHERE  SA4.D_E_L_E_T_ = ''
       AND A4_FILIAL = '  '
GO
