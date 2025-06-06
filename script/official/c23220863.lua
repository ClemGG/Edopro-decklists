--シュルブの魔導騎兵
--Magical Cavalry of Cxulub
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
end
function s.efilter(e,te)
	return te:IsMonsterEffect() and te:IsActivated() and not te:GetOwner():IsType(TYPE_PENDULUM)
end