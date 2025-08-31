AddCSLuaFile()

local Mul = 0
local MulB = 0
local MulI = 0
local MulBI = 0
local breath = 0

local ModX = 0
local ModY = 0
local ModZ = 0

local ModAngX = 0
local ModAngY = 0
local ModAngZ = 0
local SprintMul = 0

local nearwallang = 0
local rollmul = 0
local shovemul = 0
local stunmul = 0
local whipmul = 0
local fanmul = 0
local throwmul = 0
local veloshit = 0
local sprintmul = 0

local block_effect = 0

net.Receive("ma2_blocked", function()
    block_effect = 4
end)

function SWEP:GetViewModelPosition(pos, ang)
    local ply = self.Owner
    local wep = self.Weapon

    if not IsValid(ply) then
        return
    end

    self.SwayScale = self.DefSwayScale
    self.BobScale = self.DefBobScale

    local FT = 0
    if game.SinglePlayer() then
        FT = FrameTime()
    else
        FT = FrameTime() / 2
    end

    local Offset = Vector(0, 0, 0)

    --wep:SetNW2Int("NearWallMul", nearwallang)

    if ply:KeyDown(IN_MOVERIGHT) then
        veloshit = Lerp(FT * 6, veloshit, - ply:GetVelocity():Length() / 80)
    elseif ply:KeyDown(IN_MOVELEFT) then
        veloshit = Lerp(FT * 6, veloshit, ply:GetVelocity():Length() / 80)
    else
        veloshit = Lerp(FT * 6, veloshit, 0)
    end

    ang = ang * 1

    local charge_strength = (self.Charge-self.DmgMin)/(self.DmgMax-self.DmgMin)
    local throw_strength = (self.Charge2-self.DmgMin2)/(self.DmgMax2-self.DmgMin2)

    if block_effect > 0.01 then
        block_effect = Lerp(FT * 6, block_effect, 0)--math.Approach(block_effect, 0, 10 * FrameTime() * 1.2)
    end

    if ply:GetNW2Bool("MeleeArtAttacking") then
        whipmul = Lerp(FT * (15 * charge_strength), whipmul, 1)
    else
        whipmul = Lerp(FT * 12, whipmul, 0)
    end

    local whip_shake_x = math.sin(CurTime() * 25) * ((charge_strength) * .05)
    local whip_shake_y = math.cos(CurTime() * 50 + math.pi/2) * (charge_strength * .15)
    local whip_shake_z = math.sin(CurTime() * 25 + math.pi) * (charge_strength * .05)

    if ply:GetNW2Bool("MeleeArtThrowing") then
        throwmul = Lerp(FT * (6 * (throw_strength * 1.5)), throwmul, 1)
    else
        throwmul = Lerp(FT * 30, throwmul, 0)
    end

    if ply:GetNW2Bool("MAGuardening") then
        fanmul = Lerp((FT * 15), fanmul, 1)
    else
        fanmul = Lerp(FT * 12, fanmul, 0)
    end

    if ply:GetNW2Bool("MeleeArtShoving") then
        shovemul = Lerp(FT * 30, shovemul, 1)
    else
        shovemul = Lerp(FT * 6, shovemul, 0)
    end

    if ply:GetNW2Bool("MeleeArtStunned") then
        stunmul = Lerp(FT * 15, stunmul, 1)
    else
        stunmul = Lerp(FT * 3, stunmul, 0)
    end

    if ply:IsSprinting() and not ply:GetNW2Bool("MeleeArtAttacking") and not ply:GetNW2Bool("MAGuardening") and ply:GetVelocity():Length() > 200 then
        sprintmul = Lerp(FT * 8, sprintmul, 1)
    else
        sprintmul = Lerp(FT * 4, sprintmul, 0)
    end

    ang:RotateAroundAxis(ang:Right(), (ModAngX * Mul) + (self.ThrowAng.x * throwmul) + (self.StunAng.x * stunmul) + (self.ShoveAng.x * shovemul) + (self.WallAng.x * nearwallang) + (self.RollAng.x * rollmul) + (self.WhipAng.x * whipmul) + (self.FanAng.x * fanmul) + (-12 * sprintmul) + (whip_shake_x * whipmul))
    ang:RotateAroundAxis(ang:Up(), (ModAngY * Mul) + (self.ThrowAng.y * throwmul) + (self.StunAng.y * stunmul) + (self.ShoveAng.y * shovemul) + (self.WallAng.y * nearwallang) + (self.RollAng.y * rollmul) + (self.WhipAng.y * whipmul) + (self.FanAng.y * fanmul + (block_effect)) + (whip_shake_y * whipmul))
    ang:RotateAroundAxis(ang:Forward(), (ModAngZ * Mul) + (veloshit) + (self.ThrowAng.z * throwmul) + (self.StunAng.z * stunmul) + (self.ShoveAng.z * shovemul) + (self.WallAng.z * nearwallang) + (self.RollAng.z * rollmul) + (self.WhipAng.z * whipmul) + (self.FanAng.z * fanmul) + (whip_shake_z * whipmul))

    local Right = ang:Right()
    local Up = ang:Up()
    local Forward = ang:Forward()

    ModX = Offset.x * Right * Mul + (ang:Right() * (self.ThrowPos.x * throwmul)) + (ang:Right() * (self.ShovePos.x * shovemul)) + (ang:Right() * (self.StunPos.x * stunmul)) + (ang:Right() * (self.WallPos.x * nearwallang) + (ang:Right() * (self.RollPos.x * rollmul))) + (ang:Right() * (self.WhipPos.x * whipmul)) + (ang:Right() * (self.FanPos.x * fanmul))
    ModY = Offset.y * Forward * Mul + (ang:Forward() * (self.ThrowPos.y * throwmul)) + (ang:Forward() * (self.ShovePos.y * shovemul)) + (ang:Forward() * (self.StunPos.y * stunmul)) + (ang:Forward() * (self.WallPos.y * nearwallang) + (ang:Forward() * (self.RollPos.y * rollmul))) + (ang:Forward() * (self.WhipPos.y * whipmul)) + (ang:Forward() * (self.FanPos.y * fanmul))
    ModZ = Offset.z * Up * Mul + (ang:Up() * (self.ThrowPos.z * throwmul)) + (ang:Up() * (self.ShovePos.z * shovemul)) + (ang:Up() * (self.StunPos.z * stunmul)) + (ang:Up() * (self.WallPos.z * nearwallang) + (ang:Up() * (self.RollPos.z * rollmul))) + (ang:Up() * (self.WhipPos.z * whipmul)) + (ang:Up() * (self.FanPos.z * fanmul - block_effect))

    Mul = Lerp(FT * 7, Mul, 0)
    MulB = Lerp(FT * 15, MulB, .1)

    if ply:KeyDown(IN_DUCK) then
        MulI = Lerp(FT * 2, MulI, 0)
    else
        MulI = Lerp(FT * 15, MulI, 1)
    end

    breath = (math.sin(CurTime()) / (2)) * MulB
    pos = pos + ModX
    pos = pos + ModY + (EyeAngles():Up() * (breath))
    pos = pos + ModZ

    ang = ang

    ang:RotateAroundAxis(ang:Right(), (math.sin(CurTime() / 2)) * MulI)
    ang:RotateAroundAxis(ang:Up(), (math.sin(CurTime() / 2)) * MulI)
    ang:RotateAroundAxis(ang:Forward(), (math.sin(CurTime() / 2)) * MulI)

    return pos, ang
end