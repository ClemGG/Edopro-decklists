--サブテラーの決戦
--Subterror Final Battle
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP|TIMING_END_PHASE)
	e1:SetCondition(aux.StatChangeDamageStepCondition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_SUBTERROR}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(SET_SUBTERROR)
end
function s.fufilter(c)
	return c:IsFacedown() and c:IsSetCard(SET_SUBTERROR)
end
function s.fdfilter(c)
	return s.filter(c) and c:IsCanTurnSet()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingMatchingCard(s.fufilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingMatchingCard(s.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b4=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetFlagEffect(tp,id)==0
	if chk==0 then return b1 or b2 or b3 or b4 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 or op==2 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	elseif op==3 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	end
end
function s.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsSetCard(SET_SUBTERROR)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,s.fufilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
			Duel.ChangePosition(tc,pos)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,s.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local atk=tc:GetBaseAttack()+tc:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(atk)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
		end
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISEFFECT)
		e1:SetValue(s.effectfilter)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	end
	if not c:IsRelateToEffect(e) then return end
	if c:IsSSetable(true) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end