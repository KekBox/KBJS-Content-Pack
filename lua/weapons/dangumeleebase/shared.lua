AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Base"

SWEP.Spawnable = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.DrawCrosshair = false

SWEP.Category = "Melee Arts 2"
SWEP.SubCategory = "Base Weapons"
SWEP.SlotPos = 1
SWEP.Instructions = "LMB - Attack (Hold to charge) | RMB - Block | R - Shove | Walk - Throw (Hold to charge)"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"


SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=4 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is
SWEP.JokeWep=false

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="dangumeleebase"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.chargeBar = ""
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.5
SWEP.DmgMin = 8
SWEP.DmgMax = 30
SWEP.Delay = 0.5
SWEP.TimeToHit = 0.1
SWEP.AttackAnimRate = 0.8
SWEP.Range = 50
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(-2, 0, 0)
SWEP.HitFX = "bloodsplat"
SWEP.HitFX2 = "ma2_slice"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.CanThrow = true
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.3
SWEP.DmgMin2 = 5
SWEP.DmgMax2 = 20
SWEP.ThrowModel = "models/weapons/w_crowbar.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1500
SWEP.FixedThrowAng = Angle(0,0,0)
SWEP.SpinAng = Vector(0,1500,0)

--HOLDTYPES
SWEP.AttackHoldType="melee"
SWEP.Attack2HoldType="knife"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="melee2"
SWEP.BlockHoldType="slam"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="WeaponFrag.Throw"
SWEP.ThrowSound="bladeswing1.mp3"
SWEP.Hit1Sound="slash2.mp3"
SWEP.Hit2Sound="slash2.mp3"
SWEP.Hit3Sound="slash1.mp3"

SWEP.Impact1Sound="weapons/crowbar/crowbar_impact1.wav"
SWEP.Impact2Sound="weapons/crowbar/crowbar_impact2.wav"

SWEP.ViewModelBoneMods = {

}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0
SWEP.NextAttack = 0
SWEP.NextIdle = 0
SWEP.NextSequenceReset = 0

SWEP.Attacking = false

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(-3.921, 0, 3.72)
SWEP.StunAng = Vector(-18.292, -0.704, -31.659)

SWEP.ShovePos = Vector(-8.36, -17.688, -1.92)
SWEP.ShoveAng = Vector(0, 90, -70)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(-0.19, -28, -1.92)
SWEP.WhipAng = Vector(61.206, 14.069, 7.034)

SWEP.ThrowPos = Vector(-0.19, -28, -1.92)
SWEP.ThrowAng = Vector(61.206, 14.069, 7.034)

SWEP.FanPos = Vector(-20, -8.443, 8.239)
SWEP.FanAng = Vector(16.884, 0, -70)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(0, 0, 0)

SWEP.BlockEffect = 0

SWEP.VElements = {}
SWEP.WElements = {}

SWEP.Secondary.Ammo = "none"
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 0

function SWEP:Deploy()
	self:OnDeploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self:ChangeHoldType( self.IdleHoldType )	
	return true
end

function SWEP:OnDeploy() end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

