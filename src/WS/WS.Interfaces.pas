unit WS.Interfaces;

interface

uses
  System.Classes;

Type
  IWSRequest = interface
    ['{BB971F94-DECA-4112-9E22-7BF7CC8FB490}']
    function GetStream(const AResource: String): TStream;
    function Get(const AResource: String): String;
    function Post(const AResource: String; const ASource: TStream): String;
    function PostFile(const AResource: String; const APathFile: String): String;
    function Patch(const AResource: String; const ASource, AResponseContent: TStream): String;
    function Put(const AResource: String; const ASource: TStream): String;
    function Delete(const AResource: String; const ASource: TStream = nil): String;
    procedure BearerToken(const AToken: String);
    function ResponseCode: Integer;
    function ErrorMessage: String;
    function BaseMessage: String;
    function HeaderValue(const AName: String): String;
  end;

  IWSBase = interface
    ['{6984F294-A0CF-4FA9-A623-5B4EBD089BE1}']
    function WSResquest: IWSRequest;
    function GetBaseUrl: String;
    /// <summary>Chama exclusiva para autenticação
    /// </summary>
    /// <params name="AResource">Caminho da autenticação. Ex.: user/login
    /// </params>
    /// <params name="ASource">Dados necessários para efetuar a autenticação. Normalmente login e senha
    /// </params>
    function Authentication(const AResource: String; const ASource: TStream): String;
    procedure ClearAuthentication;
    function Params: TStrings;
    function SetBaseUrl(const AUrl: String): IWSBase;
    function Token: String;
    procedure TokenValidate(const AValue: String);
    procedure RefreshToken(const AValue: String);
    procedure CheckStatusConnection(const AUrl: String);
    function Response: String;
  end;


implementation

end.
