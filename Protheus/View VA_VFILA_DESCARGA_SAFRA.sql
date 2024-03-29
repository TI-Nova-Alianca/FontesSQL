




ALTER VIEW [dbo].[VA_VFILA_DESCARGA_SAFRA] AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados da fila de descarga de uva durante o recebimento de safra.
-- Autor: Robert Koch
-- Data:  28/02/2014
-- Historico de alteracoes:
-- 14/01/2016 - Robert - Coluna NOME_ASSOC_SZE eliminada da view VA_VCARGAS_SAFRA.
-- 10/01/2018 - Robert - Desconsidera cargas com status 'C'.
-- 10/02/2018 - Robert - Desconsidera cargas com status 'D'.
--

WITH C AS
(
    SELECT SAFRA,
           FILIAL,
           CARGA,
           LOCAL,
           V.TOMBADOR,
           V.ASSOCIADO,
           V.LOJA_ASSOC,
           V.NOME_ASSOC,
           DATA,
           HORA,
           PLACA,
           V.PESO_BRUTO,
           V.PESO_TARA,
           PESO_ESTIMADO,
           PRODUTO,
           DESCRICAO,
           COR,
           ISNULL(
               (
                   SELECT ZZA_STATUS
                   FROM   ZZA010 ZZA
                   WHERE  ZZA.ZZA_FILIAL = V.FILIAL
                          AND ZZA.ZZA_SAFRA = V.SAFRA
                          AND ZZA.ZZA_CARGA = V.CARGA
                          AND ZZA.ZZA_PRODUT = V.ITEMCARGA
						  AND ZZA.D_E_L_E_T_ = ''
               ),
               ''
           ) AS ZZA_STATUS,
           V.CONTRANOTA,
           V.TINTOREA
    FROM   VA_VCARGAS_SAFRA V
    WHERE  V.CONTRANOTA = ''
           AND V.AGLUTINACAO != 'O'
--		   AND V.STATUS != 'C'
		   AND V.STATUS NOT IN ('C', 'D')
)

SELECT CASE 
            WHEN C.PESO_BRUTO = 0 THEN '1-AGUARDANDO ENTRADA'
            ELSE CASE 
                      WHEN PESO_TARA = 0 AND ZZA_STATUS = '1' THEN 
                           '2-NO PATIO AGUARDANDO DESCARGA'
                      ELSE CASE 
                                WHEN PESO_TARA = 0 AND ZZA_STATUS = '2' THEN 
                                     '3-MEDINDO GRAU'
                                ELSE CASE 
                                          WHEN PESO_TARA = 0 AND ZZA_STATUS =
                                               '2' THEN '4-DESCARREGADA'
                                          ELSE CASE 
                                                    WHEN PESO_TARA = 0 AND 
                                                         ZZA_STATUS = '3' THEN 
                                                         '5-AGUARDANDO 2A PESAGEM'
                                                    ELSE CASE 
                                                              WHEN PESO_TARA > 0 THEN 
                                                                   '6-AGUARDANDO CONTRANOTA'
                                                              ELSE '?'
                                                         END
                                               END
                                     END
                           END
                 END
       END AS STATUS,
       C.*
FROM   C





