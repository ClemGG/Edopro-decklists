--エクシーズ・テリトリー
--Xyz Territory
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ad up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(s.adcon)
	e2:SetTarget(s.adtg)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.desreptg)
	c:RegisterEffect(e4)
end
function s.adcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()
end
function s.adtg(e,c)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (c==a or c==d) and c:IsType(TYPE_XYZ)
end
function s.adval(e,c)
	return c:GetRank()*200
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
		return true
	else return false end
end