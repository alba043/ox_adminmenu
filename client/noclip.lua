local speed = 0.1
local up_down_speed = 0.1

-- Functie voor het weergeven van instructies op het scherm tijdens NoClip
function InfoNoClip()
	Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
    while not HasScaleformMovieLoaded(Scale) do
        Wait(0)
	end

    -- Maak alle vorige instructies leeg
    BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
    EndScaleformMovieMethod();

    -- Toon huidige snelheid
    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(0);
    PushScaleformMovieMethodParameterString("~INPUT_SPRINT~");
    PushScaleformMovieMethodParameterString("Huidige snelheid: "..speed);
    EndScaleformMovieMethod();

    -- Toon links/rechts beweging instructie
    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(1);
    PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~");
    PushScaleformMovieMethodParameterString("Rechts/Links");
    EndScaleformMovieMethod();

    -- Toon vooruit/achteruit beweging instructie
    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(2);
    PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~");
    PushScaleformMovieMethodParameterString("Achteruit/Vooruit");
    EndScaleformMovieMethod();

    -- Toon omlaag beweging instructie
    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(3);
    PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_DOWN~");
    PushScaleformMovieMethodParameterString("Omlaag gaan");
    EndScaleformMovieMethod();

    -- Toon omhoog beweging instructie
    BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(4);
    PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_UP~");
    PushScaleformMovieMethodParameterString("Omhoog gaan");
    EndScaleformMovieMethod();

    -- Teken alle instructies op het scherm
    BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS");
    ScaleformMovieMethodAddParamInt(0);
    EndScaleformMovieMethod();

    DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0);
end


-- Hoofdfunctie voor NoClip modus
NoClip = function()

    inNoclip = true
    
    CreateThread(function()
        while true do
            Wait(1)
            local ped = cache.ped
            local targetVeh = GetVehiclePedIsUsing(ped)
            -- Als speler in een voertuig zit, pas NoClip toe op het voertuig
            if cache.vehicle and DoesEntityExist(cache.vehicle) then
                ped = targetVeh
            end

            if inNoclip then
                -- Toon instructies op het scherm
                InfoNoClip()

                -- Maak speler/voertuig onkwetsbaar en onzichtbaar
                SetEntityInvincible(ped, true)
                SetEntityVisible(ped, false, false)

                -- Zorg ervoor dat de speler lokaal zichtbaar blijft
                SetEntityLocallyVisible(ped)
                SetEntityAlpha(ped, 100, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                ForcePedMotionState(ped, -1871534317, 0, 0, 0)

                SetLocalPlayerVisibleLocally(ped)
                -- Schakel botsingen uit
                SetEntityCollision(ped, false, false)
                
                -- Zet de positie van de speler/voertuig
                SetEntityCoordsNoOffset(ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, true, true, true)

                -- Snelheidscontrole met Shift-toets
                if IsControlJustPressed(1, 21) then
                    if speed == 0.1 then
                        speed = 0.2
                        up_down_speed = 0.2
                    elseif speed == 0.2 then
                        speed = 0.3
                        up_down_speed = 0.3
                    elseif speed == 0.3 then
                        speed = 0.5
                        up_down_speed = 0.5
                    elseif speed == 0.5 then
                        speed = 1.5
                        up_down_speed = 0.5
                    elseif speed == 1.5 then
                        speed = 2.5
                        up_down_speed = 0.9
                    elseif speed == 2.5 then
                        speed = 3.5
                        up_down_speed = 1.3
                    elseif speed == 3.5 then
                        speed = 4.5
                        up_down_speed = 1.5
                    elseif speed == 4.5 then
                        speed = 0.1
                        up_down_speed = 0.1
                    end
                end

                -- Vooruit beweging (W-toets)
                if IsControlPressed(1, 32) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, 0.0)
                end
                
                -- Achteruit beweging (S-toets)
                if IsControlPressed(1, 8) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, -speed, 0.0)
                end
                
                -- Links beweging (A-toets)
                if IsControlPressed(1, 34) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, -speed, 0.0, 0.0)
                end
                
                -- Rechts beweging (D-toets)
                if IsControlPressed(1, 9) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, speed, 0.0, 0.0)
                end

                -- Omhoog beweging (Pijl omhoog)
                if IsControlPressed(1, 172) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, up_down_speed)
                end
                
                -- Omlaag beweging (Pijl omlaag)
                if IsControlPressed(1, 173) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -up_down_speed)
                end

                -- Pas de richting aan op basis van de camera
                local heading = GetGameplayCamRelativeHeading()
                SetEntityHeading(ped, -heading)
            else
                -- Herstel normale speler/voertuig eigenschappen bij het verlaten van NoClip
                SetEntityInvincible(ped, false)
                ResetEntityAlpha(ped)
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, false)
                SetBlockingOfNonTemporaryEvents(ped, false)

                return
            end
        end
    end)
end

-- Initialiseer noclip_pos variabele om nil fouten te voorkomen
noclip_pos = vector3(0.0, 0.0, 0.0)

-- Registreer toetsenbinding voor NoClip, aangepast van HOME naar F9
RegisterKeyMapping(Config.NoClipCommand,"SVG noclip","keyboard","F9")

-- Registreer commando voor NoClip
RegisterCommand(Config.NoClipCommand, function()
    lib.callback('checkgroup', false, function(staff, tipo)
        if staff then
            if not inNoclip then
                -- Sla huidige positie op en activeer NoClip
                noclip_pos = GetEntityCoords(cache.ped, false)
                NoClip()
            else
                -- Deactiveer NoClip
                inNoclip = false
            end
        end
    end)
end)
