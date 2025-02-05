unit WS.Interfaces;

interface

uses
  System.Classes;

Type
  IWSRequest = interface
    ['{BB971F94-DECA-4112-9E22-7BF7CC8FB490}']

    /// <summary>
    /// Retrieves a stream from the specified resource.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <returns>
    /// A stream containing the data from the specified resource.
    /// </returns>
    function GetStream(const AResource: String): TStream;

    /// <summary>
    /// Sends a GET request to the specified resource and retrieves the response as a string.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function Get(const AResource: String): String;

    /// <summary>
    /// Sends a POST request to the specified resource with the provided source stream.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <param name="ASource">The source stream containing the data to be sent.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function Post(const AResource: String; const ASource: TStream): String;

    /// <summary>
    /// Sends a POST request to the specified resource with the contents of the specified file.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <param name="APathFile">The path to the file to be sent.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function PostFile(const AResource: String; const APathFile: String): String;

    /// <summary>
    /// Sends a PATCH request to the specified resource with the provided source stream and retrieves the response content.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <param name="ASource">The source stream containing the data to be patched.</param>
    /// <param name="AResponseContent">The stream to receive the response content.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function Patch(const AResource: String; const ASource, AResponseContent: TStream): String;

    /// <summary>
    /// Sends a PUT request to the specified resource with the provided source stream.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <param name="ASource">The source stream containing the data to be sent.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function Put(const AResource: String; const ASource: TStream): String;

    /// <summary>
    /// Sends a DELETE request to the specified resource with an optional source stream.
    /// </summary>
    /// <param name="AResource">The resource identifier as a string.</param>
    /// <param name="ASource">An optional source stream containing the data to be sent.</param>
    /// <returns>
    /// The response from the resource as a string.
    /// </returns>
    function Delete(const AResource: String; const ASource: TStream = nil): String;

    /// <summary>
    /// Sets the bearer token for authentication.
    /// </summary>
    /// <param name="AToken">The bearer token as a string.</param>
    procedure BearerToken(const AToken: String);

    /// <summary>
    /// Retrieves the response code from the last request.
    /// </summary>
    /// <returns>
    /// The HTTP response code as an integer.
    /// </returns>
    function ResponseCode: Integer;

    /// <summary>
    /// Retrieves the error message from the last request, if any.
    /// </summary>
    /// <returns>
    /// The error message as a string.
    /// </returns>
    function ErrorMessage: String;

    /// <summary>
    /// Retrieves the base message from the last request.
    /// </summary>
    /// <returns>
    /// The base message as a string.
    /// </returns>
    function BaseMessage: String;

    /// <summary>
    /// Retrieves the value of the specified header from the last request.
    /// </summary>
    /// <param name="AName">The name of the header as a string.</param>
    /// <returns>
    /// The value of the specified header as a string.
    /// </returns>
    function HeaderValue(const AName: String): String;

  end;

  IWSBase = interface
    ['{6984F294-A0CF-4FA9-A623-5B4EBD089BE1}']

    /// <summary>
    /// Creates and returns an instance of an IWSRequest.
    /// </summary>
    /// <returns>
    /// An instance of IWSRequest.
    /// </returns>
    function WSResquest: IWSRequest;

    /// <summary>
    /// Retrieves the base URL as a string.
    /// </summary>
    /// <returns>
    /// The base URL as a String.
    /// </returns>
    function GetBaseUrl: String;

    /// <summary>Chama exclusiva para autenticação
    /// </summary>
    /// <params name="AResource">Caminho da autenticação. Ex.: user/login
    /// </params>
    /// <params name="ASource">Dados necessários para efetuar a autenticação. Normalmente login e senha
    /// </params>
    function Authentication(const AResource: String; const ASource: TStream): String;

    /// <summary>
    /// Clears the authentication information.
    /// </summary>
    procedure ClearAuthentication;

    /// <summary>
    /// Retrieves the parameters as a TStrings object.
    /// </summary>
    /// <returns>
    /// A TStrings object containing the parameters.
    /// </returns>
    function Params: TStrings;

    /// <summary>
    /// Sets the base URL for the web service.
    /// </summary>
    /// <param name="AUrl">
    /// The base URL to be set.
    /// </param>
    /// <returns>
    /// An interface to the web service base.
    /// </returns>
    function SetBaseUrl(const AUrl: String): IWSBase;

    /// <summary>
    /// Retrieves the authentication token as a string.
    /// </summary>
    /// <returns>
    /// A string containing the authentication token.
    /// </returns>
    function Token: String;

    /// <summary>
    /// Validates the provided token value.
    /// </summary>
    /// <param name="AValue">
    /// The token value to be validated.
    /// </param>
    procedure TokenValidate(const AValue: String);

    /// <summary>
    /// Refreshes the authentication token with the provided value.
    /// </summary>
    /// <param name="AValue">
    /// The new token value to refresh.
    /// </param>
    procedure RefreshToken(const AValue: String);

    /// <summary>
    /// Checks the status of the connection to the specified URL.
    /// </summary>
    /// <param name="AUrl">
    /// The URL to check the connection status.
    /// </param>
    procedure CheckStatusConnection(const AUrl: String);

    /// <summary>
    /// Retrieves the response as a string.
    /// </summary>
    /// <returns>
    /// A string containing the response.
    /// </returns>
    function Response: String;

  end;

implementation

end.
