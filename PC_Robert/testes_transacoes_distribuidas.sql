
BEGIN TRAN;
INSERT into LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS
(FILIAL, LINHA, HORA, LINE_STATUS) 
values ('xx', 0, CURRENT_TIMESTAMP, 1)
--COMMIT

--select TOP 10 * FROM LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS
