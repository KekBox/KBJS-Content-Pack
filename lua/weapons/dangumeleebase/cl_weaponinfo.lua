function SWEP:PrintWeaponInfo(x, y, alpha)
    if not self.DrawWeaponInfoBox then return end

    if not self.InfoMarkup then
        local Colors = {
            tier1 = "<color=45,255,86,255>",
            tier2 = "<color=45,88,255,255>",
            tier3 = "<color=216,45,255,255>",
            tier4 = "<color=255,45,80,255>",
            tier5 = "<color=255,230,45,255>",
            title = "<color=230,230,230,255>",
            text = "<color=150,150,150,255>",
            joke = "<color=255,20,147,255>"
        }

        local str_parts = {"<font=HudSelectionText>"}
        local add_line = function(title, content, content_color)
            table.insert(str_parts, Colors.title .. title .. "</color>\t")
            table.insert(str_parts, (content_color or Colors.text) .. tostring(content) .. "</color>\n")
        end

        local add_description = function(description)
            table.insert(str_parts, Colors.title .. description .. "</color>\n\n")
        end

        local tier_colors = {
            [1] = Colors.tier1,
            [2] = Colors.tier2,
            [3] = Colors.tier3,
            [4] = Colors.tier4,
            [5] = Colors.tier5
        }
        local tier_stars = string.rep("★", self.Tier)
        if self.Tier and tier_colors[self.Tier] then
            add_line("Tier:", tier_stars, tier_colors[self.Tier])
        end

        local weapon_types = {
            [1] = {name = "Blade", desc = "Blades are weapons that afflict bleeding with every hit."},
            [2] = {name = "Axe", desc = "Axes apply exposure after every hit, which increases the damage taken from all sources."},
            [3] = {name = "Bludgeon", desc = "Bludgeons are stronger weapons that have a chance to disarm the opponent. (Only works with MA2 weapons)"},
            [4] = {name = "Spear", desc = "Spears have longer ranges, better throw damage, and pierce through guards, dealing more damage and having less stun time."},
            [5] = {name = "Shield"},
            [6] = {name = "Special"},
            [7] = {name = "Quarterstaff", desc = "Quarterstaffs gain more speed with every hit. Missing a hit resets the speed bonus."},
            [666] = {name = "Jesus's own Pencil"}
        }

        if self.Type and weapon_types[self.Type] then
            local type_info = weapon_types[self.Type]
            add_line("Type:", type_info.name)
            if type_info.desc then
                add_description(type_info.desc)
            end
        end

        local dmg_multiplier = GetConVarNumber("ma2_damagemultiplier")
        add_line("Damage:", string.format("%.0f-%.0f", self.DmgMin * dmg_multiplier, self.DmgMax * dmg_multiplier))

        if not self.CanThrow or GetConVarNumber("ma2_togglethrowing") == 0 then
            add_line("Throw:", "Can't throw this weapon")
        else
            add_line("Throw:", string.format("%.0f-%.0f", self.DmgMin2 * dmg_multiplier, self.DmgMax2 * dmg_multiplier))
        end

        if self.Speed then
            add_line("Speed:", string.rep("█", self.Speed))
        end

        if self.Strength then
            add_line("Severity:", string.rep("█", self.Strength))
        end
        
        if self.JokeWep then
            table.insert(str_parts, Colors.joke .. "\nJoke Weapon\n")
        end

        if self.Instructions and self.Instructions ~= "" then
            add_description(self.Instructions)
        end

        table.insert(str_parts, "</font>")
        self.InfoMarkup = markup.Parse(table.concat(str_parts), 250)
    end

    surface.SetDrawColor(60, 60, 60, alpha)
    surface.SetTexture(self.SpeechBubbleLid)

    surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
    draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))

    self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end