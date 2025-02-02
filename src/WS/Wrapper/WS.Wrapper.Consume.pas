unit WS.Wrapper.Consume;

interface

uses
  WS.Wrapper.interfaces,
  System.Generics.Collections,
  WS.interfaces,
  System.Classes;

type
  TWSWrapperConsume<T: class> = class(TInterfacedObject, IWSWrapper<T>)
  private
    FWS: IWSBase;
    FWSArquivo: IWSBase;
    FResposta: String;
    FArquivo: TStream;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IWSWrapper<T>;
    function Get(const AUrl: String; const AParam: String = ''): IWSWrapper<T>;
    function GetById(const AUrl: String; const AId: String): IWSWrapper<T>;
    function Add(const AUrl: String; const AEntity: T): IWSWrapper<T>;
    function Delete(const AUrl: String; const AId: String): IWSWrapper<T>; overload;
    function Delete(const AUrl: String; const AEntity: T): IWSWrapper<T>; overload;
    function Delete(const AUrl: String; const AEntity: T; const AFieldName: String): IWSWrapper<T>; overload;
    function Edit(const AUrl: String; const AEntity: T): IWSWrapper<T>;
    function SalvarArquivo(const AUrl: String; const ACaminhoArquivo: String): IWSWrapper<T>;
    function PegarArquivo(const AUrl: String; const ANomeArquivo: String): TStream;
    function Resposta(out AValor: TStream): IWSWrapper<T>; overload;
    function Resposta(out AValor: String): IWSWrapper<T>; overload;
    function WSRequest: IWSRequest;
  end;

implementation

uses
  WS.Base,
  WS.Wrapper.Converter,
  Utils.JSON,
  System.SysUtils;

{ TWebServiceRequest<T> }

constructor TWSWrapperConsume<T>.Create;
begin
  FWS := TWSBase.GetInstance;
end;

function TWSWrapperConsume<T>.Add(const AUrl: String; const AEntity: T): IWSWrapper<T>;
var
  LStream: TStringStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSWrapperConverter.EntitityToStream(AEntity);
  try
    FResposta := FWS.WSResquest.Post(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.Free;
  end;
end;

function TWSWrapperConsume<T>.Delete(const AUrl: String; const AId: String): IWSWrapper<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FWS.Params.Add(AId);
  FResposta := FWS.WSResquest.Delete(AUrl);
end;

function TWSWrapperConsume<T>.Delete(const AUrl: String; const AEntity: T): IWSWrapper<T>;
var
  LStream: TStringStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSWrapperConverter.EntitityToStream(AEntity);
  try
    FResposta := FWS.WSResquest.Delete(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.Free;
  end;
end;

function TWSWrapperConsume<T>.Delete(const AUrl: String; const AEntity: T; const AFieldName: String): IWSWrapper<T>;
var
  LStream: TStringStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSWrapperConverter.EntitityToStream<T>(AEntity, AFieldName);
  try
    FResposta := FWS.WSResquest.Delete(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.Free;
  end;
end;

destructor TWSWrapperConsume<T>.Destroy;
begin
  inherited;
end;

function TWSWrapperConsume<T>.Edit(const AUrl: String; const AEntity: T): IWSWrapper<T>;
var
  LStream: TStringStream;
begin
  Result := Self;
  FWS.Params.Clear;
  LStream := TWSWrapperConverter.EntitityToStream(AEntity);
  try
    FResposta := FWS.WSResquest.Put(AUrl, LStream);
  finally
    if Assigned(LStream) then
      LStream.Free;
  end;
end;

class function TWSWrapperConsume<T>.New: IWSWrapper<T>;
begin
  Result := Self.Create;
end;

function TWSWrapperConsume<T>.PegarArquivo(const AUrl, ANomeArquivo: String): TStream;
begin
  // Criado variavel no heaper para manter em memoria até destruir a classe, pois caso seja destruida antecipadamente,
  // o TStream tambem é liberado não exibindo a imagem
  FWSArquivo := TWSBase.Create;
  FWSArquivo.Params.Clear;
  FWSArquivo.Params.Add(ANomeArquivo);
  Result := FWSArquivo.WSResquest.GetStream(AUrl);
end;

function TWSWrapperConsume<T>.GetById(const AUrl: String; const AId: String): IWSWrapper<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  FWS.Params.Add(AId);
  FResposta := FWS.WSResquest.Get(AUrl);
end;

function TWSWrapperConsume<T>.Get(const AUrl: String; const AParam: String = ''): IWSWrapper<T>;
begin
  Result := Self;
  FWS.Params.Clear;
  if not AParam.Trim.IsEmpty then
    FWS.Params.Add(AParam);
  FResposta := FWS.WSResquest.Get(AUrl);
end;

function TWSWrapperConsume<T>.Resposta(out AValor: TStream): IWSWrapper<T>;
begin
  Result := Self;
  AValor := FArquivo;
end;

function TWSWrapperConsume<T>.WSRequest: IWSRequest;
begin
  Result := FWS.WSResquest;
end;

function TWSWrapperConsume<T>.Resposta(out AValor: String): IWSWrapper<T>;
begin
  Result := Self;
  AValor := FResposta;
end;

function TWSWrapperConsume<T>.SalvarArquivo(const AUrl, ACaminhoArquivo: String): IWSWrapper<T>;
begin
  Result := Self;
  FResposta := FWS.WSResquest.PostFile(AUrl, ACaminhoArquivo);
end;

end.
