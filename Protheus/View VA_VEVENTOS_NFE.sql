
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar eventos das notas fiscais eletronicas.
-- Autor: Robert Koch
-- Data:  25/01/2014
-- Historico de alteracoes:
-- 05/02/2014 - Robert - Incluidos campos do SF1 e SF2.
-- 07/02/2014 - Robert - Passa a fazer um CAST nos campos do XML por que o TopConnect nao estava lendo esses campos.
-- 15/07/2014 - Robert - Passa a considerar a inscricao estadual (M0_INSC) no relacionamento com a tabela SPED001.
--

ALTER VIEW [dbo].[VA_VEVENTOS_NFE] AS

-- INICIA COM UMA 'CTE' PARA FACILITAR A CONVERSAO DOS DADOS EM XML.
WITH C AS
(
	SELECT *,
	       CAST(
	           dbo.VA_fnStripLowAscii (
	               RTRIM(CAST(CAST(XML_ERP AS VARBINARY(8000)) AS VARCHAR(8000)))
	           ) AS XML
	       ) AS XML_ENVIADO -- CONVERTE PARA FORMATO XML, PARA PODER EXTRAIR OS DADOS POSTERIORMENTE.
	FROM   SPED150 -- EVENTOS DA NF-e
	WHERE  D_E_L_E_T_ = ''
)

SELECT ISNULL(NF_SAID.F2_FILIAL, '') AS F2_FILIAL,
       ISNULL(NF_SAID.F2_DOC, '') AS F2_DOC,
       ISNULL(NF_SAID.F2_SERIE, '') AS F2_SERIE,
       ISNULL(NF_ENTR.F1_FILIAL, '') AS F1_FILIAL,
       ISNULL(NF_ENTR.F1_DOC, '') AS F1_DOC,
       ISNULL(NF_ENTR.F1_SERIE, '') AS F1_SERIE,
       ISNULL(NF_ENTR.F1_FORNECE, '') AS F1_FORNECE,
       ISNULL(NF_ENTR.F1_LOJA, '') AS F1_LOJA,
       C.ID_ENT,
       TPEVENTO,
       SEQEVENTO,
       NFE_CHV,
       AMBIENTE,
       DATE_EVEN,
       TIME_EVEN,
       CSTATEVEN,
       CMOTEVEN,
       PROTOCOLO,
       ISNULL(
           CAST (XML_ENVIADO.value(
               '(/infEvento/detEvento[1]/xCorrecao[1])[1]',
               'varchar (max)'
           ) AS VARCHAR (1000)),
           ''
       ) AS TEXTO_CORRECAO,
       ISNULL(
           CAST (XML_ENVIADO.value('(/infEvento/detEvento[1]/xJust[1])[1]', 'varchar (max)') AS VARCHAR (1000)),
           ''
       ) AS TEXTO_JUSTIFICATIVA,
       ISNULL(
           CAST (XML_ENVIADO.value(
               '(/infEvento/detEvento[1]/descEvento[1])[1]',
               'varchar (max)'
           ) AS VARCHAR (1000)),
           ''
       ) AS DESC_EVENTO
FROM   C
       LEFT JOIN (
                SELECT S.ID_ENT,
                       SM0.M0_CODIGO,
                       SM0.M0_CODFIL,
                       SF2.F2_FILIAL,
                       SF2.F2_DOC,
                       SF2.F2_SERIE,
                       SF2.F2_CHVNFE
                FROM   SPED001 S,
                       VA_SM0 SM0,
                       SF2010 SF2
                WHERE  S.CNPJ = SM0.M0_CGC
                       AND S.IE = SM0.M0_INSC
                       AND S.D_E_L_E_T_ = ''
                       AND SM0.D_E_L_E_T_ = ''
                       AND SM0.M0_CODIGO = '01' -- APENAS ESTA EMPRESA USA NF-e
                       AND SF2.D_E_L_E_T_ = ''
                       AND SF2.F2_FILIAL = SM0.M0_CODFIL
                       AND SF2.F2_CHVNFE != ''
            ) AS NF_SAID
            ON  (
                    NF_SAID.ID_ENT = C.ID_ENT
                    AND NF_SAID.F2_CHVNFE = C.NFE_CHV
                )
       LEFT JOIN (
                SELECT S.ID_ENT,
                       SM0.M0_CODIGO,
                       SM0.M0_CODFIL,
                       SF1.F1_FILIAL,
                       SF1.F1_DOC,
                       SF1.F1_SERIE,
                       SF1.F1_FORNECE,
                       SF1.F1_LOJA,
                       SF1.F1_CHVNFE
                FROM   SPED001 S,
                       VA_SM0 SM0,
                       SF1010 SF1
                WHERE  S.CNPJ = SM0.M0_CGC
                       AND S.D_E_L_E_T_ = ''
                       AND SM0.D_E_L_E_T_ = ''
                       AND SM0.M0_CODIGO = '01' -- APENAS ESTA EMPRESA USA NF-e
                       AND SF1.D_E_L_E_T_ = ''
                       AND SF1.F1_FILIAL = SM0.M0_CODFIL
                       AND SF1.F1_CHVNFE != ''
                       AND SF1.F1_FORMUL = 'S'
            ) AS NF_ENTR
            ON  (
                    NF_ENTR.ID_ENT = C.ID_ENT
                    AND NF_ENTR.F1_CHVNFE = C.NFE_CHV
                )


