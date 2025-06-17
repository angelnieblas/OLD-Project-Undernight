package funkin.backend.system;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DevState extends MusicBeatState {
    public static var enabled:Bool = false; // <-- Variable global para modo dev

    var devText:FlxText;
    var infoText:FlxText;

    override public function create() {
        super.create();

        enabled = true; // Siempre activa el modo dev al entrar aquí

        // Fecha y hora actual
        var date = Date.now();
        var dateStr = '${date.getMonth()+1}/${date.getDate()}/${date.getFullYear()}';
        var hour = date.getHours();
        var min = date.getMinutes();
        var timeStr = (hour < 10 ? "0" : "") + hour + ":" + (min < 10 ? "0" : "") + min;

        // Texto de build dev abajo a la izquierda
        devText = new FlxText(10, FlxG.height - 30, 0, 'Dev build (HORARIO EJ.  GMT-6), $dateStr $timeStr', 16);
        devText.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.LIME, "left");
        add(devText);

        // Información adicional
        infoText = new FlxText(10, FlxG.height - 54, 0, '[Transición: Flash/Fade] [Librería: flixel] [${Std.int(FlxG.drawFramerate)}/${Std.int(FlxG.updateFramerate)}]', 14);
        infoText.setFormat("assets/fonts/vcr.ttf", 14, FlxColor.LIME, "left");
        add(infoText);

        // Mensaje central
        var centerText = new FlxText(0, FlxG.height / 2 - 40, FlxG.width, "¡Modo Dev Activado!\nPresiona ESC para volver al título.", 32);
        centerText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, "center");
        add(centerText);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Actualiza la info de FPS en tiempo real
        infoText.text = '[Transición: Flash/Fade] [Librería: flixel] [${Std.int(FlxG.drawFramerate)}/${Std.int(FlxG.updateFramerate)}]';

        // Salir con ESC
        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new funkin.menus.TitleState());
        }
    }
}