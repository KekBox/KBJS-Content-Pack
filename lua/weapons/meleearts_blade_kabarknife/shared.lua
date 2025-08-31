SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Tanto"

SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Melee Arts 2"
SWEP.SlotPos = 1
 


SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_xiandagger.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=1 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=2 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=5 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=2 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="meleearts_blade_kabarknife"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.4
SWEP.DmgMin = 4
SWEP.DmgMax = 18
SWEP.Delay = 0.35
SWEP.TimeToHit = 0.1
SWEP.AttackAnimRate = 1.2
SWEP.Range = 55
SWEP.Punch1 = Angle(0, 5, 0)
SWEP.Punch2 = Angle(0, -5, 5)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.6
SWEP.DmgMin2 = 8
SWEP.DmgMax2 = 24
SWEP.ThrowModel = "models/models/danguyen/w_tant0_ct.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 3500
SWEP.FixedThrowAng = Angle(0,0,0)
SWEP.SpinAng = Vector(0,1500,0)

--HOLDTYPES
SWEP.AttackHoldType="melee"
SWEP.Attack2HoldType="knife"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="knife"
SWEP.BlockHoldType="camera"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound={"knifeswing1.mp3", "knifeswing2.mp3"}
SWEP.ThrowSound="knifethrow.mp3"
SWEP.Hit1Sound="slash1.mp3"
SWEP.Hit2Sound="slash2.mp3"
SWEP.Hit3Sound="slash3.mp3"

SWEP.Impact1Sound="bladebounce.mp3"
SWEP.Impact2Sound="bladebounce.mp3"

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.156, -6.468, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.467, -60.36, 25.868) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 2.155) },
	["Weapon"] = { scale = Vector(0.001, 0.001, 0.001), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 8.623, 6.467) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-6.468, -7.546, -11.856), angle = Angle(0, 38.801, -6.468) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.155, -15.091, -2.156) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.468, 8.623, 10.777) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(-11.61, -3.415, 9.56)

SWEP.ShovePos = Vector(-1.951, -10.537, -3.708)
SWEP.ShoveAng = Vector(0, 47.805, -55.318)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.WhipPos = Vector(-4.68, -5.829, -0.202)
SWEP.WhipAng = Vector(14.069, 42.21, -8.443)

SWEP.ThrowPos = Vector(0,0,0)
SWEP.ThrowAng = Vector(40.101, -56.281, 19.697)

SWEP.FanPos = Vector(-0.801, -7.237, -0.76)
SWEP.FanAng = Vector(2.813, 14.774, -41.508)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
	self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
end

function SWEP:AttackAnimation2()
	local die = math.random(1, 4)
	if die == 1 then
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	else
		self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
	end
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end


SWEP.VElements = {
	["blade"] = { type = "Model", model = "models/models/danguyen/w_tant0_ct.mdl", bone = "Weapon", rel = "", pos = Vector(5, 3.635, 0.518), angle = Angle(-10.52, 115.713, -85.325), size = Vector(1.379, 1.34, 1.21), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["blade"] = { type = "Model", model = "models/models/danguyen/w_tant0_ct.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.82, 1.557, -0.519), angle = Angle(-164.805, -180, -3.507), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
