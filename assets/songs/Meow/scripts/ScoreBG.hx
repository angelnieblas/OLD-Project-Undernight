import flixel.FlxG;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import openfl.geom.Rectangle;

var blackScreen:FlxSprite;
var TomeScreen:FlxSprite;
var timeTxt:FlxText;

function create() {
    blackScreen = new FlxSprite().makeSolid(FlxG.width - 630, FlxG.height - 750, FlxColor.BLACK);
    blackScreen.alpha = 0.6;
    blackScreen.y = 675;
    blackScreen.x += 310;
    blackScreen.cameras = [camHUD];
    insert(0, blackScreen);

    timeTxt = new FlxText(-10, 10.5, 400, "X:XX", 30);
    timeTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    timeTxt.scrollFactor.set();
    timeTxt.alpha = 1;
    timeTxt.borderColor = 0xFF000000;
    timeTxt.borderSize = 2;
    timeTxt.screenCenter(FlxAxes.X);

    TomeScreen = new FlxSprite().makeSolid(FlxG.width - 830, FlxG.height - 750, FlxColor.BLACK);
    TomeScreen.alpha = 0.6;
    TomeScreen.y = 10;
    TomeScreen.x += 410;
    TomeScreen.cameras = [camHUD];
    insert(0, TomeScreen);

    add(timeTxt);
    timeTxt.cameras = [camHUD];
}

function postCreate()
    {
        add(blackScreen);
        add(TomeScreen);
    }

function update(elapsed:Float) {
var pos = Math.max(Conductor.songPosition, 0);
var timeNow = Math.floor(pos / 60000) + ":" + CoolUtil.addZeros(Std.string(Math.floor(pos / 1000) % 60), 2);
var length = Math.floor(inst.length / 60000) + ":" + CoolUtil.addZeros(Std.string(Math.floor(inst.length / 1000) % 60), 2);  

timeTxt.text = timeNow + " - " + length;
}