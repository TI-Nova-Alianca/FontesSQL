
ALTER TRIGGER [dbo].[VA_TRG_ZZA010]
ON [dbo].[ZZA010]
FOR  UPDATE
AS
BEGIN

	-- Trigger para alimentar campos adicionais tabela ZZA (comunicacao
	-- Protheusx programa de leitura grau uva safra). Inicialmente grava
	-- data e hora das alteracoes no campo ZZA_STATUS.
	-- Autor: Robert Koch
	-- Data:  meados de 2017
	--
	-- Historico de alteracoes:
	-- 15/02/2023 - Robert - Gavar campo ZZA_TQPULM
	--

	DECLARE @AGORA AS DATETIME;
	SET @AGORA = GETDATE();
	DECLARE @DEST AS VARCHAR (17);
	SET @DEST = convert(varchar(8), @AGORA, 112) + ' ' + convert(varchar(8), @AGORA, 114);

	-- ZZA_STATUS: 0=Falta pesagem;1=Aguarda medicao grau;2=Medindo grau;3=Medicao encerrada
	-- ZZA_TQPULM: Tanque pulmao para onde a uva foi desviada. Assume a posicao mais recente
	--             informada na tabela VA_DESVIOS_PROCESSAMENTO_UVA (que eh atualizada via
	--             script PowerShell pelos operadores do supervisorio de processamento).
	UPDATE ZZA
	SET    ZZA_INIST1 = CASE ZZA.ZZA_STATUS WHEN '1' THEN @DEST ELSE ZZA.ZZA_INIST1 END,
	       ZZA_INIST2 = CASE ZZA.ZZA_STATUS WHEN '2' THEN @DEST ELSE ZZA.ZZA_INIST2 END,
	       ZZA_INIST3 = CASE ZZA.ZZA_STATUS WHEN '3' THEN @DEST ELSE ZZA.ZZA_INIST3 END,
		   ZZA_TQPULM = CASE ZZA.ZZA_STATUS WHEN '3'
						THEN ISNULL ((SELECT TOP 1 TANQUE_PULMAO
								FROM VA_DESVIOS_PROCESSAMENTO_UVA
								WHERE FILIAL = ZZA.ZZA_FILIAL
								AND TOMBADOR = CAST (ZZA.ZZA_LINHA AS INT)
								AND DATAHORA <= GETDATE ()  -- EVITAR POSSIVEL DATA FUTURA
								ORDER BY DATAHORA DESC), CAST (ZZA.ZZA_LINHA AS INT))  -- SE NAO ENCONTRAR DESVIO, MANTEM A 'LINHA' ATUAL
						ELSE ZZA.ZZA_TQPULM END
	FROM ZZA010 ZZA, DELETED D
	WHERE ZZA.R_E_C_N_O_ = D.R_E_C_N_O_
	  AND ZZA.ZZA_STATUS != D.ZZA_STATUS  -- PARA NAO EXECUTAR QUANDO O CONTEUDO PERMANECER O MESMO DO ANTERIOR.
END


