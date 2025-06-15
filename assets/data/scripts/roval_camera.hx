class RovalCamera {
    public var int:Int = 30; // Intensidad del movimiento de cámara
    public var velcaminicio:Float = 1; // Velocidad inicial de cámara
    public var PosicionCamaraInicial:String = "normal"; // normal/bf/gf/dad/medio

    public var automaticCamera:Bool = true; // Si la cámara usa posiciones relativas o manuales
    public var dadOffset:Array<Int> = [0, 0];
    public var gfOffset:Array<Int> = [0, 0];
    public var bfOffset:Array<Int> = [0, 0];
    public var middleOffsets:Array<Int> = [0, 0];

    public function new() {}

    public function createCamera(target:String) {
        switch(target) {
            case "dad":
                return [FlxG.game.getMidpointX('dad') + dadOffset[0], FlxG.game.getMidpointY('dad') - dadOffset[1]];
            case "gf":
                return [FlxG.game.getMidpointX('gf') + gfOffset[0], FlxG.game.getMidpointY('gf') - gfOffset[1]];
            case "bf":
                return [FlxG.game.getMidpointX('boyfriend') + bfOffset[0], FlxG.game.getMidpointY('boyfriend') - bfOffset[1]];
            case "middle":
                return [(dadOffset[0] + bfOffset[0]) / 2 + middleOffsets[0], (dadOffset[1] + bfOffset[1]) / 2 - middleOffsets[1]];
            default:
                return [FlxG.width / 2, FlxG.height / 2];
        }
    }

    public function updateCamera(anim:String) {
        var pos:Array<Float> = createCamera(PosicionCamaraInicial);
        switch(anim) {
            case "singLEFT":
                FlxG.camera.follow(new FlxObject(pos[0] - int, pos[1], 1, 1), FlxCameraFollowStyle.LOCKON);
            case "singRIGHT":
                FlxG.camera.follow(new FlxObject(pos[0] + int, pos[1], 1, 1), FlxCameraFollowStyle.LOCKON);
            case "singUP":
                FlxG.camera.follow(new FlxObject(pos[0], pos[1] - int, 1, 1), FlxCameraFollowStyle.LOCKON);
            case "singDOWN":
                FlxG.camera.follow(new FlxObject(pos[0], pos[1] + int, 1, 1), FlxCameraFollowStyle.LOCKON);
            default:
                FlxG.camera.follow(new FlxObject(pos[0], pos[1], 1, 1), FlxCameraFollowStyle.LOCKON);
        }
    }
}
