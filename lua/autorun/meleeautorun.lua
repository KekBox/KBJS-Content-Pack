--[[----------------Welcome to MELEE ART 2's code!----------------------------------------------------------
          __
     w  c(..)o   (
      \__(-)    __)
          /\   (
         /(_)___)
         w /|
          | \
          m  m  do whatever with my code, just give me credit.
--]]-----------------------------------------------------------------------------------------------------------------

CreateConVar("ma2_startwithfists", "0", FCVAR_ARCHIVE, "Sets if the player starts with fists. Default disabled" )
CreateConVar("ma2_togglethrowing", "1", FCVAR_ARCHIVE, "Sets if the player can throw weapons. Default enabled" )
CreateConVar("ma2_toggledefaultfx", "0", FCVAR_ARCHIVE, "Sets the override for if MA2 weapons use the more generic BloodImpact effect for hits. Default disabled" )
CreateConVar("ma2_togglebloodsplats", "1", FCVAR_ARCHIVE, "Sets if there will be blood decals for bleeding and certain weapons. Default enabled" )

CreateConVar("ma2_togglechargeui", "1", FCVAR_ARCHIVE, "Sets if the player sees the attack charge bar. Default enabled" )
CreateConVar("ma2_togglestaffcomboui", "01", FCVAR_ARCHIVE, "Sets if the player sees the staff combo bar. Default enabled" )
CreateConVar("ma2_damagemultiplier", "1", FCVAR_ARCHIVE, "Sets the damage multiplier for all melee weapons. Default is 1" )

CreateConVar("ma2_combatantmaxtier", "4", FCVAR_ARCHIVE, "Sets the maximum tier a combatant can be. Default is 4" )

if SERVER then
	util.AddNetworkString( "ma2_blocked" )
end

function MA2Settings( Panel )
	Panel:ControlHelp( "Weapons" )
    Panel:CheckBox( "Start with fists", "ma2_startwithfists")
	Panel:CheckBox( "Toggle Weapon Throwing", "ma2_togglethrowing")
	Panel:CheckBox( "Toggle Staff Combo UI", "ma2_togglestaffcomboui")
	Panel:CheckBox( "Toggle Charge UI", "ma2_togglechargeui")	
	Panel:NumSlider( "Damage Multiplier", "ma2_damagemultiplier", 0.5, 5,1)

	Panel:Help( " " )
	Panel:ControlHelp( "Effects" )
	Panel:CheckBox( "Toggle generic hit effects", "ma2_toggledefaultfx")	
	Panel:CheckBox( "Toggle blood decal splatter", "ma2_togglebloodsplats")	
	
	Panel:Help( " " )
	Panel:ControlHelp( "Combatants" )
	Panel:NumSlider( "Maximum Tier", "ma2_combatantmaxtier", 1, 4,0)
end

