unit WS.Wrapper.Attributes;

interface

type

  WSWrapperConverter = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String read FName;
  end;

  WSWrapperIgnore = class(TCustomAttribute);

implementation

{ WSWrapperConverter }

constructor WSWrapperConverter.Create(const AName: String);
begin
  FName := AName;
end;

end.
