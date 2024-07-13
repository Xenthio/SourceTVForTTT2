if (SERVER) then
    function TryFixup(ply)
        print("[Source TV TTT] [Debug] - Attempting to fix " .. ply:Nick() .. ". (checking for " .. GetConVar("tv_name"):GetString() .. ")")  
        if ply:Nick() == GetConVar("tv_name"):GetString() then
            print("[Source TV TTT] - Forcing SourceTV into spectator")  
            --if not ply:IsSpec() then
            --    ply:Kill()
            --end

            GAMEMODE:PlayerSpawnAsSpectator(ply)

            ply:SetTeam(TEAM_SPEC)
            ply:SetForceSpec(true)
            ply:Spawn()

            ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here
        end
    end
    hook.Add( "TTTBeginRound", "SourceTVFix", function( ply )
        for k,v in pairs(player.GetAll()) do
            TryFixup(v)
        end
    end )
    --for k,v in pairs(player.GetAll()) do
    --    TryFixup(v)
    --end
    print("[Source TV TTT] - Source TV fixes is active and initialised!")
end