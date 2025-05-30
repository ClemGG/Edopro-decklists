--バトル・テレポーテーション
--Battle Teleportation
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_PSYCHIC),tp,LOCATION_MZONE,0,nil)==1 end
	local tc=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_PSYCHIC),tp,LOCATION_MZONE,0,nil):GetFirst()
	Duel.SetTargetCard(tc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE|PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE|PHASE_BATTLE)
		e2:SetOperation(s.ctop)
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD-RESET_TURN_SET|RESET_PHASE|PHASE_BATTLE,0,1)
	end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		Duel.GetControl(tc,1-tp)
	end
end