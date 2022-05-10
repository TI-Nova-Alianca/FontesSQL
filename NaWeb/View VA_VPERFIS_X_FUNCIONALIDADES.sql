SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VA_VPERFIS_X_FUNCIONALIDADES]
AS

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar no NaWeb as relacoes entre perfis de usuarios e suas funcionalidades.
-- Autor: Robert Koch
-- Data:  23/04/2022
-- Historico de alteracoes:
--

select sr.SecRoleId
	, sr.SecRoleDescription
	, sf.SecFunctionalityKey
	, sf.SecFunctionalityDescription
from LKSRV_NAWEB.naweb.dbo.SecRole sr
	left join LKSRV_NAWEB.naweb.dbo.SecFunctionalityRole sfr
		left join LKSRV_NAWEB.naweb.dbo.SecFunctionality sf
		on (sf.SecFunctionalityId = sfr.SecFunctionalityId)
	on (sfr.SecRoleId = sr.SecRoleId)

GO
