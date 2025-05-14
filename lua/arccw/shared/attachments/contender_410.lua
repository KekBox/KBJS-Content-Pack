att.PrintName = ".410"
att.Icon = Material("entities/slog_altor_12g.png", "mips smooth")
att.Description = "Small shotgun shell for close quater combat."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"410_ammo"}

att.Mult_Recoil = 1.5
att.Mult_AccuracyMOA = 6
att.Mult_Damage = 1.47
att.Mult_DamageMin = 1.18
att.Mult_Penetration = 0.125
att.Override_Num = 5

att.Override_Ammo = "buckshot"
att.Override_Trivia_Calibre = ".410 Gauge"
att.Override_Trivia_Class = "Shotgun"
att.Override_ShellModel = "models/shells/shell_12gauge.mdl"
att.Override_IsShotgun = true

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound then return "weapons/arccw_slog/altor/fire2.ogg" end
end
