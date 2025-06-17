import funkin.backend.utils.DiscordUtil;

function onGameOver() {
    DiscordUtil.changePresence('Uhh', null);
}

function onDiscordPresenceUpdate(e) {
    var data = e.presence;

    if(data.button1Label == null)
        data.button1Label = "Project Undernight Download";
    if(data.button1Url == null)
        data.button1Url = "https://gamebanana.com/wips/91762";
}

function onPlayStateUpdate() {
    DiscordUtil.changeSongPresence(
        "Nope.",
        null,
        PlayState.instance.inst,
        PlayState.instance.getIconRPC()
    );
}

function onMenuLoaded(name:String) {
    // Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
    DiscordUtil.changePresenceSince("Uhh...", null);
}

function onEditorTreeLoaded(name:String) {
    switch(name) {
        case "Character Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
        case "Chart Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
        case "Stage Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
    }
}

function onEditorLoaded(name:String, editingThing:String) {
    switch(name) {
        case "Character Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
        case "Chart Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
        case "Stage Editor":
            DiscordUtil.changePresenceSince("Uhh...", null);
    }
}