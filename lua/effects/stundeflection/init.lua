function EFFECT:Init(data)
	
	//self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Position = data:GetOrigin()
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	local light = DynamicLight( 0 )
	if( light ) then	
		light.Pos = self:GetPos()
		light.Size = 150
		light.Decay = 500
		light.R = 255
		light.G = 200
		light.B = 100
		light.Brightness = .3
		light.DieTime = CurTime() + 0.2
	end
	
	local AddVel = 5//self.WeaponEnt:GetOwner():GetVelocity()
	local emitter = ParticleEmitter(self.Position)
		
	if emitter != nil then	
		local particle = emitter:Add( "particle/particle_glow_03", self.Position, (Color(255,100,0,25)) )
		if particle != nil then
			particle:SetColor( 255,165,100 )

			particle:SetDieTime( 0.2 )

			particle:SetStartSize( 1 )
			particle:SetEndSize( 40 )
		end
	end
		
	local flash = emitter:Add( "effects/ar2_altfire1b", self.Position, (Color(255,100,0,25)) )
	flash:SetColor( 255,150,50 )

	flash:SetDieTime( 0.1 )

	flash:SetStartSize( 20 )
	flash:SetEndSize( 5 )

	for i=0, math.random(2,6) do
		if emitter != nil then	
			local particle = emitter:Add( "particles/fire_glow", self.Position, (Color(255,100,0,25)) )
			if particle != nil then

				particle:SetVelocity( 50 * VectorRand() + 50 * VectorRand() + 50 * VectorRand() )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetAirResistance( 90 )
				particle:SetColor( 255,255,255 )

				particle:SetDieTime( math.Rand( 1.5, 2.5 ) )

				particle:SetStartSize( 1 )
				particle:SetEndSize( 0 )
				particle:SetStartLength( math.Rand( 3, 5 ) ) 
				particle:SetEndLength( 0 )

				particle:SetRoll( math.Rand( 180, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetBounce( 1 )
				particle:SetCollide( true )
			end
		
		end
	end

	for i=0, math.random(2,6) do
		if emitter != nil then	
			local particle = emitter:Add( "particles/fire_glow", self.Position, (Color(255,100,0,25)) )
			if particle != nil then

				particle:SetVelocity( 20 * VectorRand() + 20 * VectorRand() + 20 * VectorRand() )
				particle:SetColor( 255,255,255 )

				particle:SetDieTime( .3 )

				particle:SetStartSize( 0 )
				particle:SetEndSize( 1 )
				particle:SetStartLength( math.Rand( 10, 20 ) ) 
				particle:SetEndLength( 20 )

				particle:SetRoll( math.Rand( 180, 480 ) )
			end
		
		end
	end
	local particle = emitter:Add( "particle/particle_ring_refract_01", self.Position )
	particle:SetDieTime( .5 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetColor( 255,255,255 )
	particle:SetStartSize( 5 )
	particle:SetEndSize( 40 )
	particle:SetRoll( math.Rand(0, 360) )
	particle:SetRollDelta( math.Rand(-1, 1) )
	particle:SetAirResistance( 200 ) 
	emitter:Finish()
end
//end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end