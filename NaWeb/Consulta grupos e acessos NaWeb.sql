use naweb

select * from SecUser where SecUserName = 'pedro.toniolo'

-- perfis do usuario
SELECT cast (SUR.SecRoleId as varchar (max)) + ' - ' + SR.SecRoleDescription
		FROM LKSRV_NAWEB.naweb.dbo.SecUserRole SUR,
			LKSRV_NAWEB.naweb.dbo.SecRole SR
		WHERE SUR.SecUserId = 87
		AND SR.SecRoleId = SUR.SecRoleId

-- pessoas do perfil
SELECT sur.SecRoleId, sr.SecRoleDescription, sur.SecUserId, su.SecUserName, su.SecUserPessoa
FROM naweb.dbo.SecUserRole sur, naweb.dbo.SecUser su, naweb.dbo.SecRole sr
where su.SecUserId = sur.SecUserId
and sr.SecRoleId = sur.SecRoleId
and su.SecUserName like 'deise%'
--and sur.SecRoleId = 130

-- acessos (funcionalidades) liberadas para o perfil
select r.SecRoleId, r.SecFunctionalityId, f.SecFunctionalityKey, f.SecFunctionalityDescription
from naweb.dbo.SecFunctionalityRole r, naweb.dbo.SecFunctionality f
where f.SecFunctionalityId = r.SecFunctionalityId
and r.SecRoleId = 117
and not exists (select *
    from naweb.dbo.SecFunctionalityRole destino
    where destino.SecRoleId = 196
    and destino.SecFunctionalityId = r.SecFunctionalityId)
order by SecFunctionalityKey


-- Funcionalidades habilitadas em mais de um perfil
SELECT pf.SecFunctionalityKey
	, case when exists (select *
						from VA_VPERFIS_X_FUNCIONALIDADES base
						where base.SecFunctionalityKey = pf.SecFunctionalityKey
						and base.SecRoleId = 7)
		then 'S'
		else 'N'
		end as Existe_no_perfil_base
	, count (*) Em_quantos_perfis_consta
	, string_agg (cast (pf.SecRoleId as varchar (max)) + '-' + pf.SecRoleDescription, ', ') Perfis_onde_consta
from VA_VPERFIS_X_FUNCIONALIDADES pf
where pf.SecRoleId != 8 -- administrador
group by pf.SecFunctionalityKey
having count (*) > 1

select top 100 * from TrnNucAcesso
order by TrnNucAcessoDat desc
