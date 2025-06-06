--Sinister Sleeper Virus of Dark World
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND+TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end


-- Coût d'activation: Sacrifier 1 Monde Ténébreux de niveau 5 ou plus
function s.costfilter(c)
	return c:IsSetCard(0x6) and c:IsLevelAbove(5)
end






function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end


--Indique quelles cartes du joueur seront concernées
function s.tgfilter(c,ty)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsType(TYPE_MONSTER) and c:IsDefenseBelow(1500))
end

--Indique quelles cartes seront détruites
function s.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsType(TYPE_MONSTER) and c:IsDefenseBelow(1500))
end


--Indique quelles cartes seront révélées dans la main
function s.cffilter(c)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND) or c:IsFacedown()
end







function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	--Affiche le popup de sélection ; 0, 1 et 2 correspondent aux 3 champs qu'on a donné à la carte (Monstre, Magie, Piège)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local ac=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	
	--On choisit le type de la carte en fonction de ce numéro
	local ty=TYPE_MONSTER
	if ac==1 then ty=TYPE_SPELL elseif ac==2 then ty=TYPE_TRAP end
	e:SetLabel(ty)
	
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_ONFIELD,nil,ty)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end






function s.activate(e,tp,eg,ep,ev,re,r,rp)

	--Destruction
	local ty=e:GetLabel()
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if #conf>0 then
		Duel.ConfirmCards(tp,conf)
		--local dg=conf:Filter(s.filter,nil)
		local dg=conf:Filter(Card.IsType,nil, ty)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	
	
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(s.desop)
	e1:SetLabel(ty)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.turncon)
	e2:SetOperation(s.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetDescription(aux.Stringid(id,descnum))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e2)
	e3:SetOwnerPlayer(tp)
	e3:SetOperation(s.reset)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e4:SetTargetRange(0,1)
	Duel.RegisterEffect(e4,tp)
	
	
	--Effet de pioche après Piège (à modifier)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,4))and ty==TYPE_TRAP then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end




function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.turnop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end



function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(Card.IsType,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.ShuffleHand(ep)
end



function s.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end



function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		e:GetLabelObject():Reset()
		if re then re:Reset() end
	end
	
	
end
