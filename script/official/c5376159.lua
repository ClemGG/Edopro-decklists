--スカーレッド・レイン
--Red Reign
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Banish all monsters on the field, except monster(s) with the highest level
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Add this card from GY to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsType(TYPE_SYNCHRO)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local fdwng,fupg=g:Split(Card.IsFacedown,nil)
	local exg=fupg:GetMaxGroup(Card.GetLevel) or Group.CreateGroup()
	if chk==0 then return #fdwng>0 or #(g-exg)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,(g-exg),#(g-exg),tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local fg=g:Filter(aux.FaceupFilter(Card.IsLevelAbove,1),nil)
	if #fg>0 then
		g=g-fg:GetMaxGroup(Card.GetLevel)
	end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local ig=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #ig==0 then return end
	ig:ForEach(s.immop,e:GetHandler())
end
function s.immop(tc,c)
	--Unaffected by other card effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3100)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	e1:SetReset(RESETS_STANDARD_PHASE_END)
	tc:RegisterEffect(e1)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetHandler()
end
function s.thcfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
		and c:IsControler(tp) and c:IsSynchroSummoned()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end