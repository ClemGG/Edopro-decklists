--闇の進軍
--March of the Dark Brigade
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_LIGHTSWORN}
function s.filter(c,tp)
	if not c:IsMonster() or not c:IsSetCard(SET_LIGHTSWORN) or c:GetOriginalLevel()<=0 or not c:IsAbleToHand() then return false end
	local g=Duel.GetDecktopGroup(tp,c:GetOriginalLevel())
	return g:FilterCount(Card.IsAbleToRemove,nil)==c:GetOriginalLevel()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local rg=Duel.GetDecktopGroup(tp,g:GetFirst():GetOriginalLevel())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		local ol=tc:GetOriginalLevel()
		local rg=Duel.GetDecktopGroup(tp,ol)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end