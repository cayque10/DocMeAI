unit Main;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TFrmDocMeAITest = class(TForm)
  private

    /// <summary>
    /// Processes the provided data string for documentation purposes.
    /// </summary>
    /// <param name="pData">The data string to be documented.</param>
    procedure DocumentMethodFromAI(const pData: string);

    /// <summary>
    /// Processes the provided object for documentation purposes.
    /// </summary>
    /// <param name="pObject">The object to be documented.</param>
    procedure DocumentMethodFromAI2(const pObject: TObject);

    /// <summary>
    /// Retrieves a documentation string based on internal processing.
    /// </summary>
    /// <returns>
    /// A string containing the documentation.
    /// </returns>
    function DocumentMethodFromAI3: string;

  public
  end;

var
  FrmDocMeAITest: TFrmDocMeAITest;

implementation

{$R *.fmx}
{ TFrmDocMeAITest }

procedure TFrmDocMeAITest.DocumentMethodFromAI(const pData: string);
begin
  DocumentMethodFromAI2(nil);
end;

procedure TFrmDocMeAITest.DocumentMethodFromAI2(const pObject: TObject);
begin
  DocumentMethodFromAI3;
end;

function TFrmDocMeAITest.DocumentMethodFromAI3: string;
begin
  DocumentMethodFromAI('');
end;

end.
