unit DocMe.AI.DeepSeek;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces;

type
  TDocMeAIDeepSeek = class(TInterfacedObject, IDocMeAI)
  private
    FConfig: IDocMeAIConfig;
    FAdditionalInfo: string;

    /// <summary>
    /// Initializes a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="AConfig">The configuration to be used for the instance.</param>
    constructor Create(const AConfig: IDocMeAIConfig);

    /// <summary>
    /// Builds a prompt based on the provided data.
    /// </summary>
    /// <param name="AData">The data to be used for building the prompt.</param>
    /// <returns>A string representing the built prompt.</returns>
    function BuildPrompt(const AData: string): string;

    /// <summary>
    /// Formats the response string.
    /// </summary>
    /// <param name="pResponse">The response string to be formatted.</param>
    /// <returns>A string representing the formatted response.</returns>
    function FormatResponse(const AResponse: string): string;
  protected
  public
    /// <summary>
    /// Creates a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the new instance.</param>
    /// <returns>An instance of IDocMeAI.</returns>
    class function New(const AConfig: IDocMeAIConfig): IDocMeAI;

    /// <summary>
    /// Documents the elements based on the provided data and additional information.
    /// </summary>
    /// <param name="AData">The data to be documented.</param>
    /// <param name="AAdditionalInfo">Optional additional information for documentation.</param>
    /// <returns>A string representing the documented elements.</returns>
    function DocumentElements(const AData: string; const AAdditionalInfo: string = ''): string;
  end;

implementation

uses
  System.SysUtils;

{ TDocMeAIDeepSeek }

function TDocMeAIDeepSeek.BuildPrompt(const AData: string): string;
begin
  Result := '';
end;

constructor TDocMeAIDeepSeek.Create(const AConfig: IDocMeAIConfig);
begin
  FConfig := AConfig;
  raise Exception.Create('Not implemented');
end;

function TDocMeAIDeepSeek.DocumentElements(const AData, AAdditionalInfo: string): string;
begin
  FAdditionalInfo := AAdditionalInfo;
  Result := FormatResponse(BuildPrompt(''));
end;

function TDocMeAIDeepSeek.FormatResponse(const AResponse: string): string;
begin
  Result := '';
end;

class function TDocMeAIDeepSeek.New(const AConfig: IDocMeAIConfig): IDocMeAI;
begin
  Result := Self.Create(AConfig);
end;

end.
