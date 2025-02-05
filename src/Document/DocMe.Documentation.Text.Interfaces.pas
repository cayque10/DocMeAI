unit DocMe.Documentation.Text.Interfaces;

interface

type
  IDocMeAIText = interface
    ['{131CA37C-02B3-42BF-B41C-45560E3310B6}']
    /// <summary>
    /// Retrieves the currently selected text.
    /// </summary>
    /// <returns>
    /// A string containing the selected text.
    /// </returns>
    function GetSelectedText: string;

    /// <summary>
    /// Replaces the currently selected text with the specified new text.
    /// </summary>
    /// <param name="ANewText">
    /// The new text to replace the selected text with.
    /// </param>
    procedure ReplaceSelectedText(const ANewText: string);
  end;

implementation

end.
