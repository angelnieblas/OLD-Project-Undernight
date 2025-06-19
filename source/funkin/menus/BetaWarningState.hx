package funkin.menus;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import funkin.backend.FunkinText;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.system.DevState;

// Alternativa a FlxInputText: caja de texto simulada con FlxText
class BetaWarningState extends MusicBeatState {
    var titleText:FlxText;
    var disclaimer:FunkinText;
    var devPrompt:FlxText;
    var devInputBox:FlxText;
    var devInputBuffer:String = "";
    var devModePromptActive:Bool = false;
    var transitioning:Bool = false;
    final secretCode:String = "Makku"; // Exacto, con mayúscula
    final maxBuffer:Int = 32;

    override public function create() {
        super.create();

        titleText = new FlxText(0, 60, FlxG.width, "WARNING", 64);
        titleText.setFormat("assets/fonts/vcr.ttf", 64, FlxColor.WHITE, "center");
        add(titleText);

        disclaimer = new FunkinText(16, titleText.y + titleText.height + 10, FlxG.width - 32, "", 32);
        disclaimer.alignment = CENTER;
        disclaimer.applyMarkup(
            'This engine is still in a *${Main.releaseCycle}* state. That means *majority of the features* are either *buggy* or *non finished*. If you find any bugs, please report them to the Codename Engine GitHub.\n\nPresiona ENTER para continuar.',
            [
                new FlxTextFormatMarkerPair(new flixel.text.FlxTextFormat(0xFFFF4444), "*")
            ]
        );
        add(disclaimer);

        var off = Std.int((FlxG.height - (disclaimer.y + disclaimer.height)) / 2);
        disclaimer.y += off;
        titleText.y += off;

        // Prompt y caja de texto simulada (inicialmente ocultos)
        devPrompt = new FlxText(0, disclaimer.y + disclaimer.height + 40, FlxG.width, "Introduce el código de desarrollador:", 28);
        devPrompt.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.YELLOW, "center");
        devPrompt.visible = false;
        add(devPrompt);

        devInputBox = new FlxText(0, devPrompt.y + 40, FlxG.width, "", 28);
        devInputBox.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.LIME, "center");
        devInputBox.borderStyle = OUTLINE;
        devInputBox.borderColor = FlxColor.GRAY;
        devInputBox.visible = false;
        add(devInputBox);

        DiscordUtil.call("onMenuLoaded", ["Beta Warning"]);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Mostrar prompt/caja al presionar TAB
        if (FlxG.keys.justPressed.TAB && !devModePromptActive && !transitioning) {
            devModePromptActive = true;
            devPrompt.visible = true;
            devInputBox.visible = true;
            devInputBuffer = "";
            devInputBox.text = "";
        }

        // Si está activo el prompt de clave
        if (devModePromptActive && !transitioning) {
            // Letras y mayúsculas exactas
            for (i in 0...26) {
                var upper = String.fromCharCode("A".code + i);
                var lower = String.fromCharCode("a".code + i);
                if (Reflect.field(FlxG.keys.justPressed, upper) && devInputBuffer.length < maxBuffer)
                    devInputBuffer += upper;
                if (Reflect.field(FlxG.keys.justPressed, lower) && devInputBuffer.length < maxBuffer)
                    devInputBuffer += lower;
            }
            // Números
            for (i in 0...10) {
                var num = Std.string(i);
                if (Reflect.field(FlxG.keys.justPressed, num) && devInputBuffer.length < maxBuffer)
                    devInputBuffer += num;
            }
            // Espacio
            if (FlxG.keys.justPressed.SPACE && devInputBuffer.length < maxBuffer)
                devInputBuffer += " ";
            // Borrar
            if (FlxG.keys.justPressed.BACKSPACE && devInputBuffer.length > 0)
                devInputBuffer = devInputBuffer.substr(0, devInputBuffer.length - 1);

            devInputBox.text = devInputBuffer + ((FlxG.game.ticks % 60 < 30) ? "|" : ""); // Simula cursor

            // Confirmar clave (debe ser exacta)
            if (FlxG.keys.justPressed.ENTER) {
                if (devInputBuffer == secretCode) {
                    DevState.enabled = true;
                    devInputBuffer = "";
                    transitioning = true;
                    CoolUtil.playMenuSFX(CONFIRM);
                    FlxG.camera.flash(FlxColor.WHITE, 1, function() {
                        FlxG.camera.fade(FlxColor.BLACK, 2.5, false, goToDev);
                    });
                } else {
                    devInputBuffer = "";
                    devInputBox.text = "";
                    devPrompt.text = "Código incorrecto. Intenta de nuevo:";
                }
            }
            // Cancelar
            if (FlxG.keys.justPressed.ESCAPE) {
                devModePromptActive = false;
                devPrompt.visible = false;
                devInputBox.visible = false;
                devPrompt.text = "Introduce el código de desarrollador:";
            }
            return;
        }

        // Si no está activo el prompt, ENTER avanza normalmente
        if (FlxG.keys.justPressed.ENTER && !transitioning) {
            transitioning = true;
            CoolUtil.playMenuSFX(CONFIRM);
            FlxG.camera.flash(FlxColor.WHITE, 1, function() {
                FlxG.camera.fade(FlxColor.BLACK, 2.5, false, goToTitle);
            });
        }
    }

    private function goToTitle() {
        MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
        FlxG.switchState(new TitleState());
    }

    private function goToDev() {
        MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
        FlxG.switchState(new DevState());
    }
}