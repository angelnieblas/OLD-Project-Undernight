package funkin.backend.system.framerate;

import openfl.text.TextFormat;
import openfl.text.TextField;
import funkin.backend.system.macros.GitCommitMacro;
import Date;

class CodenameBuildField extends TextField {
    public function new() {
        super();
        defaultTextFormat = Framerate.textFormat;
        autoSize = LEFT;
        multiline = false;
        wordWrap = false;
        var now = Date.now();
        var dateStr = '${now.getFullYear()}-${StringTools.lpad(Std.string(now.getMonth() + 1), "0", 2)}-${StringTools.lpad(Std.string(now.getDate()), "0", 2)} ' +
                      '${StringTools.lpad(Std.string(now.getHours()), "0", 2)}:${StringTools.lpad(Std.string(now.getMinutes()), "0", 2)}:${StringTools.lpad(Std.string(now.getSeconds()), "0", 2)}';
        var timezoneOffset = -now.getTimezoneOffset();
        var sign = timezoneOffset >= 0 ? "+" : "-";
        var hours = StringTools.lpad(Std.string(Math.floor(Math.abs(timezoneOffset) / 60)), "0", 2);
        var minutes = StringTools.lpad(Std.string(Math.abs(timezoneOffset) % 60), "0", 2);
        var tzStr = 'GMT${sign}${hours}:${minutes}';
        text = 'Project Undernight v${Main.releaseVersion}\n' +
               'Build: ${GitCommitMacro.commitHash}\n' +
               'Dev Build\n' +
               dateStr + ' ' + tzStr;
        selectable = false;
    }
}