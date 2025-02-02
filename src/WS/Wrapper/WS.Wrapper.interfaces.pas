unit WS.Wrapper.interfaces;

interface

uses
  System.Generics.Collections,
  System.Classes,
  WS.interfaces;

type
  IWSWrapper<T: class> = interface
    function Get(const AUrl: String; const AParam: String = ''): IWSWrapper<T>;
    function GetById(const AUrl: String; const AId: String): IWSWrapper<T>;
    function Add(const AUrl: String; const AEntity: T): IWSWrapper<T>;
    function Delete(const AUrl: String; const AId: String): IWSWrapper<T>; overload;
    function Delete(const AUrl: String; const AEntity: T): IWSWrapper<T>; overload;
    function Delete(const AUrl: String; const AEntity: T; const AFieldName: String): IWSWrapper<T>; overload;
    function Edit(const AUrl: String; const AEntity: T): IWSWrapper<T>;
    function SalvarArquivo(const AUrl: String; const ACaminhoArquivo: String)
      : IWSWrapper<T>;
    function PegarArquivo(const AUrl: String; const ANomeArquivo: String): TStream;
    function Resposta(out AValor: String): IWSWrapper<T>; overload;
    function Resposta(out AValor: TStream): IWSWrapper<T>; overload;
    function WSRequest: IWSRequest;
  end;

implementation

end.