function MeleeArt2Menu()
	spawnmenu.AddToolMenuOption( "Options",
	"Melee Arts 2",
	"meleearts2menu",
	"Settings",
	"custom_doitplease",
	"", -- Resource File( Probably shouldn't use )
	MA2Settings )
end

hook.Add( "PopulateToolMenu", "MeleeArts2MenuYe", MeleeArt2Menu )

function Exposed( target, dmginfo )
	if (  target:GetNW2Bool("MAExpose") == true and target:GetNW2Int( 'exposelevel' )!=0 ) then
		target:EmitSound("npc/zombie/claw_strike3.wav")
		if target:GetNW2Int( 'exposelevel' )==1 then
			dmginfo:ScaleDamage(1.25)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		elseif target:GetNW2Int( 'exposelevel' )==2 then
			dmginfo:ScaleDamage(1.3)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		elseif target:GetNW2Int( 'exposelevel' )==3 then
			dmginfo:ScaleDamage(1.4)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		elseif target:GetNW2Int( 'exposelevel' )==4 then
			dmginfo:ScaleDamage(1.45)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		elseif target:GetNW2Int( 'exposelevel' )==5 then
			dmginfo:ScaleDamage(1.55)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		elseif target:GetNW2Int( 'exposelevel' )==6 then
			dmginfo:ScaleDamage(2)
			target:SetNW2Bool("MAExpose",false)
			target:SetNW2Int( 'exposelevel', 0 )
		end
	end
end
hook.Add("EntityTakeDamage", "ExposeMA",  Exposed )

function Guarding( target, dmginfo )
	if (  target:IsPlayer() and target:GetNW2Bool("MAGuardening") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) ) then
			local wep = target:GetActiveWeapon()
			net.Start("ma2_blocked")
			net.Send(target)
			--target:SetNW2Int( 'MeleeArts2Stamina', math.floor(target:GetNW2Int( 'MeleeArts2Stamina' )-wep.BlockStamina) )
			local w = math.random(1)
			w = math.random(1,2)
			if w == 1 then  
				target:EmitSound(wep.Impact1Sound)
			elseif w == 2 then
				target:EmitSound(wep.Impact2Sound)
			end
			dmginfo:ScaleDamage(0.1)
		elseif (dmginfo:IsDamageType(1)) then
			local wep = dmginfo:GetAttacker():GetActiveWeapon()
			target:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
			target:EmitSound("pierce.mp3")
			if wep.Strength==1 then
				dmginfo:ScaleDamage(0.15)
			elseif wep.Strength==2 then
				dmginfo:ScaleDamage(0.2)
			elseif wep.Strength==3 then
				dmginfo:ScaleDamage(0.25)
			elseif wep.Strength==4 then
				dmginfo:ScaleDamage(0.3)
			elseif wep.Strength==5 then
				dmginfo:ScaleDamage(0.45)
			elseif wep.Strength==6 then
				dmginfo:ScaleDamage(0.5)
			end
		end
	end
end
hook.Add("EntityTakeDamage", "GuardeningMA",  Guarding )

function MADMGMultiplier( target, dmginfo )
	if IsValid(dmginfo:GetAttacker()) then
		if dmginfo:GetAttacker():IsPlayer() then
			local attacker = dmginfo:GetAttacker()
			local wep = attacker:GetActiveWeapon()
			if IsValid(wep) then
				wepCheck = string.find( wep:GetClass(), "meleearts" )
				if wepCheck then
					dmginfo:ScaleDamage(GetConVarNumber("ma2_damagemultiplier"))
				end
			end
		end
	end
end
hook.Add("EntityTakeDamage", "MultiplierMA",  MADMGMultiplier )

function MAMoveSetup(ply,mv,cmd)
	if ply:GetNW2Bool("MeleeArtStunned")==true then
		mv:SetMaxClientSpeed( ply:GetWalkSpeed()*0.15 ) 
	elseif ply:GetNW2Bool("MeleeArtShieldening")==true then
		mv:SetMaxClientSpeed( ply:GetWalkSpeed()*0.5 ) 
	elseif ply:GetNW2Bool("MAGuardening")==true then
		mv:SetMaxClientSpeed( ply:GetWalkSpeed()*0.7 ) 
	elseif ply:GetNW2Bool("MeleeArtAttacking")==true or ply:GetNW2Bool("MeleeArtThrowing")==true then
		mv:SetMaxClientSpeed( ply:GetWalkSpeed()*1.4 ) 
	end

end
hook.Add("SetupMove", "MAMoveSetup", MAMoveSetup)

--[[
function Parry( target, dmginfo )
	if (  target:IsPlayer() and target:GetNW2Bool("MAParryFrame") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(1) ) then
			local wep = target:GetActiveWeapon()
			--target:SetNW2Int( 'MeleeArts2Stamina', math.floor(target:GetNW2Int( 'MeleeArts2Stamina' )-wep.BlockStamina) )
			target:EmitSound("physics/metal/metal_grate_impact_hard3.wav")
			wep.Charge=wep.DmgMax
			
			dmginfo:ScaleDamage(0)
		end
	end
end
hook.Add("EntityTakeDamage", "ParryingMA",  Parry )]]


function Shoving( target, dmginfo )
	if (  target:IsPlayer() and target:GetNW2Bool("MeleeArtShoving") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(1) ) then
			local wep = target:GetActiveWeapon()
			dmginfo:ScaleDamage(1.5)
		end
	end
