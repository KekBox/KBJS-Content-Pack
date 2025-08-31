--an extra range boost because the initial is way too short
local rangeBoost = 1.5

function SWEP:CanBackstab(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 60 and angle >= -60 then return true end
	return false
end

function SWEP:AtkExtra() end

function SWEP:Attack()
    local ply = self.Owner
    local wep = self.Weapon

    if IsFirstTimePredicted() then
        local tr = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * (self.Range * rangeBoost),
            filter = ply,
            mask = MASK_SHOT_HULL
        })

        if not IsValid(tr.Entity) then
            tr = util.TraceHull({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * (self.Range * rangeBoost),
                filter = ply,
                mins = Vector(-1, -1, 0),
                maxs = Vector(1, 1, 0),
                mask = MASK_SHOT_HULL
            })
        end

        local pos = ply:GetEyeTrace()

        if SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer()) then
            local dmginfo = DamageInfo()

            local attacker = ply
            if not IsValid(attacker) then
                attacker = self
            end
            dmginfo:SetAttacker(attacker)

            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(math.floor(self.Charge))
            dmginfo:SetDamageForce(ply:GetForward() * 5000)

            if self.Type == 1 or self.Type == 2 then
                dmginfo:SetDamageType(4)
            elseif self.Type == 3 then
                dmginfo:SetDamageType(128)
            elseif self.Type == 4 then
                dmginfo:SetDamageType(1)
            elseif self.Type == 7 then
                dmginfo:SetDamageType(128)
            elseif self.Type == 5 then
                dmginfo:SetDamageType(128)
            elseif self.Type == 666 then
                dmginfo:SetDamageType(67108864)
            end

            if self:CanBackstab(tr.Entity) and tr.Entity:GetPos():Distance(ply:GetPos()) < (self.Range * rangeBoost) + 20 then
                dmginfo:SetDamage(math.floor(self.Charge * 1.7))
                tr.Entity:TakeDamageInfo(dmginfo)
                if tr.Entity:GetBloodColor() ~= -1 then
                    tr.Entity:EmitSound("physics/flesh/flesh_bloody_break.wav")
                end
                tr.Entity:EmitSound("physics/flesh/flesh_strider_impact_bullet3.wav")
            else
                tr.Entity:TakeDamageInfo(dmginfo)
            end

            self:AtkExtra()

            if tr.Entity:GetNW2Bool("MAGuardening") == true or tr.Entity:GetNW2Bool("MeleeArtShieldening") == true then
                if SERVER then
                    if self.Type ~= 4 then
                        local w = math.random(1, 2)
                        if w == 1 then
                            ply:EmitSound(self.Impact1Sound)
                        elseif w == 2 then
                            ply:EmitSound(self.Impact2Sound)
                        end
                    end
                end

                if self.Type == 7 then
                    if self.Weapon:GetNW2Int("QSChain") > 0 then
                        self.Weapon:SetNW2Int("QSChain", 0)
                        ply:EmitSound("ambient/levels/canals/windchime2.wav", 40, 80)
                    end
                end

                if self.Type == 4 then
                    if self.Strength == 1 then
                        self.NextStun = CurTime() + 1.25
                    elseif self.Strength == 2 then
                        self.NextStun = CurTime() + 1
                    elseif self.Strength == 3 then
                        self.NextStun = CurTime() + 0.9
                    elseif self.Strength == 4 then
                        self.NextStun = CurTime() + 0.8
                    elseif self.Strength == 5 then
                        self.NextStun = CurTime() + 0.6
                    elseif self.Strength == 6 then
                        self.NextStun = CurTime() + 0.4
                    end
                    ply:ViewPunch(Angle(-10, 0, 0))
                    local effectdata = EffectData()
                    effectdata:SetOrigin(pos.HitPos)
                    effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                    effectdata:SetEntity(tr.Entity)
                    util.Effect("spearpierce", effectdata, true, true)
                    timer.Simple(0, function()
                        ply:DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_GRENADE, 4)
                    end)
                else
                    self.NextStun = CurTime() + 1.5
                    ply:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
                    ply:ViewPunch(Angle(-20, 0, 0))
                    timer.Simple(0, function()
                        ply:DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_GRENADE, 4)
                    end)
                    local effectdata = EffectData()
                    effectdata:SetOrigin(pos.HitPos)
                    effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                    effectdata:SetEntity(tr.Entity)
                    util.Effect("stundeflection", effectdata, true, true)
                end
            else
                if pos.Entity == tr.Entity then
                    if tr.Entity:GetBloodColor() ~= -1 then
                        local effectdata = EffectData()
                        local blood = tr.Entity:GetBloodColor()
                        effectdata:SetColor(blood)
                        effectdata:SetOrigin(pos.HitPos)
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)
                        effectdata:SetAttachment(5)
                        if GetConVarNumber( "ma2_toggledefaultfx" ) == 1 then
                            util.Effect("BloodImpact", effectdata, true, true)
                            if GetConVarNumber( "ma2_togglebloodsplats" ) == 1 then
                                if tr.Entity:GetBloodColor() == 0 then
                                    util.Effect("bloodsplat", effectdata, true, true)
                                else
                                    util.Effect("bloodsplatyellow", effectdata, true, true)
                                end
                            end
                        else
                            if self.HitFX == "bloodsplat" then
                                if tr.Entity:GetBloodColor() == 0 then
                                    util.Effect(self.HitFX, effectdata, true, true)
                                else
                                    util.Effect("bloodsplatyellow", effectdata, true, true)
                                end
                            else
                                util.Effect(self.HitFX, effectdata, true, true)
                            end
                            util.Effect(self.HitFX2, effectdata, true, true)
                        end
                    else
                        local effectdata = EffectData()
                        effectdata:SetOrigin(pos.HitPos)
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)
                        effectdata:SetAttachment(5)
                        util.Effect("MetalSpark", effectdata, true, true)
                    end
                else
                    if tr.Entity:GetBloodColor() ~= -1 then
                        local effectdata = EffectData()
                        local blood = tr.Entity:GetBloodColor()
                        effectdata:SetColor(blood)
                        effectdata:SetOrigin(tr.Entity:GetPos() + Vector(0, 0, 40))
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)
                        effectdata:SetAttachment(5)
                        if GetConVarNumber( "ma2_toggledefaultfx" ) == 1 then
                            util.Effect("BloodImpact", effectdata, true, true)
                            if GetConVarNumber( "ma2_togglebloodsplats" ) == 1 then
                                if tr.Entity:GetBloodColor() == 0 then
                                    util.Effect("bloodsplat", effectdata, true, true)
                                else
                                    util.Effect("bloodsplatyellow", effectdata, true, true)
                                end
                            end
                        else
                            if self.HitFX == "bloodsplat" then
                                if tr.Entity:GetBloodColor() == 0 then
                                    util.Effect(self.HitFX, effectdata, true, true)
                                else
                                    util.Effect("bloodsplatyellow", effectdata, true, true)
                                end
                            else
                                util.Effect(self.HitFX, effectdata, true, true)
                            end
                            util.Effect(self.HitFX2, effectdata, true, true)
                        end
                    else
                        local effectdata = EffectData()
                        effectdata:SetOrigin(pos.HitPos)
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)
                        effectdata:SetAttachment(5)
                        util.Effect("MetalSpark", effectdata, true, true)
                    end
                end

                -- Apply debuffs
                if self.Type == 1 then
                    local bleedDmg = (0.5 * (self.Strength / 2))
                    MAWoundage:AddStatus(tr.Entity, ply, "bleed", 10, bleedDmg)
                    -- print("uhh sword")
                elseif self.Type == 2 then
                    MAWoundage:AddStatus(tr.Entity, ply, "expose", self.Strength)
                    -- print("uhh axe")
                elseif self.Type == 3 then
                    chance = math.ceil(10 * ((self.DmgMax / self.Charge) / (tr.Entity:GetMaxHealth() / tr.Entity:Health())) * 3 / self.Strength)
                    MAWoundage:AddStatus(tr.Entity, ply, "cripple", chance)
                    -- print("uhh bludgeon")
                elseif self.Type == 4 then
                    -- print("uhh spear")
                elseif self.Type == 7 then
                    if self.Weapon:GetNW2Int("QSChain") < 6 then
                        self.Weapon:SetNW2Int("QSChain", self.Weapon:GetNW2Int("QSChain") + 1)
                        if self.Weapon:GetNW2Int("QSChain") == 6 then
                            ply:EmitSound("ambient/levels/canals/windchime4.wav", 50)
                        else
                            ply:EmitSound("ambient/levels/canals/windchime2.wav", 40)
                        end
                    end
                    if self.Weapon:GetNW2Int("QSChain") > 2 then
                        tr.Entity:EmitSound("physics/body/body_medium_impact_hard6.wav")
                        if SERVER then
                            local boom = 100 * self.Strength
                            local shiftstraight = ply:GetAngles():Forward() * boom
                            shiftstraight.z = 5
                            tr.Entity:SetVelocity(shiftstraight)
                        end
                    end
                end
            end

            if SERVER and tr.Entity:GetNW2Bool("MAGuardening") == false and tr.Entity:GetNW2Bool("MeleeArtShieldening") == false then
                local w = math.random(1, 3)
                if w == 1 then
                    ply:EmitSound(self.Hit1Sound)
                elseif w == 2 then
                    ply:EmitSound(self.Hit2Sound)
                elseif w == 3 then
                    ply:EmitSound(self.Hit3Sound)
                end
            end

        elseif SERVER and IsValid(tr.Entity) then
            -- self:AttackAnimation2()

            local dmginfo = DamageInfo()

            local attacker = ply
            if not IsValid(attacker) then
                attacker = self
            end
            dmginfo:SetAttacker(attacker)

            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(math.floor(self.Charge))
            dmginfo:SetDamageForce(ply:GetForward() * self.Strength * 1000)
            tr.Entity:TakeDamageInfo(dmginfo)
            -- ply:SetNW2Int('MeleeArts2Stamina', math.floor(ply:GetNW2Int('MeleeArts2Stamina') - ((self.PriAtkStamina * 5) / self.Strength)))
            if SERVER then
                local phys = tr.Entity:GetPhysicsObject()
                if IsValid(phys) then
                    -- print(phys:GetMaterial())
                    if phys:GetMaterial() != "flesh" and phys:GetMaterial() != "zombieflesh" and phys:GetMaterial() != "antlion" and phys:GetMaterial() != "alienflesh" then
                        local wackfx = EffectData()
                        wackfx:SetOrigin(pos.HitPos)
                        wackfx:SetNormal(tr.Entity:GetPos():GetNormal())
                        wackfx:SetEntity(tr.Entity)
                        util.Effect("ma2_wack", wackfx, true, true)
                    end
                    if phys:GetMaterial() == "metal" or phys:GetMaterial() == "metal_barrel" or phys:GetMaterial() == "metalvehicle" or phys:GetMaterial() == "floating_metal_barrel" or phys:GetMaterial() == "metalpanel" or phys:GetMaterial() == "combine_metal" then
                        local w = math.random(1, 2)
                        if w == 1 then
                            ply:EmitSound(self.Impact1Sound)
                        elseif w == 2 then
                            ply:EmitSound(self.Impact2Sound)
                        end
                        if self.WepName ~= "meleearts_bludgeon_fists" then
                            local effectdata = EffectData()
                            effectdata:SetOrigin(pos.HitPos)
                            effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                            effectdata:SetEntity(tr.Entity)
                            util.Effect("stundeflection", effectdata, true, true)
                        end
                        if tr.Entity:Health() == 0 then
                            ply:ViewPunch(Angle(-20, 0, 0))
                            ply:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
                            self.NextStun = CurTime() + 1.5
                            timer.Simple(0, function()
                                ply:DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_GRENADE, 4)
                            end)
                        end
                    elseif phys:GetMaterial() == "wood" or phys:GetMaterial() == "wood_crate" or phys:GetMaterial() == "wood_solid" then
                        local w = math.random(1, 2)
                        if w == 1 then
                            tr.Entity:EmitSound("physics/wood/wood_plank_break1.wav")
                            ply:EmitSound(self.Impact1Sound)
                        elseif w == 2 then
                            tr.Entity:EmitSound("physics/wood/wood_plank_break3.wav")
                            ply:EmitSound(self.Impact2Sound)
                        end
                    elseif phys:GetMaterial() == "flesh" then
                        local w = math.random(1, 3)
                        if w == 1 then
                            tr.Entity:EmitSound(self.Hit1Sound)
                        elseif w == 2 then
                            tr.Entity:EmitSound(self.Hit2Sound)
                        elseif w == 3 then
                            tr.Entity:EmitSound(self.Hit2Sound)
                        end
                        local effectdata = EffectData()
                        effectdata:SetOrigin(pos.HitPos)
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)
                        if GetConVarNumber( "ma2_toggledefaultfx" ) == 1 then
                            util.Effect("BloodImpact", effectdata, true, true)
                            if GetConVarNumber( "ma2_togglebloodsplats" ) == 1 then
                                util.Effect("bleedingsplat", effectdata, true, true)
                            end
                        else
                            util.Effect(self.HitFX, effectdata, true, true)
                            util.Effect(self.HitFX2, effectdata, true, true)
                        end
                    elseif phys:GetMaterial() == "zombieflesh" or phys:GetMaterial() == "antlion" or phys:GetMaterial() == "alienflesh" then
                        local w = math.random(1, 3)
                        if w == 1 then
                            tr.Entity:EmitSound(self.Hit1Sound)
                        elseif w == 2 then
                            tr.Entity:EmitSound(self.Hit2Sound)
                        elseif w == 3 then
                            tr.Entity:EmitSound(self.Hit2Sound)
                        end
                        local effectdata = EffectData()
                        effectdata:SetOrigin(pos.HitPos)
                        effectdata:SetNormal(tr.Entity:GetPos():GetNormal())
                        effectdata:SetEntity(tr.Entity)

                        if GetConVarNumber( "ma2_togglebloodsplats" ) == 1 then
                            util.Effect("bleedingyellow", effectdata, true, true)
                        end
                    elseif phys:GetMaterial() == "chainlink" then
                        local w = math.random(1, 2)
                        if w == 1 then
                            tr.Entity:EmitSound("physics/metal/metal_chainlink_impact_hard1.wav")
                            ply:EmitSound(self.Impact1Sound)
                        elseif w == 2 then
                            tr.Entity:EmitSound("physics/metal/metal_chainlink_impact_hard2.wav")
                            ply:EmitSound(self.Impact2Sound)
                        end
                    else
                        local w = math.random(1, 2)
                        if w == 1 then
                            ply:EmitSound(self.Impact1Sound)
                        elseif w == 2 then
                            ply:EmitSound(self.Impact2Sound)
                        end
                    end
                end
            end

            if self.Type == 7 then
                if self.Weapon:GetNW2Int("QSChain") > 0 then
                    self.Weapon:SetNW2Int("QSChain", 0)
                    ply:EmitSound("ambient/levels/canals/windchime2.wav", 40, 80)
                end
            end
        elseif tr.Hit then
            local w = math.random(1, 2)
            if w == 1 then
                ply:EmitSound(self.Impact1Sound)
            elseif w == 2 then
                ply:EmitSound(self.Impact2Sound)
            end
            local wackfx = EffectData()
            wackfx:SetOrigin(tr.HitPos)
            wackfx:SetNormal(tr.HitNormal)
            wackfx:SetEntity(ply)
            util.Effect("ma2_wack", wackfx, true, true)

            if self.Type == 7 then
                if self.Weapon:GetNW2Int("QSChain") > 0 then
                    self.Weapon:SetNW2Int("QSChain", 0)
                    ply:EmitSound("ambient/levels/canals/windchime2.wav", 40, 80)
                end
            end

            local charge_amount = (self.Charge-self.DmgMin)/(self.DmgMax-self.DmgMin)
            if charge_amount > 0.6 then
                ply:ViewPunch(Angle(-20, 0, 0))
                ply:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
                self.NextStun = CurTime() + 1
                timer.Simple(0, function()
                    ply:DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_GRENADE, 4)
                end)
            end
        else
            if self.Type == 7 then
                if self.Weapon:GetNW2Int("QSChain") > 0 then
                    self.Weapon:SetNW2Int("QSChain", 0)
                    ply:EmitSound("ambient/levels/canals/windchime2.wav", 40, 80)
                end
            end
        end

        if SERVER and IsValid(tr.Entity) then
            local phys = tr.Entity:GetPhysicsObject()
            if IsValid(phys) and IsValid(ply) then
                phys:ApplyForceOffset(ply:GetAimVector() * math.floor(self.Charge) * 2 * phys:GetMass(), tr.HitPos)
            end
        end

        if SERVER then
            if not ply:IsNPC() and IsValid(ply) then
                ply:LagCompensation(false)
            end
        end

        if ply:Alive() and IsValid(ply) then
            if ply:IsSprinting() then
                ply:ConCommand("-speed")
            end
            timer.Simple(.3, function()
                if SERVER and ply:Alive() and IsValid(ply) then
                    ply:SetNW2Bool("MeleeArtAttacking2", false)
                end
            end)
            self.NextSequenceReset = CurTime() + self:SequenceDuration()
            --[[
            timer.Simple(self:SequenceDuration(), function()
                if IsValid(wep) and wep.IdleAfter == true then
                    if ply:Alive() and ply:GetCycle() < 1 and ply:GetNW2Bool("MeleeArtAttacking2") == false then
                        self:SendWeaponAnim(ACT_VM_IDLE)
                    end
                end
            end)]]
        end
    end

    if self.Type == 7 then
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay / (1 + (self.Weapon:GetNW2Int("QSChain") / 5) * self.Speed))
    else
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)
    end
end