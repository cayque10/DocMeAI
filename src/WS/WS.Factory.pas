unit WS.Factory;

interface

uses
  System.Classes,
  WS.Interfaces;

type
  TTypeHttpClient = (thcIndy, thcNetHttpClient);

  TWSFactory = class
  private
    FHttpClient: IWSRequest;
    FTypeHttpClient: TTypeHttpClient;
  protected
  public
    property HttpClient: IWSRequest read FHttpClient;
    constructor Create;
  end;

implementation

uses
  System.SysUtils,
  WS.Http.Net,
  WS.Http.Indy;

{ TWSFactory }

constructor TWSFactory.Create;
begin
  FTypeHttpClient := thcNetHttpClient;

  case FTypeHttpClient of
    thcIndy:
      FHttpClient := TWSHttpIndy.Create;
    thcNetHttpClient:
      FHttpClient := TWSHttpNetHttpClient.Create;
  end;
end;

end.
