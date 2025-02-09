unit DocMe.Register;

interface

uses
  DocMe.Menu.Main,
  DocMe.Documentation.Binding;

procedure Register;

implementation

procedure Register;
begin
  RegisterKeyBindingDocument;
  RegisterMenuWizard;
end;

end.
