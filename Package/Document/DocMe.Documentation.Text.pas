unit DocMe.Documentation.Text;

interface

uses
  DocMe.Documentation.Text.Interfaces;

type
  TDocMeDocumentationText = class(TInterfacedObject, IDocMeAIText)
  private
    constructor Create;
  public
    class function New: IDocMeAIText;
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
    /// <param name="pNewText">
    /// The new text to replace the selected text with.
    /// </param>
    procedure ReplaceSelectedText(const pNewText: string);
  end;

implementation

uses
  ToolsAPI;

{ TDocMeDocumentationText }

constructor TDocMeDocumentationText.Create;
begin

end;

function TDocMeDocumentationText.GetSelectedText: string;
var
  lEditorServices: IOTAEditorServices;
  lEditView: IOTAEditView;
begin
  Result := '';
  lEditorServices := BorlandIDEServices as IOTAEditorServices;
  if Assigned(lEditorServices) and (lEditorServices.TopView <> nil) then
  begin
    lEditView := lEditorServices.TopView;
    Result := lEditView.Buffer.EditBlock.Text;
  end;
end;

class function TDocMeDocumentationText.New: IDocMeAIText;
begin
  Result := Self.Create;
end;

procedure TDocMeDocumentationText.ReplaceSelectedText(const pNewText: string);
var
  lEditorServices: IOTAEditorServices;
  lEditView: IOTAEditView;
  lEditPosition: IOTAEditPosition;
  lSelectedText: string;
  lSelectionLength: Integer;
begin
  lEditorServices := BorlandIDEServices as IOTAEditorServices;
  if Assigned(lEditorServices) and (lEditorServices.TopView <> nil) then
  begin
    lEditView := lEditorServices.TopView;
    lEditPosition := lEditView.Position;

    lSelectedText := GetSelectedText;

    lSelectionLength := Length(lSelectedText);

    if lSelectionLength > 0 then
      lEditPosition.InsertText(pNewText);
  end;
end;

end.
