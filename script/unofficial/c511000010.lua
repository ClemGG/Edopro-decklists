--Ritual of the Matador
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreaterCode(c,6,nil,511000009)
end