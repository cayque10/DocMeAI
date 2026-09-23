unit DocMe.IDE.ActiveProject;

interface

uses
  DocMe.IDE.ActiveProject.Interfaces;

type
  TDocMeActiveProjectPath = class(TInterfacedObject, IDocMeActiveProjectPath)
  private
    constructor Create;
  public
    class function New: IDocMeActiveProjectPath;
    function GetActiveProjectPath: string;
  end;

implementation

uses
  System.SysUtils,
  ToolsAPI;

{ TDocMeActiveProjectPath }

constructor TDocMeActiveProjectPath.Create;
begin

end;

function TDocMeActiveProjectPath.GetActiveProjectPath: string;
var
  lModuleServices: IOTAModuleServices;
  lProject: IOTAProject;
begin
  Result := '';
  try
    if not Assigned(BorlandIDEServices) then
      Exit;

    lModuleServices := BorlandIDEServices as IOTAModuleServices;
    if not Assigned(lModuleServices) then
      Exit;

    lProject := lModuleServices.GetActiveProject;
    if not Assigned(lProject) or lProject.FileName.Trim.IsEmpty then
      Exit;

    Result := ExtractFileDir(lProject.FileName);
  except
    Result := '';
  end;
end;

class function TDocMeActiveProjectPath.New: IDocMeActiveProjectPath;
begin
  Result := Self.Create;
end;

end.
