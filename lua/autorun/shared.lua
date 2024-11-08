if (SERVER) then
    function TryFixup(ply)
        --print("[Source TV TTT] [Debug] - Attempting to fix " .. ply:Nick() .. ". (checking for " .. GetConVar("tv_name"):GetString() .. ")")  
        if ply:Nick() == GetConVar("tv_name"):GetString() then
            print("[Source TV TTT] - Forcing SourceTV into spectator")  
            --if not ply:IsSpec() then
            --    ply:Kill()
            --end
    
            GAMEMODE:PlayerSpawnAsSpectator(ply)
    
            ply:SetTeam(TEAM_SPEC)
            ply:SetForceSpec(true)
            ply:Spawn()
            ply.isReady = false
            ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here 
        end
    end 
    
    hook.Add( "TTTPrepareRound", "SourceTVFix", function()
        for k,v in pairs(player.GetAll()) do
            TryFixup(v)
        end
    end )
    hook.Add( "PlayerConnect", "SourceTVFixPlayerJoin", function()
        name = os.date( "%H-%M-%d-%m-%Y" , Timestamp ) .. "--" .. game.GetMap()
        RunConsoleCommand("tv_record", name)
        print("[Source TV TTT] - Started recording to " .. name)  
    end )
    --RunConsoleCommand("tv_record", os.date( "%H-%M-%d-%m-%Y" , Timestamp )
    hook.Add( "PlayerDisconnected", "SourceTVFixPlayerLeft", function()
        if table.Count(player.GetAll()) == 0 then
            RunConsoleCommand("tv_stoprecord")
            print("[Source TV TTT] - Stopped recording")  
        end
    end )
    --for k,v in pairs(player.GetAll()) do
    --    TryFixup(v)
    --end
    print("[Source TV TTT] - Source TV fixes is active and initialised!")
end
if (CLIENT) then
     
    hook.Add( "TTTScoreGroup", "SourceTVHidePlayer", function( ply )
        if ply:Nick() == GetConVar("tv_name"):GetString() then
            return 99
        end
    end )
end