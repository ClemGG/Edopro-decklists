--ジェネレーション・ネクスト
--Generation Next
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_ELEMENTAL_HERO,SET_NEO_SPACIAN,SET_KURIBOH}
function s.filter(c,e,tp,lc,lp)
	return (c:IsSetCard(SET_ELEMENTAL_HERO) or c:IsSetCard(SET_NEO_SPACIAN) or c:IsSetCard(SET_KURIBOH))
		and c:IsMonster() and c:IsAttackBelow(lp)
		and (c:IsAbleToHand() or (lc>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(1-tp)-Duel.GetLP(tp)
		return lp>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetLocationCount(tp,LOCATION_MZONE),lp)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	if lp<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetLocationCount(tp,LOCATION_MZONE),lp):GetFirst()
	if tc then
		aux.ToHandOrElse(tc,tp,
			function() return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end,
			function() Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end,
			aux.Stringid(id,0)
		)
		--Cannot activate cards or the effects of cards with the same name
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	local code=e:GetLabel()
	return re:GetHandler():IsCode(code)
end