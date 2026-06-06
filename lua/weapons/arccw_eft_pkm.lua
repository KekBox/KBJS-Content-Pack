SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Escape From Tarkov"
SWEP.PrintName = "PKM"
SWEP.TrueName = "PKM"
SWEP.Slot = 3
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/arc9/darsu_eft/c_pk.mdl"
SWEP.WorldModel = "models/weapons/arc9/darsu_eft/c_pk.mdl"

-- костыль в связи с использование модели не предназначенной для отображения её в мире
function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    local wm = self
    if IsValid(owner) then
        local boneIndex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if boneIndex then
            local pos, ang = owner:GetBonePosition(boneIndex)
            if pos and ang then
                pos = pos + ang:Forward() * -9
                pos = pos + ang:Right() * 5
                pos = pos + ang:Up() * -7.6
                ang:RotateAroundAxis(ang:Right(), -5)
                ang:RotateAroundAxis(ang:Up(), 0)
                ang:RotateAroundAxis(ang:Forward(), 180)
                self:SetRenderOrigin(pos)
                self:SetRenderAngles(ang)
            end
        end
    else
        self:SetRenderOrigin(nil)
        self:SetRenderAngles(nil)
    end
    if IsValid(owner) and owner:IsPlayer() then
    local vm = owner:GetViewModel()
    if IsValid(vm) then
        for i = 0, vm:GetNumBodyGroups() - 1 do
            local bg = vm:GetBodygroup(i)
            self:SetBodygroup(i, bg)
        end
    end
end
    self:DrawModel()
end

SWEP.ViewModelFOV = 68
SWEP.Trivia_Desc = [[
ПКМ (The PK (Пулемёт Калашниковова, "Kalashnikov's machine gun") is a belt-fed general-purpose machine gun,
chambered for the 7.62×54 mm R-rimmed cartridge.
The PKM machine gun was developed in the late 1960s based on the PK machine gun design at the Izhevsk Machine-Building Plant design bureau under the direction of M. T. Kalashnikov.]]
SWEP.Trivia_Manufacturer = "Degtyaryov Plant"
SWEP.Trivia_Class = "General-purpose machine gun"
SWEP.Trivia_Calibre = "7,62×54 мм R"
SWEP.Trivia_Country = "USSR"
SWEP.Trivia_Mechanism = "Gas-operated, long-stroke piston, open, rotating bolt"
SWEP.Trivia_Year = "1969"

SWEP.Tracer = "arccw_tracer" -- опционально: можно оставить, но отключим число трассеров
SWEP.Primary.Ammo = "ar2"
SWEP.Damage         = 108
SWEP.DamageMin      = 117
SWEP.RangeMin       = 250
SWEP.Range          = 64
SWEP.RangeMin       = 32
SWEP.Penetration    = 70
SWEP.MuzzleVelocity = 850
SWEP.HoldtypeActive = "ar2"

SWEP.Primary.ClipSize = 100
SWEP.ChamberSize = 0
SWEP.Delay = 60 / 650
SWEP.AccuracyMOA = 3
SWEP.HipDispersion = 400
SWEP.MoveDispersion = 100
SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.6
SWEP.SightTime = 1
SWEP.AimDownSightsTime = 1
SWEP.SprintToFireTime = 0.75
SWEP.Recoil = 1.2
SWEP.RecoilSide = 1.2
SWEP.RecoilRise = 1
SWEP.ShellScale = 1

SWEP.Firemodes = {
    { Mode = 2, PrintName = "Automatic" },
    { Mode = 0, PrintName = "Safety"},
}

SWEP.IronSightStruct = {
    Pos = Vector(-4.25, -5, 1.835),
    Ang = Angle(0, 0.01, 0),
    Magnification = 1.1,
}

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "iron sights",
        Slot = "optic_lp",
        Bone = "mod_sight_rear",
        Offset = {
            vpos = Vector(0, 4, 0),
            vang = Angle(0, -90, 0),
        },
        Magnification = 0.5,
        CorrectiveAng = Angle(0, 180, 0),
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "PKM",
        Slot = "pkm_barrel",
        Bone = "mod_barrel",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "No attachments",
        Slot = "pkm_muzzle",
        Bone = "mod_muzzle",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        PrintName = "Forend",
        DefaultAttName = "Not mounted",
        Slot = "pkm_handguard",
        Bone = "mod_handguard",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        PrintName = "Underbarrel",
        DefaultAttName = "No attachment",
        Slot = "pkm_bipod",
        Bone = "mod_bipod",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(0,0,0),
            wang = Angle(0,0,0),
        },
		RequireFlags = { "handguard_std" },
        MergeSlots = {9}
    },
    {
        PrintName = "Пистолетная рукоятка",
        DefaultAttName = "Штатная рукоять",
        Slot = {"pkp_grip","pkm_grip"},
        Bone = "mod_pistolgrip",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
        Installed = "grip_p",
        Integral = true,
    },
    {
        PrintName = "Stock",
        DefaultAttName = "Standart stock",
        Slot = "pkm_stock",
        Bone = "mod_stock",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        PrintName = "Ammo type",
        DefaultAttName = "7.62x54[R]",
        Slot = "uc_ammo",
        Bone = "pkm_stock",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        Hidden = false,
        Slot = "foregrip",
        Bone = "mod_bipod",
        Offset = {
            vpos = Vector(0, -4, -0.4),
            vang = Angle(0, 270, 0),
        },
    },
}


