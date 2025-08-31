function SWEP:Shove()
	local ply=self.Owner
	if CurTime() < self.NextFireShove then return end
	if ply:GetNW2Bool("MeleeArtStunned")==true or ply:GetNW2Bool("MeleeArtAttacking")==true or ply:GetNW2Bool("MeleeArtThrowing")==true or ply:GetNW2Bool("MAGuardening")==true then return end
	
	wep=self.Weapon
	local ply = ply
	local wep = self.Weapon
	
	if SERVER then
		ply:EmitSound("shove.mp3")
		ply:LagCompensation( true )
		ply:SetNW2Bool("MeleeArtShoving", true)
		timer.Simple(0.25, function()
			if ply:Alive() then
				ply:SetNW2Bool("MeleeArtShoving", false)
			end
		end)
	end
	ply:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE , 2 )
	local tr = util.TraceLine( {
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 48,
		filter = ply,
		mask = MASK_SHOT_HULL
	} )
	
	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 48,
			filter = ply,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	local hit = false
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer()) ) then
		local dmginfo = DamageInfo()

		local attacker = ply
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(128)
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 1 )
		dmginfo:SetDamageForce( ply:GetForward() * 5000 )
		
		tr.Entity:TakeDamageInfo( dmginfo )
		
		if tr.Entity:IsPlayer() then
			if tr.Entity:GetNW2Bool("MAGuardening")==true then
				local enemywep=tr.Entity:GetActiveWeapon()
				tr.Entity:SetNW2Bool("MAGuardening",false)
				enemywep.NextStun = CurTime() + 1.5
				timer.Simple(0, function()
					tr.Entity:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE , 4)
				end)
				tr.Entity:ViewPunch( Angle( -20, 0, 0 ) )
				tr.Entity:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
			end
		end
		
		if tr.Entity:IsNPC() and tr.Entity:GetNW2Bool("MABoss")==true or tr.Entity:IsNPC() and tr.Entity:GetNW2Bool("MACombatant")==true then
			if tr.Entity:GetNW2Bool("MAGuardening")==true then
				--tr.Entity:StopMoving()
				--tr.Entity:ExitScriptedSequence()
				tr.Entity:GetActiveWeapon():Stun2()
			end
		end
		if SERVER then
			ply:EmitSound("physics/body/body_medium_impact_soft1.wav")
		end
		
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( ply:GetAimVector() * math.floor(self.Charge)*2 * phys:GetMass(), tr.HitPos )
		end
	end

	if SERVER then
		ply:LagCompensation( false )
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	self.NextFireShove = CurTime() + 1
	self.NextFireBlock = CurTime() + self.Delay
end

hook.Add( "DoAnimationEvent" , "MA2ShoveStunEvents" , function( ply , event , data )
	--TODO: clean this up
	if event == PLAYERANIMEVENT_ATTACK_GRENADE then
		if data == 4 then
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_LAND, true )
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_HL2MP_FIST_BLOCK, false )
			return ACT_INVALID
		end
		if data == 3 then
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_LAND, true )
			return ACT_INVALID
		end
		if data == 2 then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true )
			return ACT_INVALID
		end
	end
end)
