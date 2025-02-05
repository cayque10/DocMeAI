unit WS.Parser;

interface

uses
  Utils.Pkg.Json.DTO,
  System.Generics.Collections,
  REST.Json.Types;

type
  TWSParserJSONToEntity = class(TJsonDTO)
  private
    [JSONName('message')]
    FMessage: string;
    [JSONName('status')]
    FStatus: Integer;
  public
    property Message: string read FMessage write FMessage;
    property Status: Integer read FStatus write FStatus;
  end;

implementation

end.
