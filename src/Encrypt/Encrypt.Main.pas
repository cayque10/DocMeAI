unit Encrypt.Main;

interface

uses
  Encrypt.Interfaces,
  Encrypt.MEncryptDecryptAES;

type
  TEncryptMain = class(TInterfacedObject, IEncrypt)
  private
    FMEncryptDecrypt: TMEncryptDecryptAES;
    constructor Create;
  public
    /// <summary>
    /// Creates a new instance of an object that implements the IEncrypt interface.
    /// </summary>
    /// <returns>
    /// An instance of a class that implements the <see cref="IEncrypt"/> interface.
    /// </returns>
    class function New: IEncrypt;

    destructor Destroy; override;

    /// <summary>
    /// Encrypts the specified string value using AES encryption with the provided key.
    /// </summary>
    /// <param name="AValue">The string value to be encrypted.</param>
    /// <param name="AKey">The encryption key used for the AES algorithm.</param>
    /// <returns>
    /// The encrypted string value.
    /// </returns>
    function AESEncrypt(const AValue: string; const AKey: string): string;

    /// <summary>
    /// Decrypts the specified encrypted string value using AES decryption with the provided key.
    /// </summary>
    /// <param name="AEncryptedValue">The encrypted string value to be decrypted.</param>
    /// <param name="AKey">The decryption key used for the AES algorithm.</param>
    /// <returns>
    /// The original string value before encryption.
    /// </returns>
    function AESDecrypt(const AEncryptedValue: string; const AKey: string): string;
  end;

implementation

{ TEncryptMain }

function TEncryptMain.AESDecrypt(const AEncryptedValue, AKey: string): string;
begin
  Result := FMEncryptDecrypt.DecryptPassword(AEncryptedValue, AKey);
end;

function TEncryptMain.AESEncrypt(const AValue, AKey: string): string;
begin
  Result := FMEncryptDecrypt.EncryptPassword(AValue, AKey);
end;

constructor TEncryptMain.Create;
begin
  FMEncryptDecrypt := TMEncryptDecryptAES.Create;
end;

destructor TEncryptMain.Destroy;
begin
  FMEncryptDecrypt.Free;
  inherited;
end;

class function TEncryptMain.New: IEncrypt;
begin
  Result := Self.Create;
end;

end.
