--剣闘獣アンダバタエ (Anime)
--Gladiator Beast Andabata (Anime)
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Summon procedure
        c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,7573135,1,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_GLADIATOR_BEAST),2)
	Fusion.AddContactProc(c,s.contactfilter,s.contactop,s.splimit)
	--Special Summon 1 "Gladiator Beast" Fusion Monster from your Extra Deck 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7573135,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.esptg)
	e1:SetOperation(s.espop)
	c:RegisterEffect(e1)
	--Special Summon 2 "Gladiator Beast" monsters from your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48156348,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Gain ATK when a "Gladiator Beast" monster is shuffled into your Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36378213,0))
        e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_GLADIATOR_BEAST}
s.listed_names={3779662} --Gladiator Beast Augustus
s.material_setcode=SET_GLADIATOR_BEAST
function s.splimit(e,se,sp,st)
	return not e:GetHandler():GetLocation()==LOCATION_EXTRA
end
function s.contactfilter(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsMonster() and c:IsAbleToDeckOrExtraAsCost() end,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.espfilter(c,e,tp)
	return c:IsSetCard(SET_GLADIATOR_BEAST) and c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,123,tp,true,false) and not (c:IsCode(3779662) or c:IsCode(id))
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function s.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.espop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,123,tp,tp,true,false,POS_FACEUP)
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD_DISABLE,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:HasFlagEffect(id) and tc:IsRelateToBattle() and tc:IsFaceup()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_GLADIATOR_BEAST) and c:IsCanBeSpecialSummoned(e,123,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and ft>1
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,123,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD_DISABLE,0,0)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return #eg==1 and ec:IsSetCard(SET_GLADIATOR_BEAST) and ec:GetPreviousLocation()==LOCATION_MZONE
end
function s.atkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(SET_GLADIATOR_BEAST) and c:GetPreviousAttackOnField()>0
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:Filter(s.atkfilter,nil,tp):GetFirst()
	if tc and (tc:IsLocation(LOCATION_DECK) or tc:IsLocation(LOCATION_EXTRA)) then
		local atk=tc:GetPreviousAttackOnField()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end