package funkin.backend.system.framerate;

import openfl.text.TextFormat;
import openfl.text.TextField;
import funkin.backend.system.macros.GitCommitMacro;

class CodenameBuildField extends TextField {
    public function new() {
        super();
        defaultTextFormat = Framerate.textFormat;
        autoSize = LEFT;
        multiline = false;
        wordWrap = false;
        text = 'Project Undernight v${Main.releaseVersion}\n' +
               'Build: ${GitCommitMacro.commitHash}';
        selectable = false;
    }
}