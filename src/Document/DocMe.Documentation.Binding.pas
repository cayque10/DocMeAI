unit DocMe.Documentation.Binding;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  DocMe.Documentation.Process;

type
  TDocMeDocumentationBinding = class(TNotifierObject, IOTAKeyboardBinding)
    /// <summary>
    /// Initializes a new instance of the class.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Executes the keyboard binding with the given context and key code.
    /// </summary>
    /// <param name="AContext">The context in which the key is pressed.</param>
    /// <param name="AKeyCode">The shortcut key code that was pressed.</param>
    /// <param name="ABindingResult">The result of the key binding execution.</param>
    procedure Execute(const AContext: IOTAKeyContext; AKeyCode: TShortcut; var ABindingResult: TKeyBindingResult);
  protected
    /// <summary>
    /// Retrieves the type of binding for the keyboard.
    /// </summary>
    /// <returns>The binding type as a TBindingType enumeration.</returns>
    function GetBindingType: TBindingType;

    /// <summary>
    /// Retrieves the display name of the keyboard binding.
    /// </summary>
    /// <returns>The display name as a string.</returns>
    function GetDisplayName: string;

    /// <summary>
    /// Retrieves the name of the keyboard binding.
    /// </summary>
    /// <returns>The name as a string.</returns>
    function GetName: string;

    /// <summary>
    /// Binds the keyboard to the specified binding services.
    /// </summary>
    /// <param name="pBindingServices">The services used for binding the keyboard.</param>
    procedure BindKeyboard(const ABindingServices: IOTAKeyBindingServices);
  public
    /// <summary>
    /// Finalizes the instance of the class, releasing resources.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Creates a new instance of the keyboard binding.
    /// </summary>
    /// <returns>A new instance of IOTAKeyboardBinding.</returns>
    class function New: IOTAKeyboardBinding;
  end;

var
  Index: Integer = -1;

procedure RegisterKeyBindingDocument;

implementation

uses
  DocMe.Documentation;

procedure RegisterKeyBindingDocument;
begin
  Index := (BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TDocMeDocumentationBinding.New);
end;

{ TDocMeBinding }

procedure TDocMeDocumentationBinding.BindKeyboard(const ABindingServices: IOTAKeyBindingServices);
begin
  ABindingServices.AddKeyBinding([TextToShortCut('Ctrl+Shift+D')], Execute, nil, 0, '', 'miDocument');
end;

constructor TDocMeDocumentationBinding.Create;
begin
end;

destructor TDocMeDocumentationBinding.Destroy;
begin
  inherited;
end;

procedure TDocMeDocumentationBinding.Execute(const AContext: IOTAKeyContext; AKeyCode: TShortcut;
  var ABindingResult: TKeyBindingResult);
var
  lFrmDocumentation: TFrmDocMeAIDocumentation;
begin
  ABindingResult := krHandled;

  lFrmDocumentation := TFrmDocMeAIDocumentation.Create(nil);
  try
    lFrmDocumentation.ShowModal;
  finally
    lFrmDocumentation.Free;
  end;
end;

function TDocMeDocumentationBinding.GetBindingType: TBindingType;
begin
  Result := TBindingType.btPartial;
end;

function TDocMeDocumentationBinding.GetDisplayName: string;
begin
  Result := Self.ClassName;
end;

function TDocMeDocumentationBinding.GetName: string;
begin
  Result := Self.ClassName;
end;

class function TDocMeDocumentationBinding.New: IOTAKeyboardBinding;
begin
  Result := Self.Create;
end;

initialization

finalization

(BorlandIDEServices as IOTAKeyboardServices).RemoveKeyboardBinding(Index);

end.
