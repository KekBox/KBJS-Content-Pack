SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Machete"

SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Melee Arts 2"
SWEP.SlotPos = 1
 


SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=1 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=3 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="meleearts_blade_sword"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.4
SWEP.DmgMin = 5
SWEP.DmgMax = 20
SWEP.Delay = 0.6
SWEP.TimeToHit = 0.2
SWEP.Range = 70
SWEP.Punch1 = Angle(-5, 10, 0)
SWEP.Punch2 = Angle(-5, 0, -3)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.8
SWEP.DmgMin2 = 6
SWEP.DmgMax2 = 18
SWEP.ThrowModel = "models/models/danguyen/machete.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 2500
SWEP.FixedThrowAng = Angle(0,90,0)
SWEP.SpinAng = Vector(1500,0,0)


--HOLDTYPES
SWEP.AttackHoldType="grenade"
SWEP.Attack2HoldType="melee"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="knife"
SWEP.BlockHoldType="physgun"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound={"bladeswing1.mp3", "bladeswing2.mp3", "bladeswing3.mp3"}
SWEP.ThrowSound="axethrow.mp3"
SWEP.Hit1Sound="slash1.mp3"
SWEP.Hit2Sound="slash2.mp3"
SWEP.Hit3Sound="slash1.mp3"

SWEP.Impact1Sound="bladebounce.mp3"
SWEP.Impact2Sound="bladebounce.mp3"

SWEP.ViewModelBoneMods = {
	["LeftArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(1.667, 30, 30), angle = Angle(27.777, 0, 0) },
	["RightHandMiddle1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.256, 0, 0), angle = Angle(0, 0, 0) },
	["RightArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.668, -2.408), angle = Angle(0, 0, 0) },
	["RightHandIndex1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["RightHandThumb1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.556, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0, 0, 0)
SWEP.StunAng = Vector(-16.181, 0, 47.136)

SWEP.ShovePos = Vector(-6.633, -0.403, -1.005)
SWEP.ShoveAng = Vector(-3.518, 70, -70)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(0.201, -2.613, -0.805)
SWEP.WhipAng = Vector(15.477, 5.627, -51.357)

SWEP.ThrowPos = Vector(0, -9.046, 0)
SWEP.ThrowAng = Vector(80, -19.698, 9.145)

SWEP.FanPos = Vector(-14.07, -0.603, -1.211)
SWEP.FanAng = Vector(22.513, -6.332, -90)

SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(0,0,0)

function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 2.4
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
end
left=false
right=true
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1.8
	if right==true then  
		self.Punch1 = Angle(0, -15, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
		right=false
		left=true
	elseif left==true then
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
		left=false
		right=true
	end
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
end


SWEP.VElements = {
	["blade"] = { type = "Model", model = "models/models/danguyen/machete.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0, 0.518, -0), angle = Angle(-5.844, 12.857, -3.507), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["blade"] = { type = "Model", model = "models/models/danguyen/machete.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 1.2, -0.32), angle = Angle(174.156, 75.973, -3.507), size = Vector(1.404, 1.404, 1.404), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}