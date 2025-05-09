--人造人間－サイコ・ショッカー
--Jinzo (Rush)
local s,id=GetID()
function s.initial_effect(c)
	--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_HAND|LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsTrap))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(LOCATION_HAND|LOCATION_SZONE,0)
	e2:SetCondition(s.cond)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(s.aclimit)
	e3:SetReset(RESET_PHASE|PHASE_END)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.cond)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_SZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsTrap))
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetCondition(s.cond)
	c:RegisterEffect(e6)
	--disable effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(s.disop)
	c:RegisterEffect(e7)
	--disable trap monster
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsTrap))
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetCondition(s.cond)
	c:RegisterEffect(e9)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
function s.cond(e)
	local c=e:GetHandler()
	return c:GetEffectCount(303660)==0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) and not (c:GetEffectCount(303660)>0 and c:GetControler()==re:GetHandler():GetControler()) then
		Duel.NegateEffect(ev)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsTrap()
end