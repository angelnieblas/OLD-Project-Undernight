package funkin.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.backend.FunkinText;

class BetaWarningState extends MusicBeatState {

    // Fondo e ilustración (star_menu)
    var bgSprite:FlxSprite;
    var starMenu:FlxSprite;
    
    // Título
    var titleAlphabet:Alphabet;
    
    // Textos del panel de instrucciones
    var welcomeText:FunkinText;
    var optionsHeader:FunkinText;
    var continueText:FunkinText;
    
    // Menú de opciones interactivo
    var selectedOption:Int = 0;
    // Cada opción: nombre, array de valores, índice actual y el objeto FlxText que la muestra
    var menuOptions:Array<{ name:String, values:Array<String>, currentIndex:Int, text:FlxText }> = [];
    
    var transitioning:Bool = false;

    public override function create() {
        super.create();
        
        // Cargamos el fondo desde la carpeta de instrucciones
        bgSprite = new FlxSprite(0, 0);
        bgSprite.loadGraphic("assets/images/menus/instructionsmenu/bg");
        // Escalamos para cubrir toda la pantalla
        bgSprite.scale.set(FlxG.width / bgSprite.width, FlxG.height / bgSprite.height);
        add(bgSprite);
        
        // Cargamos la ilustración "star_menu" y la posicionamos a la derecha, centrada verticalmente
        starMenu = new FlxSprite();
        starMenu.loadGraphic("assets/images/menus/instructionsmenu/star_menu");
        starMenu.x = FlxG.width - starMenu.width - 20;
        starMenu.y = (FlxG.height - starMenu.height) / 2;
        add(starMenu);
        
        // Título "WARNING" centrado horizontalmente
        titleAlphabet = new Alphabet(0, 0, "WARNING", true);
        titleAlphabet.screenCenter(X);
        add(titleAlphabet);
        
        // Área de instrucciones: se usará la mitad izquierda de la pantalla
        var instructionsX:Int = 16;
        var instructionsWidth:Int = Std.int(FlxG.width / 2) - 32;
        
        // Mensaje de bienvenida
        welcomeText = new FunkinText(instructionsX, titleAlphabet.y + titleAlphabet.height + 10, instructionsWidth, "", 24);
        welcomeText.alignment = CENTER;
        welcomeText.text = "HOLAAAA bienvenido al mod <3\nBien, como te darás cuenta aparecen opciones a escoger,\nsigue las instrucciones dadas por Star para continuar.";
        add(welcomeText);
        
        // Encabezado para las opciones
        optionsHeader = new FunkinText(instructionsX, welcomeText.y + welcomeText.height + 10, instructionsWidth, "Opciones:", 24);
        optionsHeader.alignment = CENTER;
        add(optionsHeader);
        
        // Creamos las opciones del menú
        menuOptions = [];
        // La posición vertical base para la primera opción
        var optYBase:Float = optionsHeader.y + optionsHeader.height + 10;
        var spacing:Int = 30; // separación vertical entre opciones
        
        // Opción 0: Controles (no modificable)
        menuOptions.push({
            name: "Controles: ",
            values: ["ASWD"],
            currentIndex: 0,
            text: new FlxText(instructionsX, optYBase, instructionsWidth, "", 24)
        });
        // Opción 1: FPS: se puede alternar entre 30, 60 y 120 (por defecto 120)
        menuOptions.push({
            name: "FPS: ",
            values: ["30", "60", "120"],
            currentIndex: 2,
            text: new FlxText(instructionsX, optYBase + spacing, instructionsWidth, "", 24)
        });
        // Opción 2: Modo Pantalla: Ventana o Pantalla Completa
        menuOptions.push({
            name: "Modo Pantalla: ",
            values: ["Ventana", "Pantalla Completa"],
            currentIndex: 0,
            text: new FlxText(instructionsX, optYBase + 2 * spacing, instructionsWidth, "", 24)
        });
        
        // Configuramos la alineación de cada opción y las añadimos a la escena
        for (opt in menuOptions) {
            opt.text.alignment = "center";
            add(opt.text);
        }
        // Actualizamos el texto de cada opción (se les antepone "> " a la opción seleccionada)
        updateOptionsDisplay();
        
        // Mensaje para continuar
        continueText = new FunkinText(instructionsX, menuOptions[menuOptions.length - 1].text.y + menuOptions[menuOptions.length - 1].text.height + 20, instructionsWidth, "", 24);
        continueText.alignment = CENTER;
        continueText.text = "Presiona ENTER para continuar";
        add(continueText);
        
        // Centramos verticalmente todo el bloque de textos (excluyendo el título e ilustración)
        var blockTop:Float = titleAlphabet.y + titleAlphabet.height + 10;
        var blockBottom:Float = continueText.y + continueText.height;
        var blockHeight:Float = blockBottom - blockTop;
        var offset:Int = Std.int((FlxG.height - blockHeight) / 2) - Std.int(blockTop);
        welcomeText.y += offset;
        optionsHeader.y += offset;
        for (opt in menuOptions)
            opt.text.y += offset;
        continueText.y += offset;
        
        DiscordUtil.call("onMenuLoaded", ["Beta Warning"]);
    }
    
    /**
     * Actualiza el texto de cada opción del menú, añadiendo un prefijo "> " a la seleccionada.
     */
    function updateOptionsDisplay():Void {
        for (i in 0...menuOptions.length) {
            var option = menuOptions[i];
            var prefix = (i == selectedOption) ? "> " : "  ";
            option.text.text = prefix + option.name + option.values[option.currentIndex];
        }
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
        // Navegación vertical en el menú (UP/DOWN)
        if (FlxG.keys.justPressed("UP")) {
            selectedOption--;
            if (selectedOption < 0) selectedOption = menuOptions.length - 1;
            updateOptionsDisplay();
        }
        if (FlxG.keys.justPressed("DOWN")) {
            selectedOption++;
            if (selectedOption >= menuOptions.length) selectedOption = 0;
            updateOptionsDisplay();
        }
        
        // Modificar la opción con LEFT/RIGHT (si tiene más de un valor)
        if (FlxG.keys.justPressed("LEFT")) {
            var opt = menuOptions[selectedOption];
            if (opt.values.length > 1) {
                opt.currentIndex = (opt.currentIndex - 1 + opt.values.length) % opt.values.length;
                updateOptionsDisplay();
            }
        }
        if (FlxG.keys.justPressed("RIGHT")) {
            var opt = menuOptions[selectedOption];
            if (opt.values.length > 1) {
                opt.currentIndex = (opt.currentIndex + 1) % opt.values.length;
                updateOptionsDisplay();
            }
        }
        
        // Al presionar ENTER se dispara la transición
        if (FlxG.keys.justPressed("ENTER") && transitioning) {
            FlxG.camera.stopFX();
            FlxG.camera.visible = false;
            goToTitle();
        }
        if (FlxG.keys.justPressed("ENTER") && !transitioning) {
            transitioning = true;
            CoolUtil.playMenuSFX(CONFIRM);
            FlxG.camera.flash(FlxColor.WHITE, 1, function() {
                FlxG.camera.fade(FlxColor.BLACK, 2.5, false, goToTitle);
            });
        }
    }
    
    /**
     * Cambia de estado (por ejemplo, al título principal).
     */
    private function goToTitle():Void {
        MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
        FlxG.switchState(new TitleState());
    }
}
