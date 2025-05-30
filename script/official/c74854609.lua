--ゼクト・コンバージョン
--Zekt Conversion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={SET_INZEKTOR}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsSetCard(SET_INZEKTOR) and a:IsControler(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	if chkc then return a==chkc end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and a:IsOnField() and a:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(a)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetAttackTarget()
	local tc=Duel.GetFirstTarget()
	if tc and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
		and ec:IsLocation(LOCATION_MZONE) and ec:IsFaceup() then
		if not Duel.Equip(tp,ec,tc) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TURN_SET)
		ec:RegisterEffect(e2)
	end
end