local lasteyepos = render.GetViewSetup(true).origin
local lasteyeangles = render.GetViewSetup(true).angles

local localPlayer = LocalPlayer()	

local initialised = false

hook.Add( "PreDrawTranslucentRenderables", "GetVoiceEyePos", function()
	lasteyepos = render.GetViewSetup(true).origin
	lasteyeangles = render.GetViewSetup(true).angles
end )

local function IsSourceTV(ply)

	if ply:IsPlayer() and ply:GetName() == "SourceTV" then 
		return true
	end
	return false
end

local meta = FindMetaTable( "Entity" )

meta.oldEyePos = meta.oldEyePos or meta.EyePos
function meta:EyePos()
	if IsSourceTV(self) then
		return lasteyepos
	end
	return self:oldEyePos()
end

meta.oldEyeAngles = meta.oldEyeAngles or meta.EyeAngles
function meta:EyeAngles()
	if IsSourceTV(self) then
		return lasteyeangles
	end
	return self:oldEyeAngles()
end

meta.oldGetPos = meta.oldGetPos or meta.GetPos
function meta:GetPos()
	if IsSourceTV(self) then
		return lasteyepos
	end
	return self:oldGetPos()
end

meta.oldGetAngles = meta.oldGetAngles or meta.GetAngles
function meta:GetAngles()
	if IsSourceTV(self) then
		return lasteyeangles
	end
	return self:oldGetAngles()
end


local plymeta = FindMetaTable( "Player" )

plymeta.oldIsSpec = plymeta.oldIsSpec or plymeta.IsSpec
function plymeta:IsSpec()
	if self:GetName() == "SourceTV" then
		return true
	end
	return self:oldIsSpec()
end

local hud

local function DoInitialise()
	initialised = true

	localPlayer = LocalPlayer()	
	--GAMEMODE:PlayerSpawnAsSpectator(ply) 
	localPlayer:Spawn()
	localPlayer.isReady = false



	hud = huds.GetStored(GetConVar("ttt2_current_hud"):GetString())

	-- Octogonal hud brokey things so fix them >:( 
	if not (hud and hud.Draw) then 
		-- load all HUDs
		huds.OnLoaded()

		-- load all HUD elements
		hudelements.OnLoaded()

		HUDManager.LoadAllHUDS()
		HUDManager.SetHUD()

		hud = huds.GetStored(GetConVar("ttt2_current_hud"):GetString())

		hud:Initialize()
	end

	RunConsoleCommand("sv_specspeed", "0.3")
end
hook.Add("Think", "ThinkSourceTVTTT", function()
	if not initialised then
		DoInitialise()
	end
end)

hook.Add("HUDPaint", "HUDPaintSourceTVTTT", function(ply, bindName, pressed)
	if hud and hud.Draw then hud:Draw() end
end)

function SpectateLookingAt()
	local tr = util.TraceLine( {
		start = localPlayer:EyePos(),
		endpos = localPlayer:EyePos() + localPlayer:GetAimVector() * 25000,
		filter = localPlayer
	} )
	if tr.Entity:IsPlayer() then
		localPlayer:SetSaveValue( "m_hObserverTarget", tr.Entity )
		print(localPlayer:GetObserverTarget())
		--localPlayer:SpectateEntity( tr.Entity )
	end
end

hook.Add("PlayerBindPress", "KeyPressSourceTVTTT", function(ply, bindName, pressed)
	if bindName == "+jump" and pressed then
		mode = localPlayer:GetObserverMode()
			if mode == 6 then mode = 4
		elseif mode == 4 then mode = 5
		elseif mode == 5 then mode = 6 end
		print("changing observer mode to ", mode) 
		localPlayer:SetObserverMode( mode ) 
		return true
	elseif bindName == "+use" and pressed then
		-- trace forward get entity
		SpectateLookingAt()
		return true
	end
end) 

