/*
Robert - Consultas gerais modulo manutencao

STJ: ORDENS DE SERVICO
TQB: SOLICITACOES DE MANUTENCAO
STL: INSUMOS REQUISITADOS NA O.S.

SELECT * FROM SX2010 WHERE X2_CHAVE IN ('STJ','ST9','TQB','ST4','STD','STE', 'TPL', 'TPE','TPP','STP')

SELECT * FROM SX3010 WHERE X3_CAMPO IN ('TJ_VALATF','T9_SITBEM','T4_GERAATF')
SELECT * FROM SX3010 WHERE X3_ARQUIVO = 'STJ'

FECHAMENTO SOLICITACAO DE SERVICO: MNTA290

-- SELECT * FROM ST9010 WHERE T9_CODBEM = 'PLT-041-04-0001 '
-- Mao de obra soh aparece no SD3 depois que encerra a OS (MATR860)
--SELECT * FROM SD3010 WHERE D_E_L_E_T_ = '' AND D3_FILIAL = '01' AND D3_OP = '024785OS001   ' AND D3_COD LIKE 'M%'

*/

/*
-- SOLICICTACOES CUJAS O.S. JAH FORAM ENCERRADAS - GLPI 11004
SELECT TQB_SOLICI AS SOLICITACAO
    ,dbo.VA_DTOC (TQB_DTABER) AS ABERTURA_SC
    ,TQB_ORDEM AS ORDEM
    ,dbo.VA_DTOC (TJ_DTMRFIM) AS ENCERRAMENTO_ORDEM
    ,TQB_CODBEM AS BEM
    ,T9_NOME AS NOME_BEM
FROM TQB010 TQB
    JOIN STJ010 STJ
        ON (STJ.D_E_L_E_T_ = ''
        AND TJ_FILIAL = TQB_FILIAL
        AND TJ_ORDEM = TQB_ORDEM)
    LEFT JOIN ST9010 ST9
        ON (ST9.D_E_L_E_T_ = '' AND T9_FILIAL = TQB_FILIAL AND T9_CODBEM = TQB_CODBEM)
WHERE TQB.D_E_L_E_T_ = ''
AND TQB_FILIAL = '01'
AND TQB_SOLUCA NOT IN ('E', 'C') -- A=Aguardando Analise;D=Distribuida;E=Encerrada;C=Cancelada                                                                      
AND TQB_ORDEM != ''
AND TJ_DTMRFIM != ''
order by TQB_SOLICI
*/
/*
-- OS que atualizam ativo imobilizado
SELECT top 100 TJ_ORDEM, TJ_PLANO, TJ_CODBEM, TJ_SERVICO, TJ_CUSTMDO, TJ_CUSTMAT, TJ_CUSTMAA, TJ_CUSTMAS, TJ_CUSTTER, TJ_CUSTFER, T9_NOME, T4_NOME, T9_CCUSTO
FROM STJ010 STJ
INNER JOIN ST9010 ST9 ON STJ.TJ_CODBEM  = ST9.T9_CODBEM
INNER JOIN ST4010 ST4 ON STJ.TJ_SERVICO = ST4.T4_SERVICO
WHERE ST9.T9_FILIAL  = TJ_FILIAL
AND STJ.TJ_FILIAL  = '01'
AND ST4.T4_FILIAL  = '  '
AND ST4.T4_GERAATF = 'S'  -- este eh o cara
AND STJ.TJ_TERMINO = 'S'
AND STJ.TJ_VALATF <> 'S'
AND ST9.T9_SITBEM  = 'A'
AND ST9.D_E_L_E_T_ = ''
AND STJ.D_E_L_E_T_ = ''
AND ST4.D_E_L_E_T_ = ''


-- CC da Tetra:
SELECT * 
FROM CTT010 
WHERE D_E_L_E_T_ = ''
AND CTT_CUSTO IN ('011404', '011405')
ORDER BY CTT_CUSTO
*/

--SELECT * FROM SX3010 WHERE X3_ARQUIVO = 'ST9'

