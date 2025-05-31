local ESX = exports['es_extended']:getSharedObject()

lib.callback.register('checkgroup', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
   
    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            return true, xPlayer.getGroup()
        end
    end

    return false
end)

RegisterServerEvent('svg:announce:server', function(msg)
    local xPlayer = ESX.GetPlayerFromId(source)

    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            TriggerClientEvent('svg:announce:all', -1, msg)
        end
    end
end)

RegisterServerEvent('send:private:sv', function(target, reason, staff, notify)
    local xPlayer = ESX.GetPlayerFromId(source)

    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            if notify == false then
                TriggerClientEvent('txcl:showDirectMessage', target, reason, staff)
            else
                TriggerClientEvent('svg:admin:notify', target, reason, 'warning', staff)
            end
            NewWebhook(ConfigSV.PrivateMSGWebhook, 'Steam: **'..GetPlayerName(source)..'**\nID: **'..source..'**\nTarget: **'..GetPlayerName(target)..'**\nID Target: **'..target..'**\nPrivate Message: **'..reason..'**')
        end
    end
end)

RegisterServerEvent('svg:now:wipe', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(id)
    for _,v in pairs(Config.MaxGroups) do
        if xPlayer.getGroup() == v then
            if xTarget then
                MySQL.Async.fetchAll("SELECT identifier FROM users WHERE identifier = @target", {
                    ["@target"] = xTarget.identifier
                }, function (result)
                    if #result ~= 0 then
                        MySQL.Async.execute("DELETE FROM users WHERE identifier=@identifier", { ["@identifier"] = result[1].identifier })
                        MySQL.Async.execute("DELETE FROM addon_account_data WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                        MySQL.Async.execute("DELETE FROM datastore_data WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                        MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                        Wait(200)
                        DropPlayer(id, Lang.have_been_wipped)
                        
                    end
                end)
                TriggerClientEvent('svg:admin:notify', source, Lang.wipe_success..id, 'success')
                NewWebhook(ConfigSV.WipeWebhook, 'The Player **'..GetPlayerName(id)..'** has been wipped by **'..xPlayer.getGroup()..' - '..GetPlayerName(source)..'**')
            else
                TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
            end
        end
    end
end)

if Config.EnableWipeConsole then
    RegisterCommand('wipe', function(source, args, rawCommand)
        if source == 0 then
            if args ~= nil then
                if args[1] ~= nil then
                    MySQL.Async.fetchAll("SELECT identifier FROM users WHERE identifier = @id", {
                        ["@id"] = args[1]
                    }, function (result)
                        if #result ~= 0 then
                            MySQL.Async.execute("DELETE FROM users WHERE identifier=@identifier", { ["@identifier"] = result[1].identifier })
                            MySQL.Async.execute("DELETE FROM addon_account_data WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                            MySQL.Async.execute("DELETE FROM datastore_data WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                            MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner=@owner", { ["@owner"] = result[1].identifier })
                            print(Lang.wipe_success..result[1].identifier)
                        end
                    end)
                else
                    print('error 1')
                end
            else
                print('error 2')
            end
        end
    end)
end

local gotoCoords = {}
local bringCoords = {}

RegisterServerEvent('svg:menu:func:sv', function(type, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(id)

    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
                 
            if type == 'goto' then
                if xTarget then
                    gotoCoords[source] = xPlayer.getCoords()
                    xPlayer.setCoords(xTarget.getCoords())
                    TriggerClientEvent('svg:admin:notify', source, Lang.tp_to..GetPlayerName(id), 'success')
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
                end
            elseif type == 'gotoback' then
                if gotoCoords[source] then
                    xPlayer.setCoords(gotoCoords[source])
                    gotoCoords[source] = nil
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.have_to_tp, 'error')
                end

            elseif type == 'bring' then
                if xTarget then
                    bringCoords[id]= xTarget.getCoords()
                    xTarget.setCoords(xPlayer.getCoords())
                    TriggerClientEvent('svg:admin:notify', source,  Lang.tp_to_you..GetPlayerName(id)..Lang.to_you, 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.have_been_tp..GetPlayerName(source), 'info')
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
                end
            elseif type == 'bringback' then
                if xTarget then
                    if bringCoords[id] then
                        xTarget.setCoords(bringCoords[id])
                        bringCoords[id] = nil
                        TriggerClientEvent('svg:admin:notify', id, Lang.tp_back, 'info')
                    else
                        TriggerClientEvent('svg:admin:notify', source, Lang.no_now, 'error')
                    end
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
                end
            elseif type == 'freeze' then
                if xTarget then
                    TaskLeaveAnyVehicle(GetPlayerPed(id), 0, 16)
                    FreezeEntityPosition(GetPlayerPed(id), true)
                    TriggerClientEvent('svg:admin:notify', source, Lang.you_freeze..GetPlayerName(id), 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.have_been_freeze..GetPlayerName(source), 'info')
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
                end
            elseif type == 'unfreeze' then
                if xTarget then
                    FreezeEntityPosition(GetPlayerPed(id), false)
                    TriggerClientEvent('svg:admin:notify', source, Lang.you_unfreeze..GetPlayerName(id), 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.have_been_unfreeze..GetPlayerName(source), 'info')
                else
                    TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('svg:refund:sv', function(tipo, id, name, num)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(id)
    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            if xTarget then
                if tipo == 'ress' then
                    TriggerClientEvent(Config.RessTrigger, id)
                    TriggerClientEvent('svg:admin:notify', source, Lang.you_ress..GetPlayerName(id), 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.ress_by..GetPlayerName(source), 'info')
                    NewWebhook(ConfigSV.StaffWebhook, 'The '..xPlayer.getGroup()..' **'..GetPlayerName(source)..'** revived **'..GetPlayerName(id)..'**')
                elseif tipo == 'heal' then
                    local target = 'akdabdaidbaida'
                    TriggerClientEvent('heal:svg', id, target)
                    TriggerClientEvent('svg:admin:notify', source, Lang.you_heal..GetPlayerName(id), 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.heal_by..GetPlayerName(source), 'info')
                    if Config.UseBasicneeds then
                        TriggerClientEvent('esx_basicneeds:healPlayer', id ,"thirst", 100)  
                        TriggerClientEvent('esx_basicneeds:healPlayer', id ,"hunger", 100)  
                    end
                    NewWebhook(ConfigSV.StaffWebhook, 'The '..xPlayer.getGroup()..' **'..GetPlayerName(source)..'** healed **'..GetPlayerName(id)..'**')
                elseif tipo == 'armour' then
                    SetPedArmour(GetPlayerPed(id), 100)
                    TriggerClientEvent('svg:admin:notify', source, Lang.giveg..GetPlayerName(id), 'success')
                    TriggerClientEvent('svg:admin:notify', id, Lang.receiveg..GetPlayerName(source), 'info')
                    NewWebhook(ConfigSV.StaffWebhook, 'The '..xPlayer.getGroup()..' **'..GetPlayerName(source)..'** gave the armour to **'..GetPlayerName(id)..'**')
                elseif tipo == 'item' then
                    exports.ox_inventory:AddItem(id, name, num)
                    NewWebhook(ConfigSV.StaffWebhook, 'The '..xPlayer.getGroup()..' **'..GetPlayerName(source)..'** gave **x'..num..'** of **'..name..'** to **'..GetPlayerName(id)..'**')
                end
            else
                TriggerClientEvent('svg:admin:notify', source, Lang.not_in_game, 'error')
            end
        end
    end
end)

local reportTable = {}
local totalReports = 0

RegisterServerEvent('svg:report:new', function(info)
    totalReports = totalReports + 1
    local new = {
        feedId = totalReports,
        plyId = source,
        steam = GetPlayerName(source),
        type = info.type,
        desc = info.desc,
        closed = false,
    }

    reportTable[totalReports] = new
    TriggerClientEvent('update:feedback', -1, new)
    NewWebhook(ConfigSV.ReportWebhook, '**NEW REPORT #'..new.feedId..'**\n\nCategory:** '..new.type..'**\nInfo:** '..new.desc..'**\n\nOpened By:** '..new.steam..'**\nID: **'..new.plyId..'**', 3329330)
end)

RegisterServerEvent('svg:delete:report', function(args)
    reportTable[args.id] = {closed = true}
    TriggerClientEvent('svg:close:client', -1, args.id, reportTable[args.id])
    TriggerClientEvent('svg:admin:notify', source, Lang.report_closed, 'success')
    NewWebhook(ConfigSV.ReportWebhook, '**REPORT #'..args.id..'** closed by **'..GetPlayerName(source)..'**')
end)


RegisterServerEvent('svg:webhook', function(msg, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            local contenuto = {{
                author = {
                    name = ConfigSV.ServerName,
                    icon_url = "https://cdn.discordapp.com/attachments/732692435695829032/1140119732750655568/erale.png"
                },
                description = 'Steam: **'..GetPlayerName(source)..'**\nID: **'..source..'**\n'..msg,
                color = ConfigSV.WebhookColor,
                footer = {
                    text = "SVG AdminMenu | "..os.date("%x | %X %p"),
                }
            }}
            if type == 'announce' then
                PerformHttpRequest(ConfigSV.AnnounceWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = contenuto}), { ['Content-Type'] = 'application/json' })

            end
        end
    end
end)

NewWebhook = function(webhook, msg, color)
    local xPlayer = ESX.GetPlayerFromId(source)
    for _,v in pairs(Config.Groups) do
        if xPlayer.getGroup() == v then
            if not color then
                color = ConfigSV.WebhookColor
            end
            local contenuto = {{
                author = {
                    name = ConfigSV.ServerName,
                    icon_url = "https://cdn.discordapp.com/attachments/732692435695829032/1140119732750655568/erale.png"
                },
                description = msg,
                color = color,
                footer = {
                    text = "SVG AdminMenu | "..os.date("%x | %X %p"),
                }
            }}
            
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = contenuto}), { ['Content-Type'] = 'application/json' })

        end
    end
end