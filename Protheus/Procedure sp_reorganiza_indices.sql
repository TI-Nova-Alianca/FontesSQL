SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_reorganiza_indices]
AS
BEGIN
	SET NOCOUNT ON

	-- Define uma janela de tempo de 3 horas para esta manutencao. Depois disso, o processo finaliza.
	declare @horalimite datetime = dateadd (minute, 300, current_timestamp)

	-- Sai da rotina quando a janela de manutenção é finalizada
--	IF GETDATE() > dateadd(mi, + 00, dateadd(hh, + 16, cast(floor(cast(getdate() AS FLOAT)) AS DATETIME))) -- hora > 13:00 PM
	IF GETDATE() > @horalimite
	BEGIN
		print 'Fora da janela de manutencao (1).'
		RETURN
	END

	CREATE TABLE #Reorganiza_Indices (
		Id_Indice INT identity(1, 1)
		,Ds_Comando VARCHAR(4000)
		,Perc_frag  DECIMAL(18,3)
		);

	INSERT INTO #Reorganiza_Indices (
		Ds_Comando
		,Perc_frag
		)
	SELECT TOP (500) 'ALTER INDEX ' + b.name + ' ON ' + t.name + ' REORGANIZE', avg_fragmentation_in_percent 
	FROM sys.dm_db_index_physical_stats (DB_ID(N'protheus'), NULL, NULL, NULL, NULL) as a
		JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
		JOIN sys.tables as t ON a.object_id = t.object_id
	WHERE avg_fragmentation_in_percent > 30 AND LEN(t.name) = 6
	ORDER BY avg_fragmentation_in_percent DESC
		
	DECLARE @Loop INT
		,@Comando NVARCHAR(4000)

	SET @Loop = 1

	WHILE EXISTS (
			SELECT TOP 1 NULL
			FROM #Reorganiza_Indices
			)
	BEGIN
--		IF GETDATE() > dateadd(mi, + 00, dateadd(hh, + 16, cast(floor(cast(getdate() AS FLOAT)) AS DATETIME))) -- hora > 13:00 PM
		IF GETDATE() > @horalimite
		BEGIN
			print 'Fora da janela de manutencao (2).'
			BREAK -- Sai do loop quando acabar a janela de manutenção
		END

		SELECT @Comando = Ds_Comando
		FROM #Reorganiza_Indices
		WHERE Id_Indice = @Loop

		PRINT @Comando

		EXECUTE sp_executesql @Comando
		INSERT INTO VA_LOGS (DATAHORA, CHAVE_NAWEB, ORIGEM, TEXTO) VALUES (CURRENT_TIMESTAMP, 'NOPS', 'sp_reorganiza_indices', @Comando)
		DELETE
		FROM #Reorganiza_Indices
		WHERE Id_Indice = @Loop

		SET @Loop = @Loop + 1
	END
END
GO
