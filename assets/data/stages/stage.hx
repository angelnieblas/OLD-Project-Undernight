package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class Stage extends FlxState {
    var background:FlxSprite;

    override public function create() {
        super.create();
        
        background = new FlxSprite(-550, -150).loadGraphic("assets/images/stages/default/DHT.png");
        background.scrollFactor.set(0.8, 0.8);
        add(background);
    }
}
