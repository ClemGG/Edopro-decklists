--リセの蟲惑魔
--Traptrix Genlisea
--Logical Nonsense
--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Unaffected by "Hole" normal trap cards
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--Set 2 "Hole" Normal Traps (from deck and GY) with different names
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(Cost.SelfTribute)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
	--Lists "Hole" archetype
s.listed_series={SET_TRAP_HOLE,SET_HOLE}
	--Unaffected by "Hole" normal trap cards
function s.efilter(e,te)
	local c=te:GetHandler()
	return c:IsNormalTrap() and (c:IsSetCard(SET_TRAP_HOLE) or c:IsSetCard(SET_HOLE))
end
	--Check for "Hole" normal traps
function s.setfilter(c)
	return c:IsNormalTrap() and c:IsSSetable() and (c:IsSetCard(SET_TRAP_HOLE) or c:IsSetCard(SET_HOLE))
end
	--The 2 traps have different names from each other
function s.setcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)>=#sg and sg:GetClassCount(Card.GetCode)>=#sg
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2
			and aux.SelectUnselectGroup(sg,e,tp,2,2,s.setcheck,0) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
	--Set 2 "Hole" normal traps with different names from deck and GY, banish them when they leave
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
	if #sg==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,2,2,s.setcheck,1,tp,HINTMSG_SET,s.setcheck)
	if #rg>0 then
		Duel.SSet(tp,rg)
		for tc in rg:Iter() do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
			tc:RegisterEffect(e1)
		end
	end
end