function SWEP:Think()
    local ply = self.Owner
    local wep = self.Weapon

    if not IsValid(ply) or not IsValid(wep) then
        return
    end

    if not SERVER then
        return
    end

    if CurTime() > self.NextAttack and self.Attacking then
		self.Attacking = false
		self:Attack()
        self.Charge = 0
        self.NextAttack = 0
        ply:SetNW2Bool("MeleeArtAttacking2", false)
		self:RemoveAllGestures()
    end

	if CurTime() > self.NextSequenceReset then
		if IsValid(wep) and wep.IdleAfter == true then
			if ply:Alive() and ply:GetCycle() < 1 and ply:GetNW2Bool("MeleeArtAttacking2") == false and wep:GetActivity()!=ACT_VM_IDLE and wep:GetNextPrimaryFire() < CurTime() then
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
		end
    end

    if CurTime() < self.NextStun then
        ply:SetNW2Bool("MeleeArtStunned", true)
    elseif ply:GetNW2Bool("MeleeArtStunned") then
        timer.Simple(0, function()
            ply:DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_GRENADE, 3)
        end)
        ply:SetNW2Bool("MeleeArtStunned", false)
        wep:SetNextPrimaryFire(CurTime() + 0.2)
        wep:SetNextSecondaryFire(CurTime() + 0.2)
        self.NextFireShove = CurTime() + 0.2
        self.NextFireBlock = CurTime() + 0.1
    end

    if ply:GetNW2Bool("MeleeArtStunned") == true then
        if SERVER then
            self:ChangeHoldType("rpg")
        end
        --[[ply:SetRunSpeed(self.WalkSpeed/7)
        ply:SetWalkSpeed(self.WalkSpeed/7)
        ply:SetJumpPower(self.JumpPower/self.JumpPower)]]
        ply:SetNW2Bool("MeleeArtAttacking2", false)
        ply:SetNW2Bool("MeleeArtAttacking", false)
    else
        if ply:GetNW2Bool("MAGuardening") == false and ply:GetNW2Bool("MeleeArtAttacking") == false and
            ply:GetNW2Bool("MeleeArtAttacking2") == false and ply:GetNW2Bool("MeleeArtThrowing") == false
            and self.NextIdle < CurTime() then
            self:ChangeHoldType(self.IdleHoldType)
        end
    end

    if ply:KeyDown(IN_ATTACK2) then -- Blocking
        if CurTime() < self.NextFireBlock + 0.35 or ply:GetNW2Bool("MeleeArtStunned") == true then
            return
        end
        if self.Type == 5 then
            self.Charge = 0
            self.Charge2 = 0
            ply:SetNW2Bool("MeleeArtAttacking", false)
            ply:SetNW2Bool("MeleeArtThrowing", false)
            return
        end
        self.Charge = 0
        self.Charge2 = 0
        ply:SetNW2Bool("MeleeArtAttacking", false)
        ply:SetNW2Bool("MeleeArtThrowing", false)
        ply:SetNW2Bool("MAGuardening", true)
        --[[ply:SetRunSpeed(self.WalkSpeed)
        ply:SetJumpPower(self.JumpPower/2)]]
        if SERVER then
            self:ChangeHoldType(self.BlockHoldType)
        end
		if wep:GetActivity()!=ACT_VM_IDLE then
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
        wep:SetNextPrimaryFire(CurTime() + 0.2)
        wep:SetNextSecondaryFire(CurTime() + 0.2)
        self.NextFireShove = CurTime() + 0.2
        return true

    elseif ply:KeyReleased(IN_ATTACK2) then
        ply:SetNW2Bool("MAGuardening", false)
        -- Blocking Fin

    elseif ply:KeyDown(IN_ATTACK) and not ply:IsNPC() then -- Primary Attack
        --if ply:GetNW2Int( 'MeleeArts2Stamina' )<=self.PriAtkStamina then return end
        if ply:GetNW2Bool("MeleeArtStunned") == true or ply:GetNW2Bool("MeleeArtThrowing") == true then
            return
        end
        if ply:GetNW2Bool("MeleeArtAttacking2") or self.Attacking then
            return
        end
        self.Charge2 = 0
        if wep:GetNextPrimaryFire() < CurTime() then
            ply:SetNW2Bool("MeleeArtAttacking", true)
            if self.Type == 7 then
                self.Charge = math.Clamp(self.Charge + self.ChargeSpeed * (1 + ((wep:GetNW2Int("QSChain") / 8) * self.Speed)), self.DmgMin, self.DmgMax)
            else
                self.Charge = math.Clamp(self.Charge + self.ChargeSpeed, self.DmgMin, self.DmgMax)
            end
            self:ChangeHoldType(self.ChargeHoldType)
            wep:SetNextSecondaryFire(CurTime() + self.Delay)
        else
            ply:SetNW2Bool("MeleeArtAttacking", false)
        end
        return true

    elseif ply:KeyReleased(IN_ATTACK) and self.Charge > 0 then

        if ply:GetNW2Bool("MeleeArtAttacking2") then
            return
        end

		if self.Attacking then
			return
		end

		if self.NextAttack != 0 then 
			print("noreg: too fast")
			self.NextAttack = 0
			return
		end

		self.Attacking = true

        if self.Charge > self.DmgMax / 1.3 then
            self:ChangeHoldType(self.AttackHoldType)
        else
            self:ChangeHoldType(self.Attack2HoldType)
        end

        if self.Charge > self.DmgMax / 1.3 then
            self:AttackAnimation()
            ply:ViewPunch((self.Punch2))
        else
            if self.Type ~= 7 then
                self:AttackAnimation2()
            else
                if wep:GetNW2Int("QSChain") > 1 then
                    self:AttackAnimationCOMBO()
                else
                    self:AttackAnimation2()
                end
            end
            ply:ViewPunch((self.Punch1))
        end

        if SERVER then
            ply:GetViewModel():SetPlaybackRate(self.AttackAnimRate)
        end
        ply:SetNW2Bool("MeleeArtAttacking2", true)
        ply:SetNW2Bool("MeleeArtAttacking", false)

        self.NextFireBlock = CurTime() + self.Delay / 2
        self.NextFireShove = CurTime() + self.Delay
        if ply:Alive() and IsValid(ply) then
            --timer.Simple(0, function()
            if IsFirstTimePredicted() then
                if type(self.SwingSound) == "table" then
                    ply:EmitSound(self.SwingSound[math.random(1, #self.SwingSound)])
                else
                    ply:EmitSound(self.SwingSound)
                end
                if ply:Alive() and IsValid(ply) then
                    timer.Simple(0, function()
                        if not IsValid(ply) then
                            return
                        end
                        ply:SetAnimation(PLAYER_ATTACK1)
                    end)
                end
            end
            --end)
            self.NextAttack = CurTime() + self.TimeToHit
            self.NextIdle = CurTime() + (self.TimeToHit + .1)
        end
        -- Primary Attack Fin

    elseif ply:KeyDown(IN_WALK) then -- Throwing
        --if ply:GetNW2Int( 'MeleeArts2Stamina' )<=self.ThrowStamina then return end
        if self.CanThrow == false or GetConVarNumber("ma2_togglethrowing") == 0 then
            return
        end
        if ply:GetNW2Bool("MeleeArtStunned") == true then
            return
        end
        if wep:GetNextSecondaryFire() < CurTime() then
            ply:SetNW2Bool("MeleeArtThrowing", true)
            self.Charge2 = math.Clamp(self.Charge2 + self.ChargeSpeed2, self.DmgMin2, self.DmgMax2)
            self:NextThink(CurTime() + 1)
            if SERVER then
                self:ChangeHoldType(self.ThrowHoldType)
            end
            local charge_amount = (self.Charge2 - self.DmgMin2) / (self.DmgMax2 - self.DmgMin2)
        end
        wep:SetNextPrimaryFire(CurTime() + self.Delay / 4)
        return true

    elseif ply:KeyReleased(IN_WALK) and self.Charge2 > 0 then
        if ply:GetNW2Bool("MeleeArtStunned") == true then
            return
        end
        self:AttackAnimation3()
        ply:SetNW2Bool("MeleeArtThrowing", false)
        if SERVER then
            ply:EmitSound(self.ThrowSound)
        end
        --ply:SetNW2Int( 'MeleeArts2Stamina', math.floor(ply:GetNW2Int( 'MeleeArts2Stamina' )-(self.ThrowStamina+self.Charge2/2)) )
        self.NextFireBlock = CurTime() + self.Delay
        self.NextFireShove = CurTime() + self.Delay
        local pos = ply:GetShootPos()
        local ang = ply:GetAimVector():Angle()
        pos = pos + ang:Forward()

        -- some weird technique
        local ent = ents.Create("meleeartsthrowable")
        ent:SetModel(self.ThrowModel)
        if self.ThrowMaterial ~= "" then
            ent:SetMaterial(self.ThrowMaterial)
        end
        ent:SetModelScale(self.ThrowScale)
        ent:SetAngles(ply:GetAimVector():Angle())
        ent:SetOwner(wep:GetOwner())
        ent:SetNW2String('weaponname', self.WepName)
        ent:SetNW2Int('throwdamage', self.Charge2)
        ent:SetNW2String('impact1sound', self.Impact1Sound)
        ent:SetNW2String('impact2sound', self.Impact2Sound)
        ent:SetNW2String('hit1Sound', self.Hit1Sound)
        ent:SetNW2String('hit2Sound', self.Hit2Sound)
        ent:SetNW2String('hit3Sound', self.Hit3Sound)
        ent:SetNW2Angle('anglefix', self.FixedThrowAng)
        ent:SetNW2Angle('spinvector', self.SpinAng)
        ent:SetPos(pos)
        ent:Spawn()
        ent:Activate()
        local f = ply:EyeAngles()
        local ph = ent:GetPhysicsObject()
        if IsValid(ph) then
            ph:SetVelocity(ply:GetAimVector() * (math.max(self.ThrowForce * .5, self.ThrowForce * (self.Charge2 - self.DmgMin2) / (self.DmgMax2 - self.DmgMin2))))
        end
        self.Charge2 = 0
        if IsValid(ply) then
            if SERVER then
                if ply:HasWeapon("meleearts_bludgeon_fists") then
                    ply:SelectWeapon("meleearts_bludgeon_fists")
                end
            end
            ply:StripWeapon(self.WepName)
        end
    end
end

function SWEP:Reload()
    self:Shove()
end

function SWEP:ChangeHoldType(holdtype)
	local wep = self.Weapon
	local old_type = wep:GetHoldType()
	if old_type ~= holdtype then
		wep:SetHoldType(holdtype)
	end
end

--file includes
local function AddFile(File, dir)
    local fileSide = string.lower(string.Left(File, 3))
    if SERVER and fileSide == "sv_" then
        include(dir..File)
    elseif fileSide == "sh_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
        end
        include(dir..File)
    elseif fileSide == "cl_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
        else
            include(dir..File)
        end
    end
end

local function IncludeDir(dir)
    dir = dir .. "/"
    local File, Directory = file.Find(dir.."*", "LUA")

    for k, v in ipairs(File) do
        if string.EndsWith(v, ".lua") then
            AddFile(v, dir)
        end
    end
    
    for k, v in ipairs(Directory) do
        IncludeDir(dir..v)
    end
end

IncludeDir("weapons/dangumeleebase")