class HealthUI extends FlxSprite {
    var jud:Array<String> = ['jud', 'playertv', 'enemytv', 'vida'];
    
    public function new() {
        super();
        createSprites();
        adjustPositions();
    }

    function createSprites() {
        for (i in 0...jud.length) {
            var sprite = new FlxSprite(0, 8).loadGraphic(AssetPaths.getGraphic(jud[i]));
            sprite.scale.set(0.55, 0.55);
            sprite.cameras = [FlxG.cameras.list[1]]; 
            add(sprite);
        }

        var vida2 = new FlxSprite(0, 8).loadGraphic(AssetPaths.getGraphic('vida'));
        vida2.scale.set(0.55, 0.55);
        vida2.cameras = [FlxG.cameras.list[1]];
        vida2.flipX = true;
        add(vida2);
    }

    function adjustPositions() {
        jud[2].y = 38.7;
        jud[3].y = 38.7;
        
        jud[1].x = 354;
        jud[0].x = 800.5;

        FlxG.width/2; // Centrar elementos
        FlxG.height/2;

        if (!FlxG.save.data.downscroll) {
            jud[3].y = 645;
            jud[0].y = 519;
            jud[1].y = 550;
            jud[2].y = 550;
        }
    }
}

function rgb_hex(r:Int, g:Int, b:Int, porcentaje:Float = 1):String {
    r = Math.max(0, Math.min(255, Std.int(r * porcentaje)));
    g = Math.max(0, Math.min(255, Std.int(g * porcentaje)));
    b = Math.max(0, Math.min(255, Std.int(b * porcentaje)));
    return StringTools.hex(r, 2) + StringTools.hex(g, 2) + StringTools.hex(b, 2);
}
