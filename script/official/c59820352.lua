--大地讃頌
--Earth Chant
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcEqual(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
end