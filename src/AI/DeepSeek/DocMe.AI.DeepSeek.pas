unit DocMe.AI.DeepSeek;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces,
  DocMe.AI.PromptBuilder.Interfaces;

type
  TDocMeAIDeepSeek = class(TInterfacedObject, IDocMeAI)
  private
    FConfig: IDocMeAIConfig;
    FAdditionalInfo: string;
    FPromptBuilder: IDocMeAIPromptBuilder;
    /// <summary>
    /// Initializes a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="AConfig">The configuration to be used for the instance.</param>
    constructor Create(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder);

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
    class function New(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder): IDocMeAI;

    /// <summary>
    /// Generates a summary based on the provided data and additional information.
    /// </summary>
    /// <param name="AData">The main data used to create the summary.</param>
    /// <param name="AAdditionalInfo">Optional additional information to include in the summary.</param>
    /// <returns>
    /// A string representing the generated summary.
    /// </returns>
    function GenerateSummary(const AData: string; const AAdditionalInfo: string = ''): string;
  end;

implementation

uses
  System.SysUtils;

{ TDocMeAIDeepSeek }

function TDocMeAIDeepSeek.BuildPrompt(const AData: string): string;
begin
  Result := '';
end;

constructor TDocMeAIDeepSeek.Create(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder);
begin
  FConfig := AConfig;
  FPromptBuilder := APromptBuilder;
  raise Exception.Create('Not implemented');
end;

function TDocMeAIDeepSeek.GenerateSummary(const AData, AAdditionalInfo: string): string;
begin
  FAdditionalInfo := AAdditionalInfo;
  Result := FormatResponse(BuildPrompt(''));
end;

function TDocMeAIDeepSeek.FormatResponse(const AResponse: string): string;
begin
  Result := '';
end;

class function TDocMeAIDeepSeek.New(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder)
  : IDocMeAI;
begin
  Result := Self.Create(AConfig, APromptBuilder);
end;

end.