--SELECT * FROM SX2010 WHERE UPPER (X2_NOME) LIKE '%PLANO%'
--SELECT * FROM STI010
--SELECT * FROM STD010
--SELECT * FROM ST6010

/* OS ATRASADAS (AINDA CONTINUA TRAZENDO MAIS QUE A TELA DA ARVORE):
SELECT *
FROM STJ010 STJ
WHERE STJ.TJ_FILIAL = '01'
--AND STJ.TJ_TIPOOS = 'L'
AND STJ.D_E_L_E_T_ <> '*'
AND STJ.TJ_TERMINO = 'N'
AND STJ.TJ_SITUACA = 'L'
and '202111222117' > (TJ_DTMPFIM + REPLACE(TJ_HOMPFIM, ':', ''))
AND NOT EXISTS (SELECT * FROM TPL010 TPL WHERE TPL.TPL_FILIAL = TJ_FILIAL AND TPL.TPL_ORDEM = TJ_ORDEM AND TPL.D_E_L_E_T_ <> '*')
;
DECLARE @LO INT
DECLARE @JLO INT
DECLARE @JLSS INT
EXEC M90298260CLR '001', '01', '01', '01', '01', '01', @LO, @JLO, @JLSS
*/
/*
SELECT * FROM SX2010 WHERE UPPER (X2_NOME) LIKE '%CONTADOR%'
SELECT * FROM TPE010  -- contadores?
SELECT * FROM TPP010  -- contadores?
SELECT * FROM STP010 where TP_CODBEM = 'EXD-004-01-0001 ' -- contadores?
*/

SELECT ST9.T9_CODBEM AS COD_BEM, RTRIM (ST9.T9_NOME) AS DESCRI_BEM, dbo.VA_DTOC (STP.TP_DTLEITU) AS DATA_LEITURA
, ST9.T9_POSCONT AS POSICAO, STP.TP_ACUMCON AS ACUMULADO, STP.TP_USULEI AS USR_LEITURA
FROM STP010 STP, ST9010 ST9
where STP.D_E_L_E_T_ = ''
--AND TP_CODBEM IN ('SPD-038-14-0001 ', 'PTZ-018-07-0003 ', 'HLX-015-05-0002 ')
AND STP.TP_DTLEITU >= '20210101'
AND ST9.D_E_L_E_T_ = ''
AND ST9.T9_FILIAL = STP.TP_FILIAL
AND ST9.T9_CODBEM = STP.TP_CODBEM
ORDER BY STP.TP_CODBEM , STP.TP_DTLEITU

--SELECT * FROM SX3010 WHERE X3_CAMPO IN ('TP_POSCONT','TP_ACUMCON', 'TP_DTLEITU','TP_VARDIA','T9_VARDIA','TP_USULEI')

/*
Solicita????es de outros setores para a manuten????o (e-mail Caio 21/02/2022)
Produ????o
???Relat??rio que mostre as ordem de servi??o aberta(em andamento e aguardando tratamento)
e fechadas. Consiga filtrar por OS, pelo solicitante.

???Plano preventiva dos equipamentos exibindo a periodicidade(quinzenal, semestral e anual) com indicador para avisar com anteced??ncia.

PCP
???Primeiramente precisamos saber se as linha est??o ativas ou se tem algum equipamento da linha parado e qual, precisamos visualizar se a manuten????o est?? planejando paradas programadas e qual o tempo estimado de libera????o e quando ocorrerem manuten????es corretiva uma estimativa de libera????o da linha, nas paradas programadas precisa de uma calend??rio para cada linha constando qual m??quina da linha estar?? em manuten????o com datas e hor??rios em que o equipamento estar?? indispon??vel, isto se aplica tamb??m para a xaroparia, vin??cola e formula????o.

Meio ambiente
???Relat??rio das O.S abertas, em andamento e conclu??das, onde aponte a descri????o da O.S e o que o trabalho que foi realizado;
???Plano de manuten????o dos equipamentos da ETE, ETA e Central de Res??duos (sopradores, bombas, dessaguadora, prensa, empilhadeira e etc.).
*/