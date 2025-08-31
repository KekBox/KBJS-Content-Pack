ENT.Type 			= "anim"
ENT.PrintName		= "MeleeArtsThrowable"
ENT.Author			= ""
ENT.Information		= "MeleeArtsThrowable"
ENT.Category		= "MeleeArts"

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

	self.Owner = self.Entity.Owner

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( true )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetAngles(self:GetAngles()+self.Entity:GetNW2Angle( 'anglefix' ))
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:AddAngleVelocity(phys:GetAngleVelocity()+self.Entity:GetNW2Vector( 'spinvector' ))
		phys:Wake()
		phys:SetDragCoefficient( 0 ) --makes throwing ridiculous... might renable in the future
		phys:SetMass(1)
		phys:SetDamping(0, 0)
		phys:SetBuoyancyRatio(.5)
	end
	self.Entity:SetNW2Bool("active",true)
	self:Think()
	self.Entity:SetUseType(SIMPLE_USE)

	self.Entity.Trail = util.SpriteTrail( self.Entity, 0, Color( 255, 255, 255 ), false, 3, 1, .1, 1 / ( 15 + 1 ) * 0.5, "trails/smoke" )
end

 function ENT:Think()
	self.Entity:NextThink( CurTime() )

	if self.Entity:WaterLevel()>0 and self.Entity:GetNW2Bool("active") then
		SafeRemoveEntity(self.Entity.Trail)
		self.Entity:SetNW2Bool("active",false)
	end

	return true
end

function ENT:PhyHitDamn()
		end


function ENT:Use(activator, caller)
	if (activator:IsPlayer() and self.Entity:GetNW2Bool("active")==false) then
		if activator:HasWeapon(self.Entity:GetNW2String( 'weaponname' )) then
			activator:PrintMessage(HUD_PRINTTALK,"You already have this weapon!")
		return end
		activator:Give(self.Entity:GetNW2String( 'weaponname' ))
		if self.Entity:GetNW2String( 'weaponname' )=="meleearts_gun" then
			activator:GetWeapon("meleearts_gun"):SetClip1(self.Entity:GetNW2Int( 'gunammo' ))
		end
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data,phys)
	if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
		if self.Entity:GetNW2Bool("active")==false then return end
		local dmginfo = DamageInfo()

		local attacker = self.Entity:GetOwner()
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(4)
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( self.Entity:GetNW2Int( 'throwdamage' ) * 4.17 )
		dmginfo:SetDamageForce( self.Owner:GetForward() * 1500 )
		
		data.HitEntity:TakeDamageInfo( dmginfo )
		
		if data.Speed > 2 then
			local w = math.random(1)
			w = math.random(1,2)
			if w == 1 then  
				self.Entity:EmitSound( self.Entity:GetNW2String( 'impact1sound' ),60)
			elseif w == 2 then
				self.Entity:EmitSound( self.Entity:GetNW2String( 'impact2sound' ),60)
			end
			timer.Simple(.1, function()
				self.Entity:SetNW2Bool("active",false)
			end)
		end
		
		if data.HitEntity:GetBloodColor()~=-1 then
				local effectdata = EffectData() 
				local blood = data.HitEntity:GetBloodColor()
				effectdata:SetColor(blood)
				effectdata:SetOrigin( self.Entity:GetPos() ) 
				effectdata:SetNormal( data.HitEntity:GetPos():GetNormal() ) 
				effectdata:SetEntity( data.HitEntity ) 
				effectdata:SetAttachment(5)
				if GetConVarNumber( "ma2_togglebloodsplats" ) == 1 then
					if data.HitEntity:GetBloodColor()==0 then
						util.Effect( "bloodsplat", effectdata )
					else
						util.Effect( "bloodsplatyellow", effectdata )
					end
				end
				if GetConVarNumber( "ma2_toggledefaultfx" ) == 1 then
					util.Effect("BloodImpact", effectdata, true, true)
				else
					util.Effect( "ma2_slice", effectdata ) 
				end
			else
				local effectdata = EffectData() 
				effectdata:SetOrigin( self.Entity:GetPos() ) 
				effectdata:SetNormal( data.HitEntity:GetPos():GetNormal() ) 
				effectdata:SetEntity( data.HitEntity ) 
				effectdata:SetAttachment(5)
				util.Effect( "MetalSpark", effectdata)
			end
		local w = math.random(1)
		w = math.random(1,3)
		if w == 1 then  
			self.Entity:EmitSound( self.Entity:GetNW2String( 'hit1sound' ))
		elseif w == 2 then
			self.Entity:EmitSound( self.Entity:GetNW2String( 'hit2sound' ))
		elseif w == 3 then
			self.Entity:EmitSound( self.Entity:GetNW2String( 'hit3sound' ))
		end
		SafeRemoveEntity(self.Entity.Trail)
		self.Entity:SetNW2Bool("active",false)
	end

	if data.Speed > 2 then
		local w = math.random(1)
		w = math.random(1,2)
		if w == 1 and self.Entity:GetNW2Bool("active")==true then  
			self.Entity:EmitSound( self.Entity:GetNW2String( 'impact1sound' ),60)
		elseif w == 2 and self.Entity:GetNW2Bool("active")==true then
			self.Entity:EmitSound( self.Entity:GetNW2String( 'impact2sound' ),60)
		end
		if self.Entity:GetNW2Bool("active")==true then
			SafeRemoveEntity(self.Entity.Trail)
			self.Entity:SetNW2Bool("active",false)

			local effectdata = EffectData() 
			effectdata:SetOrigin( self.Entity:GetPos() ) 
			effectdata:SetNormal( self.Entity:GetPos():GetNormal() ) 
			effectdata:SetEntity( self.Entity ) 
			util.Effect( "ma2_wack", effectdata )
			util.Effect( "MetalSpark", effectdata )
		end
	end
	self:PhyHitDamn()

	--local impulse = -data.Speed * data.HitNormal * 0.9 + (data.OurOldVelocity * -0.7)
--	phys:ApplyForceCenter(impulse)
	
end

end