----------------------------------------------------------------------------------- ЗВУКИ И АНИМАЦИИ
SWEP.ShootSound = "weapons/darsu_eft/pkm/mk18_fire_close.ogg"
SWEP.ShootDrySound = "fas2/empty_sniperrifles.wav"
SWEP.DistantShootSound = "weapons/darsu_eft/pkm/mk18_fire_distant.ogg"
SWEP.DryFireSound = "weapons/darsu_eft/pkm/ash12_trigger_empty.ogg"


hook.Add("PlayerButtonDown", "ArcCW_MultiAnimBind", function(ply, button)
    if not IsValid(ply) then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local keyBinds = wep.Keybinds and wep:Keybinds()
    if not keyBinds or not keyBinds[button] then return end
    local animData = keyBinds[button]
    wep.AnimCooldowns = wep.AnimCooldowns or {}
    wep.LastAnimTime = wep.LastAnimTime or 0
    if not wep.AnimCooldowns[animData.anim] or CurTime() >= wep.AnimCooldowns[animData.anim] then
        if CurTime() - wep.LastAnimTime >= 5 then
            if wep.PlayAnimation then
                wep:PlayAnimation(animData.anim)
            elseif wep.AnimPlay then
                wep:AnimPlay(animData.anim)
            end
            wep.LastAnimTime = CurTime()
            wep.AnimCooldowns[animData.anim] = CurTime() + animData.cooldown
        end
    end
end)


SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["idle_sights"] = {
        Source = "idle_sights"
    },
    ["holster"] = {
        Source = "holster",
        SoundTable = {
            { s = "arc9_eft_shared/weap_out.ogg", t = 0 },
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_4.ogg", t = 0.2 },
        }
    },
    ["ready"] = {
        Source = "ready",
        Time = 2.5,
        SoundTable = {
            { s = "arc9_eft_shared/weap_in.ogg", t = 0.05 },
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 0.3 },
            { s = "weapons/darsu_eft/pkm/pk_charge_out.ogg", t = 1.2 },
            { s = "weapons/darsu_eft/pkm/pk_charge_in.ogg", t = 1.4 },
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_1.ogg", t = 1.6 },
        }
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            { s = "arc9_eft_shared/weap_in.ogg", t = 0.05 },
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 0.3 },
        }
    },
    ["fire"] = {
        Source = "fire",
        Time = 0.2,
        SoundTable = {
            { s = {"weapons/darsu_eft/pkm/pk_belt_1.ogg","weapons/darsu_eft/pkm/pk_belt_2.ogg","weapons/darsu_eft/pkm/pk_belt_3.ogg","weapons/darsu_eft/pkm/pk_belt_4.ogg",}, t = 0.1 },
        }
    },
    ["fire_sights"] = {
        Source = {"fire_sights1","fire_sights2","fire_sights3"},
        SoundTable = {
            { s = {"weapons/darsu_eft/pkm/pk_belt_1.ogg","weapons/darsu_eft/pkm/pk_belt_2.ogg","weapons/darsu_eft/pkm/pk_belt_3.ogg","weapons/darsu_eft/pkm/pk_belt_4.ogg",}, t = 0.1 },
        }
    },
    ["reload"] = {
        Source = "reload",
        Time = 8.3,
        SoundTable = {
            {s = "weapons/darsu_eft/pkm/pk_cover_open.ogg", t = 1.2},
            {s = "weapons/darsu_eft/pkm/pk_belt_out.ogg", t = 1.8},
            {s = "weapons/darsu_eft/pkm/pk_mag_out.ogg", t = 3},
            {s = "weapons/darsu_eft/pkm/pk_mag_in.ogg", t = 5.2},
            {s = "weapons/darsu_eft/pkm/pk_belt_in.ogg", t = 6},
            {s = "weapons/darsu_eft/pkm/pk_cover_close.ogg", t = 6.7}
        }
    },
    ["reload_empty"] = {
        Source = "reload_empty", 
        Time = 8.5,
        SoundTable = {
            {s = "weapons/darsu_eft/pkm/pk_cover_open.ogg", t = 1.2},
            {s = "weapons/darsu_eft/pkm/pk_belt_out.ogg", t = 1.8},
            {s = "weapons/darsu_eft/pkm/pk_mag_out.ogg", t = 2.5},
            {s = "weapons/darsu_eft/pkm/pk_mag_in.ogg", t = 4.73},
            {s = "weapons/darsu_eft/pkm/pk_belt_in.ogg", t = 5.55},
            {s = "weapons/darsu_eft/pkm/pk_charge_full.ogg", t = 6.7},
            {s = "weapons/darsu_eft/pkm/pk_cover_close.ogg", t = 6}
        },
    },
    ["enter_sight"] = {
        Source = "ironsight_in", Time = 1.3,
        SoundTable = {{s = "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 0.15}}
    },
    ["exit_sight"] = {
        Source = "ironsight_out", Time = 0.93,
        SoundTable = {{s = "weapons/darsu_eft/pkm/pk_gun_flip_4.ogg", t = 0.15}}
    },
    ------------------------------------------ ДОП АНИМАЦИИ
    ["magcheck"] = {
        Source = "magcheck",
        SoundTable = {
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_3.ogg", t = 0.28 },
            { s =  "weapons/darsu_eft/pkm/pk_belt_5.ogg", t = 1.18 },
            { s =  "weapons/darsu_eft/pkm/pk_dust_open.ogg", t = 1.33-0.2 },
            { s =  "weapons/darsu_eft/pkm/pk_dust_close.ogg", t = 2.74-0.75 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 3.3-0.2 },
        },
    },
    ["inspect"] = {
        Source = "check_chamber",
        SoundTable = {
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 0.25 },
            { s = "weapons/darsu_eft/pkm/pk_cover_open.ogg", t = 1.0 },
            { s = "weapons/darsu_eft/pkm/pk_gun_flip_5.ogg", t = 1.32-0.5 },
            { s = "weapons/darsu_eft/pkm/pk_cover_close.ogg", t = 2.8-1 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_5.ogg", t = 2.9 },
        },
    },
    ["inspect1"] = {
        Source = "look",
        SoundTable = {
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_2.ogg", t = 0.05 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_5.ogg", t = 0.45 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_3.ogg", t = 1.65 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_4.ogg", t = 2.8 },
            { s =  "weapons/darsu_eft/pkm/pk_gun_flip_1.ogg", t = 3.15 },
        },
    },
}


SWEP.DefaultBodygroups = "001110000001"

SWEP.AttachmentElements = {
    ["mag"] = {
        VMBodygroups = {
            {ind = 3, bg = 1}
        }
    },
    ["belt"] = {
        VMBodygroups = {
            {ind = 2, bg = 1}
        }
    },
    ["bipod_folded"] = {
        VMBodygroups = {
            {ind = 5, bg = 1}
        }
    },
    ["bipod_unfolded"] = {
        VMBodygroups = {
            {ind = 5, bg = 2}
        },
    },
    ["barrel_pkp"] = {
        VMBodygroups = {
            {ind = 4, bg = 2}
        }
    },
    ["handguard_std"] = {
        VMBodygroups = {
            {ind = 6, bg = 1}
        }
    },
    ["muzzle_std"] = {
        VMBodygroups = {
            {ind = 8, bg = 1}
        }
    },
    ["muzzle_long"] = {
        VMBodygroups = {
            {ind = 8, bg = 2}
        }
    },
    ["muzzle_dtk"] = {
        VMBodygroups = {
            {ind = 8, bg = 3}
        }
    },
    ["grip_std"] = {
        VMBodygroups = {
            {ind = 9, bg = 1}
        }
    },
    ["grip_p"] = {
        VMBodygroups = {
            {ind = 9, bg = 2}
        }
    },
    ["stock_pkm1"] = {
        VMBodygroups = {
            {ind = 11, bg = 1}
        }
    },
    ["stock_pkm2"] = {
        VMBodygroups = {
            {ind = 11, bg = 2}
        }
    },
    ["stock_pkm3"] = {
        VMBodygroups = {
            {ind = 11, bg = 3}
        }
    },
}