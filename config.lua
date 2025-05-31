Config = {}

Config.MenuCommand = 'sm'
Config.TxAdmin = true

Config.Groups = {
    'owner',
    'hogeraad',
    'management',
    'administrator',
    'moderator'
}
Config.MaxGroups = {
    'hogeraad',
    'owner',   
}

Config.RessTrigger = 'qrp-ambulance:client:revive:player'
Config.UseBasicneeds = false

Config.NoClipCommand = 'noclip'
Config.ReportCommand = 'call'

Config.EnableReportStaffCommand = false
Config.ReportStaff = 'calls'

Config.ReportCooldown = 5

Config.EnableWipeConsole = true --se true i giocatori possono essere wippati dalla console tramite identifier / if true players can be wipped from the console by identifier

Config.Notify = function(msg, type, title)
    if not title then --check for title
        lib.notify({
            title = 'Quality Roleplay',
            description = msg,
            type = type,
            position = 'top-center',
            duration = 5000,
        })
    else
        lib.notify({
            title = title,
            description = msg,
            type = type,
            position = 'top-center',
            duration = 5000,
        })
    end
end

Lang = {
    menu_admin = 'Staff Menu - Quality',

    menu_staff = 'Staff Menu',
    menu_staff_desc = 'Dit menu bevat interacties voor het staff team',
    go_to = 'Ga Naar Speler',
    go_back = 'Ga Terug',
    bring = 'Breng Speler',
    bring_back = 'Speler terugbrengen',
    freeze = 'Freeze Player',
    unfreeze = 'Unfreeze Player',
    viewId = 'View ID',
    tp_to = 'Je bent geteleporteerd naar ',
    have_to_tp = 'Je moet eerst tp van een speler!',
    tp_to_you = 'Je teleporteerde ',
    to_you = ' naar jou',
    have_been_tp = 'Je bent geteleporteerd door het staff team',
    tp_back = 'Je bent terug geteleporteerd',
    no_now = 'Je Kun\'t Het Nu Gebruiken het nu!',
    you_freeze = 'Je Bent gefreezed ',
    have_been_freeze = 'Je bent gefreezed, door ',
    you_unfreeze = 'Je hebt geunfreezed ',
    have_been_unfreeze = 'Je bent geunfreezed door ',

    menu_refund = 'Refund Menu',
    menu_refund_desc = 'Dit Menu Is Om Refunds Uit Te Schrijfen',
    giveItem = 'Geef Item',
    item = 'Item',
    amount = 'Amount',
    you_ress = 'Je Ontving ',
    ress_by = 'Je Bent Gerevived Door ',
    you_heal = 'Je Bent Gehealed ',
    heal_by = 'Je bent Gehealed door ',
    giveg = 'Je gaf de armor aan ',
    receiveg = 'Je hebt de armor ontvangen van ',

    send_announce = 'Aankondiging verzenden',
    send_announce_desc = 'Stuur een aankondiging voor alle spelers',
    announce = '~y~Announcement',
    write_announce = 'Schrijf de advertentie',

    send_private_msg = 'Recall Player',
    send_private_msg_desc = 'Stuur een privebericht naar een speler',
    msg_from = 'Bericht Van ',

    wipe_player = 'Wipe Player',
    wipe_player_desc = 'Verwijder alle spelersgegevens van de server',
    wipe_player_check = 'Weet je zeker dat je de speler met ID wilt gewipped: ',
    wipe_success = 'Je hebt je ID gewipped: ',
    have_been_wipped = 'Je bent gewipped!',

    no_staff = 'Je bent geen staff',
    not_valid_msg = 'Enter a valid message',

    id_player = 'ID-speler',
    reason = 'Reden',
    not_in_game = 'Speler niet in de stad',
}