AddCSLuaFile()

local categories = {
    "Axes",
    "Blades",
    "Bludgeons",
    "Spears",
    "Staffs",
    "Other"
}

local captions = {
    ["Axes"] = "Axes apply a debuff to targets, making them take more damage on the next hit. Higher severity increases the modifier",
    ["Blades"] = "Blades cause bleeding on hit. Higher severity increases the bleed damage",
    ["Bludgeons"] = "Bludgeons can disarm opponents (Only applicable to MA2 weapons). Higher severity increases the disarm chance",
    ["Spears"] = "Spears have longer range, and can pierce through blocks resulting in a shorter stun duration and more damage",
    ["Staffs"] = "Staffs start slow but increase in attack rate and charge speed with each hit. Combo reset on miss or holster",
    ["Other"] = "Misc crap"
}

local type_lang = {
    [1] = "Blades",
    [2] = "Axes",
    [3] = "Bludgeons",
    [4] = "Spears",
    [7] = "Staffs"
}

hook.Add("PopulateWeapons", "ma2_weaponTab", function(pnlContent, tree, node)
    timer.Simple(0, function()
		local weapons_list = list.Get("Weapon")
		local ma2_weps = {
            ["Axes"] = {},
            ["Blades"] = {},
            ["Bludgeons"] = {},
            ["Spears"] = {},
            ["Staffs"] = {},
            ["Other"] = {}
        }

        for _, wep in pairs(weapons_list) do
            if weapons.IsBasedOn( wep.ClassName, "dangumeleebase") then
                local wep_stats = weapons.Get(wep.ClassName)
                if not wep_stats.Spawnable then
                    continue
                end
                local wep_type = type_lang[wep_stats.Type] or "Other"
                table.insert(ma2_weps[wep_type], wep)
            end
        end

        -- sort weapons by tier
        for _, wep_category in pairs(ma2_weps) do
            table.sort(wep_category, function(a, b)
                local wep_a = weapons.Get(a.ClassName)
                local wep_b = weapons.Get(b.ClassName)
                return wep_a.Tier < wep_b.Tier
            end)
        end

        for _, category in pairs(tree:Root():GetChildNodes()) do
            if category:GetText() == "Melee Arts 2" then
                --order by type
                category.DoPopulate = function(self)
                    if (self.PropPanel) then return end
                    self.PropPanel = vgui.Create("ContentContainer", pnlContent)
                    self.PropPanel:SetVisible(false)
                    self.PropPanel:SetTriggerSpawnlistChange(false)

                    for category_name, weps in pairs(ma2_weps) do
                        if (#weps <= 0) then
                            continue
                        end

                        local header = vgui.Create("ContentHeader", container)
						header:SetText(category_name)
                        header:SetAutoStretchVertical( true )
                        self.PropPanel:Add(header)

                        local label = vgui.Create("ContentHeader", container)
						label:SetText(captions[category_name] or "No description available")
                        label:SetFont("GModToolHelp")
                        label:SetAutoStretchVertical( true )
                        self.PropPanel:Add(label)

                        for _, ent in pairs(weps) do
							local icon = spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", self.PropPanel, {
                                nicename = ent.PrintName,
                                spawnname = ent.ClassName,
                                material = "entities/" .. ent.ClassName .. ".png",
                                admin = ent.AdminOnly
                            })
						end
                    end
                end
            end
        end
    end)
end)