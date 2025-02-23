unit Encrypt.Interfaces;

interface

type
  IEncrypt = interface
    ['{637D9B58-00DD-4794-B794-D0D2C8E025F1}']

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

end.
