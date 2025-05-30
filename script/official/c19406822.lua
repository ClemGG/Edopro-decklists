--コトダマ
--Kotodama
local s,id=GetID()
function s.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.adjustop)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
end
function s.filter(c,g,pg)
	if pg:IsContains(c) then return false end
	local code=c:GetCode()
	return g:IsExists(Card.IsCode,1,c,code) or pg:IsExists(Card.IsCode,1,c,code)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local pg=e:GetLabelObject()
	if c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_DISABLE,0,1)
		pg:Clear()
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local dg=g:Filter(s.filter,nil,g,e:GetLabelObject())
	if #dg==0 or Duel.Destroy(dg,REASON_EFFECT)==0 then
		pg:Clear()
		pg:Merge(g)
		pg:Sub(dg)
	else
		g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
		pg:Clear()
		pg:Merge(g)
		pg:Sub(dg)
		Duel.Readjust()
	end
end