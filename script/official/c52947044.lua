--フュージョン・デステニー
--Fusion Destiny
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.ListsArchetypeAsMaterial,SET_DESTINY_HERO),Fusion.InHandMat,s.fextra,nil,nil,s.stage2,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_series={SET_HERO,SET_DESTINY_HERO}
function s.fcheck(tp,sg,fc)
	return sg:IsExists(aux.FilterBoolFunction(Card.IsSetCard,SET_DESTINY_HERO,fc,SUMMON_TYPE_FUSION,tp),1,nil)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil),s.fcheck
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.stage2(e,tc,tp,mg,chk)
	local c=e:GetHandler()
	if chk==0 then
		tc:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,2)
	end
	if chk==1 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCondition(s.descon)
		e2:SetOperation(s.desop)
		e2:SetReset(RESET_PHASE|PHASE_END,2)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
	end
	if chk==2 then
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.splimit(e,c)
	return not (c:IsSetCard(SET_HERO) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end