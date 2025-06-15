import funkin.backend.utils.WindowUtils;

var windowName = 'Project Undernight: Discord Has Talent';

WindowUtils.winTitle = windowName;

function postStateSwitch(){
    if(Std.isOfType(FlxG.state, PlayState)) window.title += ' - ' + PlayState.SONG.meta.displayName;
}

function destroy(){
    WindowUtils.winTitle = "Friday Night Funkin' - Codename Engine";
}