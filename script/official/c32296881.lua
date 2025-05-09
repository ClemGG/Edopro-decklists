--豊穣のアルテミス
--Bountiful Artemis
local s,id=GetID()
function s.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_COUNTER) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end