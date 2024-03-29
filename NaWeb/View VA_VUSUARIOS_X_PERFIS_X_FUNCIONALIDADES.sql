

ALTER VIEW [dbo].[VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES]
AS

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar no NaWeb as relacoes entre usuarios X perfis X funcionalidades.
-- Autor: Robert Koch
-- Data:  28/07/2023
-- Historico de alteracoes:
-- 31/07/2023 - Robert - Adicionada leitura de programas e menus
--

select SecUser.SecUserId, SecUser.SecUserName, SecUser.SecUserPessoa
	, SecRole.SecRoleId, SecRole.SecRoleName, SecRole.SecRoleDescription
	, SecFunctionality.SecFunctionalityId, SecFunctionality.SecFunctionalityKey, SecFunctionality.SecFunctionalityDescription
	, TrnNucPrograma.TrnNucProgramaCod, TrnNucPrograma.TrnNucProgramaDes
	, TrnNucMenu.TrnNucMenuCam, TrnNucMenu.TrnNucMenuSit
from SecUser               -- Usuarios
	,SecUserRole           -- Usuarios X perfis
	,SecRole               -- Perfis
	,SecFunctionalityRole  -- Perfis x funcionalidades
	,SecFunctionality      -- Funcionalidades
	left join TrnNucPrograma  -- Programas
				left join TrnNucMenu  -- Menus (programas sao adicionados aos menus pelo campo TrnNucProgramaCod)
					on (TrnNucMenu.TrnNucProgramaCod = TrnNucPrograma.TrnNucProgramaCod)
		on (TrnNucPrograma.TrnNucProgramaObj = SecFunctionalityKey)
WHERE SecUserRole.SecUserId               = SecUser.SecUserId
  AND SecRole.SecRoleId                   = SecUserRole.SecRoleId
  and SecFunctionalityRole.SecRoleId      = SecRole.SecRoleId
  and SecFunctionality.SecFunctionalityId = SecFunctionalityRole.SecFunctionalityId

--order by SecFunctionality.SecFunctionalityDescription, SecFunctionality.SecFunctionalityKey, SecFunctionality.SecFunctionalityId