end
hook.Add("EntityTakeDamage", "ShovingMA",  Shoving )

function DeathArts( ply )
	ply:SetNW2Bool("MeleeArtStunned",false)
	ply:SetNW2Bool("MAExpose",false)
	ply:SetNW2Int( 'exposelevel', 0 )
end
hook.Add("PlayerDeath", "DeathArtsMA",  DeathArts )

function Stunned( target, dmginfo )
	if (  target:IsPlayer() and target:GetNW2Bool("MeleeArtStunned") == true and target:Alive()  ) then
		if not dmginfo:IsDamageType(65536) then
			local wep = target:GetActiveWeapon()
			wep.NextStun = 0
		end
	end
end
hook.Add("EntityTakeDamage", "StunnedMA",  Stunned )
	
function NPCTest( npc, attacker, inflictor )
	if npc:GetNW2Bool("MABoss")==true and npc:GetActiveWeapon():IsValid() then
		if npc:GetActiveWeapon():GetClass() == "npc_cultblade" then
			local ent = ents.Create("chaosbladedrop")      
			ent:SetPos(npc:GetPos() + Vector(0,0,60))
			ent:Spawn()
			ent:Activate()
			local ent = ents.Create("chaos_hat")      
			ent:SetPos(npc:GetPos() + Vector(0,0,40))
			ent:Spawn()
			ent:Activate()
			local effectdata = EffectData() 
			effectdata:SetOrigin( npc:GetPos() + Vector( 0, 0, 40 ) ) 
			effectdata:SetNormal( npc:GetPos():GetNormal() ) 
			effectdata:SetEntity( npc ) 
			util.Effect( "darkenergyshit", effectdata )
			util.Effect( "darkenergyglow", effectdata )
			util.Effect( "darkenergybigaura", effectdata )
			npc:StopSound("spook")
			npc:SetModel("models/player/skeleton.mdl")
			npc:EmitSound("npc/combine_gunship/ping_patrol.wav")
		end
	end
end
hook.Add("OnNPCKilled", "NPCTestMA",  NPCTest )	

function BossBullet( target, dmginfo )
	if (  target:IsNPC() and target:GetNW2Bool("MABoss")==true and target:GetActiveWeapon():IsValid() ) then
		if ( !dmginfo:IsDamageType(4) and !dmginfo:IsDamageType(128) and !dmginfo:IsDamageType(1) and !dmginfo:IsDamageType(65536)) then
			dmginfo:ScaleDamage(0)
		end
	end
end
hook.Add("EntityTakeDamage", "BossBulletMA",  BossBullet )

function BossGuarding( target, dmginfo )
	if (  target:IsNPC() and target:GetNW2Bool("MAGuardening") == true and target:IsValid()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) ) then
			local wep = target:GetActiveWeapon()
			target:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
			dmginfo:ScaleDamage(0.3)
		elseif (dmginfo:IsDamageType(1)) then
			local wep = dmginfo:GetAttacker():GetActiveWeapon()
			target:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
			target:EmitSound("pierce.mp3")
			if wep.Strength==1 then
				dmginfo:ScaleDamage(0.25)
			elseif wep.Strength==2 then
				dmginfo:ScaleDamage(0.3)
			elseif wep.Strength==3 then
				dmginfo:ScaleDamage(0.35)
			elseif wep.Strength==4 then
				dmginfo:ScaleDamage(0.4)
			elseif wep.Strength==5 then
				dmginfo:ScaleDamage(0.45)
			elseif wep.Strength==6 then
				dmginfo:ScaleDamage(0.5)
			end
		end
	end
end
hook.Add("EntityTakeDamage", "BossGuardeningMA",  BossGuarding )

function GiveFists(ply)
	if ply:IsPlayer() and GetConVarNumber( "ma2_startwithfists" ) == 1 then
		ply:Give("meleearts_bludgeon_fists")
	end
end
hook.Add("PlayerSpawn", "GiveFistsMA", GiveFists)

function MASetSpawnInt(ply)	
	ply:SetNW2Int( 'exposelevel', 0 )
end
hook.Add("PlayerSpawn", "SetSpawnIntMA", MASetSpawnInt)
	
	

	

