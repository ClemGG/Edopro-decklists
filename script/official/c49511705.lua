--銃砲撃
--Proton Blast
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Apply effects based on the number of heads
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--Treat all results as heads
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.coincon1)
	e3:SetCost(Cost.SelfBanish)
	e3:SetOperation(s.coinop1)
	c:RegisterEffect(e3)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetOperationInfo(ev,CATEGORY_COIN)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Register the results of coin tosses
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.coinregop)
	e1:SetReset(RESETS_STANDARD_PHASE_END)
	c:RegisterEffect(e1)
	--Apply effects based on the number of heads
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.effcond)
	e2:SetOperation(s.effop)
	e2:SetLabelObject(re)
	e2:SetReset(RESETS_STANDARD_PHASE_END)
	c:RegisterEffect(e2)
end
function s.coinregop(e,tp,eg,ep,ev,re,r,rp)
	local ct=aux.GetCoinHeadsFromEv(ev)
	for i=1,ct do
		--Register a flag for every head
		e:GetHandler():RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
	end
end
function s.effcond(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	--Card hint (the effect always applies, even with no heads in the results)
	Duel.Hint(HINT_CARD,0,id)
	local ct=e:GetHandler():GetFlagEffect(id)
	if ct<=0 then return end
	if ct>0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if ct>2 then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #hg>0 then
			Duel.ConfirmCards(tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local sg=hg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT|REASON_DISCARD)
			Duel.ShuffleHand(1-tp)
		end
	end
end
function s.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function s.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCondition(s.coincon2)
	e1:SetOperation(s.coinop2)
	e1:SetLabel(ev)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject() and Duel.GetCurrentChain()==e:GetLabel()
end
function s.coinop2(e,tp,eg,ep,ev,re,r,rp)
	local res={}
	for i=1,ev do
		table.insert(res,COIN_HEADS)
	end
	Duel.SetCoinResult(table.unpack(res))
end