local bar_alpha = 255
local bar_alpha_2 = 255
local charge_bar = {
    x = (ScrW() / 2.0),
    y = ScrH() / 2.0 + ScreenScale(80),
    w = ScreenScale(120),
    h = ScreenScale(3)
}
local attack_bar_length = charge_bar.w
local staff_bar_length = charge_bar.w

function SWEP:DrawHUD()
    local ratio = 66 / (1/FrameTime())
    local staff_bar_color = Color(80, 255, 120, bar_alpha_2)
    local charge_bar_color = Color(255, 255, 255, bar_alpha)
    local charge_bar_full = Color(255, 213, 0, bar_alpha)

    if self.Type == 7 and GetConVarNumber( "ma2_togglestaffcomboui" ) == 1 then
        local combo = self.Weapon:GetNW2Int("QSChain")

        if combo == 0 then
            bar_alpha_2 = math.Approach(bar_alpha_2, 0, 255 * FrameTime() * 1.2)
        else
            bar_alpha_2 = math.Approach(bar_alpha_2, 255, 255 * FrameTime() * .8)
        end

        local bar_speed = combo>0 and 1 or 2
        staff_bar_length = math.Approach(staff_bar_length, charge_bar.w * (combo/6), 255 * FrameTime() * bar_speed)
        surface.SetDrawColor(staff_bar_color)
        surface.DrawRect(charge_bar.x - (staff_bar_length / 2), charge_bar.y + ScreenScale(3), staff_bar_length, ScreenScale(2))
    end

    if self.Charge <= 0 and self.Charge2 <= 0 then
        bar_alpha = 0
    else
        bar_alpha = math.Approach(bar_alpha, 255, 255 * FrameTime() * 3)
    end

    if self.Charge2<= 0 and self.Owner:KeyDown(IN_ATTACK) and !self.Owner:GetNW2Bool("MAGuardening") and !self.Owner:GetNW2Bool("MeleeArtAttacking2") then --Primary Attack
		if self.Owner:GetNW2Bool("MeleeArtStunned")==true or self.Owner:GetNW2Bool("MeleeArtThrowing")==true or self.Weapon:GetNextPrimaryFire() > CurTime() then 
            return 
        end
        self.Charge2=0

        if self.Type==7 then
            self.Charge = math.Clamp(self.Charge + ((self.ChargeSpeed*(1+((self.Weapon:GetNW2Int("QSChain")/8)*self.Speed))) * ratio), self.DmgMin, self.DmgMax)
        else
            self.Charge = math.Clamp(self.Charge + (self.ChargeSpeed * ratio), self.DmgMin, self.DmgMax)
        end
        local charge_amount = (self.Charge-self.DmgMin)/(self.DmgMax-self.DmgMin)
        attack_bar_length = charge_bar.w * charge_amount

        if charge_amount == 1 then
            surface.SetDrawColor(charge_bar_full)
        else
            surface.SetDrawColor(charge_bar_color)
        end
        
        if GetConVarNumber( "ma2_togglechargeui" ) == 1 then
            surface.DrawRect(charge_bar.x - (attack_bar_length / 2), charge_bar.y, attack_bar_length, charge_bar.h)
        end
    else
        self.Charge = 0
    end
    
    if self.Owner:KeyDown(IN_WALK) and !self.Owner:GetNW2Bool("MAGuardening") and self.CanThrow == true and GetConVarNumber( "ma2_togglethrowing" ) == 1 and self.Owner:GetNW2Bool("MeleeArtStunned")==false then
        if self.Weapon:GetNextSecondaryFire() < CurTime() then
			self.Charge2 = math.Clamp(self.Charge2 + (self.ChargeSpeed2  * ratio), self.DmgMin2, self.DmgMax2)
        end
        local charge_amount = (self.Charge2-self.DmgMin2)/(self.DmgMax2-self.DmgMin2)
        attack_bar_length = charge_bar.w * charge_amount
        if charge_amount == 1 then
            surface.SetDrawColor(charge_bar_full)
        else
            surface.SetDrawColor(charge_bar_color)
        end

        if GetConVarNumber( "ma2_togglechargeui" ) == 1 then
            surface.DrawRect(charge_bar.x - (attack_bar_length / 2), charge_bar.y, attack_bar_length, charge_bar.h)
        end
    else
        self.Charge2 = 0
    end
end