if (SERVER) then
    hook.Add( "TTT2PlayerReady", "SourceTVFix", function( ply )
        -- Todo pull name from cvar
        if ply:Nick() == "SourceTV" then
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
    end )
end