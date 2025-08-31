function EFFECT:Init(data) --from Hoobsug, since it was just what i was looking for. it's part of his old badass sweps. if he wants this taken out he can gimme a buzz
	
	//if not IsValid(data:GetEntity()) then return end
	//if not IsValid(data:GetEntity():GetOwner()) then return end
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	//if self.WeaponEnt == nil or self.WeaponEnt:GetOwner() == nil or self.WeaponEnt:GetOwner():GetVelocity() == nil then 
		//return
	//else
	
	//self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Position = data:GetOrigin()
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	local emitter = ParticleEmitter(data:GetOrigin())
	local roll = math.random( 0, 360 )
	local size = math.random( 20, 30 )
	local len = math.random( 15, 25 )
	local rollDelta = math.random( -1, 1 )
	local grav = 0.1 * VectorRand()
	
	for i = 10, 20 do
		local slice2 = emitter:Add( "effects/ma2_impact", self.Position )
		slice2:SetColor(230, 230, 230)
		slice2:SetAirResistance( 10000 )
		slice2:SetDieTime( .05 )
		slice2:SetStartSize( 1 )
		slice2:SetEndSize(  math.random( size * .4, size * .6 ) )
		slice2:SetEndAlpha( 0 )
		slice2:SetRoll( math.random( 0, 360 ) )
		--slice2:SetRollDelta( math.random( -1, 1 ) )
	end

	local particle = emitter:Add( "particle/particle_noisesphere", self.Position, (Color(255,100,0,25)) )
	particle:SetVelocity( 0 * VectorRand() + 0 * VectorRand() + 0 * VectorRand() )
	particle:SetGravity( Vector( 0, 0, -50 ) )
	particle:SetAirResistance( 90 )
	particle:SetColor( 127,127,127 )

	particle:SetDieTime( 0.2 )

	particle:SetStartAlpha( 155 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 2 )
	particle:SetEndSize( math.random(6,8) )
	particle:SetRoll( math.random( 0, 360 ) )
	particle:SetLighting( false )

	emitter:Finish()
end
//end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end