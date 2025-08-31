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
	local size = math.random( 60, 100 )
	local len = math.random( 15, 25 )
	local rollDelta = math.random( -1, 1 )
	local grav = 0.1 * VectorRand()

	for i = 2, 3 do
		local slice = emitter:Add( "effects/ma2_slice", self.Position )
		slice:SetColor(127, 0, 0)
		slice:SetAirResistance( 10000 )
		slice:SetDieTime( .12 )
		slice:SetGravity( grav )
		slice:SetStartSize( size * math.random(.8, 1.1) )
		slice:SetEndSize( size * math.random(.8, 1.1) )
		slice:SetStartLength( len ) 
		slice:SetEndLength( 0 )
		slice:SetEndAlpha( 255 )
		slice:SetRoll( roll )
		slice:SetRollDelta( rollDelta )
	end

	local slice2 = emitter:Add( "effects/ma2_slice", self.Position )
	slice2:SetColor(200, 200, 200)
	slice2:SetAirResistance( 10000 )
	slice2:SetDieTime( .08 )
	slice2:SetStartSize( size * .2 )
	slice2:SetEndSize( 0 )
	slice2:SetEndAlpha( 255 )
	slice2:SetRoll( roll )
	slice2:SetRollDelta( rollDelta )

	for i = 10, 20 do
		local slice3 = emitter:Add( "effects/ma2_impact", self.Position )
		slice3:SetColor(127, 0, 0)
		slice3:SetAirResistance( 10000 )
		slice3:SetGravity( Vector(0, -10, 0) )
		slice3:SetDieTime( .2 )
		slice3:SetStartSize( 1 )
		slice3:SetEndSize(  math.random( size * .1, size * .3 ) )
		slice3:SetEndAlpha( 0 )
		slice3:SetRoll( math.random( 0, 360 ) )
		slice3:SetRollDelta( math.random( -1, 1 ) )
	end

	emitter:Finish()
end
//end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end