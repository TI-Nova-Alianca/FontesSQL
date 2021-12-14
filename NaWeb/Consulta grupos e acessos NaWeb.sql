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
and r.SecRoleId = 169
and not exists (select *
    from naweb.dbo.SecFunctionalityRole destino
    where destino.SecRoleId = 196
    and destino.SecFunctionalityId = r.SecFunctionalityId)
order by SecFunctionalityKey
