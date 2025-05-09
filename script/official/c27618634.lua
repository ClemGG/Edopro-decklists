--薄幸の乙女
--The Unhappy Girl
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(s.indcon)
	c:RegisterEffect(e1)
	--battled
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.atlcon)
	e3:SetTarget(s.atltg)
	e3:SetLabelObject(g)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e4:SetLabelObject(g)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHANGE_POS)
	e5:SetOperation(s.posop)
	c:RegisterEffect(e5)
end
function s.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and c:IsPosition(POS_FACEUP_ATTACK) then
		if c:GetFlagEffect(id)==0 then
			c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
			e:GetLabelObject():Clear()
		end
		e:GetLabelObject():AddCard(bc)
		bc:RegisterFlagEffect(id+1,RESET_EVENT|RESETS_STANDARD,0,1)
	end
end
function s.atlcon(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.atltg(e,c)
	return e:GetLabelObject():IsContains(c) and c:GetFlagEffect(id+1)~=0
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
end