--オアシスの使者
--Emissary of the Oasis
local s,id=GetID()
function s.initial_effect(c)
	--atk target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(s.atkcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetTarget(s.cfilter2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e3:SetTarget(s.cfilter2)
	c:RegisterEffect(e3)
end
function s.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3)
end
function s.cfilter2(e,c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end