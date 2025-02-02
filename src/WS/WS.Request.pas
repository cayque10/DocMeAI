unit WebService.Request;

interface

uses
  WebService.interfaces,
  System.Generics.Collections,
  WS.interfaces,
  System.Classes;

type
  TWebServiceRequest<T: class> = class(TInterfacedObject, IWebServiceRequest<T>)
  private
    FWS: IWSBase;
    FResposta: String;
    FArquivo: TStream;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IWebServiceRequest<T>;
    function PegarTodos(const AUrl: String): IWebServiceRequest<T>;
    function PegarPeloId(const AUrl: String; const AId: Integer): IWebServiceRequest<T>;
    function Criar(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
    function Deletar(const AUrl: String; const AId: Integer): IWebServiceRequest<T>;
    function Editar(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
    function SalvarArquivo(const AUrl: String; const ACaminhoArquivo: String)
      : IWebServiceRequest<T>;
    function PegarArquivo(const AUrl: String; const ANomeArquivo: String): IWebServiceRequest<T>;
    function Resposta(out AValor: TStream): IWebServiceRequest<T>; overload;
    function Resposta(out AValor: String): IWebServiceRequest<T>; overload;
    function Post(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
    function WSRequest: IWSRequest;
  end;

implementation

uses
  WS.Base,
  WS.Adapter.Request,
  Utils.JSON,
  System.SysUtils;

{ TWebServiceRequest<T> }

constructor TWebServiceRequest<T>.Create;
begin
  FWS := TWSBase.GetInstance;
end;

function TWebServiceRequest<T>.Criar(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
var
  LStream: TStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSAdapterRequest.EntitityToStream<T>(AEntity);
  try
    FWS.WSResquest.Post(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.DisposeOf;
  end;
end;

function TWebServiceRequest<T>.Deletar(const AUrl: String; const AId: Integer)
  : IWebServiceRequest<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FWS.Params.Add(AId.ToString);
  FWS.WSResquest.Delete(AUrl);
end;

destructor TWebServiceRequest<T>.Destroy;
begin
  { if Assigned(FArquivo) then
    FArquivo.DisposeOf; }
  inherited;
end;

function TWebServiceRequest<T>.Editar(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
var
  LStream: TStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSAdapterRequest.EntitityToStream<T>(AEntity);
  try
    FWS.WSResquest.Put(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.DisposeOf;
  end;
end;

class function TWebServiceRequest<T>.New: IWebServiceRequest<T>;
begin
  Result := Self.Create;
end;

function TWebServiceRequest<T>.PegarArquivo(const AUrl, ANomeArquivo: String)
  : IWebServiceRequest<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FWS.Params.Add(ANomeArquivo);
  FArquivo := FWS.WSResquest.GetStream(AUrl);
end;

function TWebServiceRequest<T>.PegarPeloId(const AUrl: String; const AId: Integer)
  : IWebServiceRequest<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FWS.Params.Add(AId.ToString);
  FResposta := FWS.WSResquest.Get(AUrl);
end;

function TWebServiceRequest<T>.PegarTodos(const AUrl: String): IWebServiceRequest<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FResposta := FWS.WSResquest.Get(AUrl);
end;

function TWebServiceRequest<T>.Post(const AUrl: String; const AEntity: T): IWebServiceRequest<T>;
var
  LStream: TStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSAdapterRequest.EntitityToStream<T>(AEntity);
  try
    FWS.WSResquest.Post(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.DisposeOf;
  end;
end;

function TWebServiceRequest<T>.Resposta(out AValor: TStream): IWebServiceRequest<T>;
begin
  Result := Self;
  AValor := FArquivo;
end;

function TWebServiceRequest<T>.WSRequest: IWSRequest;
begin
  Result := FWS.WSResquest;
end;

function TWebServiceRequest<T>.Resposta(out AValor: String): IWebServiceRequest<T>;
begin
  Result := Self;
  AValor := FResposta;
end;

function TWebServiceRequest<T>.SalvarArquivo(const AUrl, ACaminhoArquivo: String)
  : IWebServiceRequest<T>;
begin
  Result := Self;
  FWS.WSResquest.PostFile(AUrl, ACaminhoArquivo);
end;

end.
