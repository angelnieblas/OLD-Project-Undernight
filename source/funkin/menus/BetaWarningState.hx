package funkin.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.FunkinText;

class BetaWarningState extends MusicBeatState {
    var bgSprite:FlxSprite;
    var starMenu:FlxSprite;
    var titleText:FlxText;
    var welcomeText:FlxText;
    var optionsHeader:FlxText;
    var continueText:FlxText;
    var listoText:FlxText;

    var selectedOption:Int = 0;
    var transitioning:Bool = false;

    var menuOptions:Array<{ 
        name:String, 
        values:Array<String>, 
        currentIndex:Int, 
        text:FlxText, 
        isListo:Bool 
    }> = [];

    override public function create() {
        super.create();

        // Fondo simple (puedes cambiar por un degradado si tienes imagen)
        bgSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(20, 10, 30));
        add(bgSprite);

        // Ilustración a la derecha
        starMenu = new FlxSprite();
        starMenu.loadGraphic("assets/images/menus/instructionsmenu/star_menu.png");
        starMenu.x = FlxG.width - starMenu.width - 40;
        starMenu.y = (FlxG.height - starMenu.height) / 2;
        add(starMenu);

        // Título grande y centrado arriba
        titleText = new FlxText(0, 40, FlxG.width, "HEY", 64);
        titleText.setFormat("assets/fonts/vcr.ttf", 64, FlxColor.WHITE, "center");
        add(titleText);

        // Texto de bienvenida alineado a la izquierda
        var leftX = 60;
        var textWidth = FlxG.width / 2 + 60;
        welcomeText = new FlxText(leftX, 120, textWidth, 
            "HOLAAAA bienvenido al mod <3\nBien, como te darás cuenta aparecen opciones a escoger,\nsigue las instrucciones dadas por Star para continuar.", 28);
        welcomeText.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.WHITE, "left");
        add(welcomeText);

        // Encabezado de opciones
        optionsHeader = new FlxText(leftX, welcomeText.y + welcomeText.height + 32, textWidth, "Opciones:", 28);
        optionsHeader.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.WHITE, "left");
        add(optionsHeader);

        // Opciones del menú
        menuOptions = [];
        var optYBase:Float = optionsHeader.y + optionsHeader.height + 10;
        var spacing:Int = 36;

        menuOptions.push({
            name: "Controles: ",
            values: ["ASWD"],
            currentIndex: 0,
            text: new FlxText(leftX, optYBase, textWidth, "", 28),
            isListo: false
        });
        menuOptions.push({
            name: "FPS: ",
            values: ["30", "60", "120"],
            currentIndex: 2,
            text: new FlxText(leftX, optYBase + spacing, textWidth, "", 28),
            isListo: false
        });
        menuOptions.push({
            name: "Modo Pantalla: ",
            values: ["Ventana", "Pantalla Completa"],
            currentIndex: 0,
            text: new FlxText(leftX, optYBase + 2 * spacing, textWidth, "", 28),
            isListo: false
        });
        // Opción "Listo"
        menuOptions.push({
            name: "Listo",
            values: [""],
            currentIndex: 0,
            text: new FlxText(leftX, optYBase + 3 * spacing + 10, textWidth, "", 28),
            isListo: true
        });

        for (opt in menuOptions) {
            opt.text.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.WHITE, "left");
            add(opt.text);
        }
        updateOptionsDisplay();

        // Texto para continuar (opcional)
        continueText = new FlxText(leftX, menuOptions[menuOptions.length - 1].text.y + 36, textWidth, "Presiona ENTER para continuar", 18);
        continueText.setFormat("assets/fonts/vcr.ttf", 18, FlxColor.GRAY, "left");
        add(continueText);
    }

    function updateOptionsDisplay():Void {
        for (i in 0...menuOptions.length) {
            var option = menuOptions[i];
            if (option.isListo) {
                option.text.text = (i == selectedOption ? "> " : "  ") + option.name;
                option.text.color = (i == selectedOption) ? FlxColor.YELLOW : FlxColor.WHITE;
            } else {
                var prefix = (i == selectedOption) ? "> " : "  ";
                option.text.text = prefix + option.name + option.values[option.currentIndex];
                option.text.color = (i == selectedOption) ? FlxColor.YELLOW : FlxColor.WHITE;
            }
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (transitioning) return;

        // Navegación arriba/abajo
        if (FlxG.keys.justPressed.UP) {
            selectedOption = (selectedOption - 1 + menuOptions.length) % menuOptions.length;
            updateOptionsDisplay();
        }
        if (FlxG.keys.justPressed.DOWN) {
            selectedOption = (selectedOption + 1) % menuOptions.length;
            updateOptionsDisplay();
        }

        // Cambiar valor con izquierda/derecha (solo si no es "Listo" y tiene más de un valor)
        var opt = menuOptions[selectedOption];
        if (!opt.isListo && opt.values.length > 1) {
            if (FlxG.keys.justPressed.LEFT) {
                opt.currentIndex = (opt.currentIndex - 1 + opt.values.length) % opt.values.length;
                updateOptionsDisplay();
            }
            if (FlxG.keys.justPressed.RIGHT) {
                opt.currentIndex = (opt.currentIndex + 1) % opt.values.length;
                updateOptionsDisplay();
            }
        }

        // ENTER solo si está en "Listo"
        if (FlxG.keys.justPressed.ENTER && opt.isListo) {
            transitioning = true;
            // Transición de alejamiento (zoom out)
            FlxTween.tween(FlxG.camera, { zoom: 0.5 }, 1.3, { ease: FlxEase.cubeInOut, onComplete: function(_) goToTitle() });
            FlxTween.tween(FlxG.camera, { alpha: 0 }, 1.3, { ease: FlxEase.cubeInOut });
        }
    }

    private function goToTitle():Void {
        MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
        FlxG.camera.zoom = 1;
        FlxG.camera.alpha = 1;
        FlxG.switchState(new TitleState());
    }
}