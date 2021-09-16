-- pessoas do perfil
SELECT SecUserRole.SecRoleId, SecRole.SecRoleDescription, SecUserRole.SecUserId, SecUser.SecUserName, SecUser.SecUserPessoa
FROM SecUserRole, SecUser, SecRole
where SecUser.SecUserId = SecUserRole.SecUserId
and SecRole.SecRoleId = SecUserRole.SecRoleId
and SecUser.SecUserName like 'deise%'
and SecUserRole.SecRoleId = 130

-- acessos (funcionalidades) liberadas para o perfil
select r.SecRoleId, r.SecFunctionalityId, f.SecFunctionalityKey, f.SecFunctionalityDescription
from SecFunctionalityRole r, SecFunctionality f
where f.SecFunctionalityId = r.SecFunctionalityId
and r.SecRoleId = 169
and not exists (select *
    from SecFunctionalityRole destino
    where destino.SecRoleId = 196
    and destino.SecFunctionalityId = r.SecFunctionalityId)
order by SecFunctionalityKey


