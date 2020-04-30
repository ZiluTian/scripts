import QtQml 2.0
import QOwnNotesTypes 1.0
import com.qownnotes.noteapi 1.0

/**
 * This script merges notes in the reverse node Id order and strips the title
 */
Script {
    /**
     * Initializes the custom actions
     */
    function init() {
        script.registerCustomAction("combine-webpage-notes", "Combine notes from the same page to a new note", "", "", false, true, true);
    }

    /**
     * This function is invoked when a custom action is triggered
     * in the menu or via button
     * 
     * @param identifier string the identifier defined in registerCustomAction
     */
    function customActionInvoked(identifier) {
        if (identifier != "combine-webpage-notes") {
            return;
        }

        var noteIds = script.selectedNotesIds();

        if (noteIds.length == 0) {
            return;
        }

        var noteSeparator = '\n\n'; 

        var sorted = noteIds.sort((a, b) => b - a) // reorder the notes 
                            .map(id => script.fetchNoteById(id)); 

        var newHeader = sorted[0].noteText.toString().split('\n').filter(x => x!='').slice(0, 3); 

        var newText = sorted.map(note => note.noteText.split('\n').filter(x => x!='').slice(3).join('\n')).join(noteSeparator); 

        newHeader[0] = script.inputDialogGetText("note name", "Please specify a name", newHeader[0]); 

        script.createNote([newHeader.join('\n'), newText].join('\n\n')); 
    }
}
