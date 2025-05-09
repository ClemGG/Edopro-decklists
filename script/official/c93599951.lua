--沈黙の邪悪霊
--Dark Spirit of the Silent
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
	return Duel.IsTurnPlayer(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local a=Duel.GetAttacker()
	if chk==0 then return a and a:IsCanBeEffectTarget(e) and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,a) end
	Duel.SetTargetCard(a)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,a)
	e:SetLabelObject(g:GetFirst())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsDefensePos() then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
		if tc:CanAttack() and not tc:IsImmuneToEffect(e) then
			Duel.BreakEffect()
			Duel.CalculateDamage(tc,Duel.GetAttackTarget())
		end
	end
end