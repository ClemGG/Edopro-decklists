--湿地草原 (Action Field)
--Wetlands (Action Field)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.tg)
	e2:SetValue(1200)
	c:RegisterEffect(e2)
end
s.af="a"
function s.tg(e,c)
	local lv=c:GetLevel()
	return lv>0 and lv<=2 and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
end