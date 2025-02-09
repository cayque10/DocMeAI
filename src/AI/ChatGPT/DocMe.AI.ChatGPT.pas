unit DocMe.AI.ChatGPT;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces,
  DocMe.AI.PromptBuilder.Interfaces;

type
  TDocMeAIChatGPT = class(TInterfacedObject, IDocMeAI)
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
    /// <param name="AResponse">The response string to be formatted.</param>
    /// <returns>A string representing the formatted response.</returns>
    function FormatResponse(const AResponse: string): string;
  protected
  public
    /// <summary>
    /// Creates a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="AConfig">The configuration to be used for the new instance.</param>
    /// <returns>An instance of IDocMeAI.</returns>
    class function New(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder): IDocMeAI;

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
  OpenAI,
  OpenAI.Chat,
  System.StrUtils,
  System.SysUtils;

{ TDocMeAIChatGPT }

function TDocMeAIChatGPT.BuildPrompt(const AData: string): string;
begin
  Result := FPromptBuilder.BuildPrompt(AData, FAdditionalInfo);
end;

constructor TDocMeAIChatGPT.Create(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder);
begin
  FConfig := AConfig;
  FPromptBuilder := APromptBuilder;
end;

function TDocMeAIChatGPT.DocumentElements(const AData: string; const AAdditionalInfo: string = ''): string;
var
  lOpenAI: TOpenAI;
  lChat: TChat;
  lChoice: TChatChoices;
begin
  FAdditionalInfo := AAdditionalInfo;

  lOpenAI := TOpenAI.Create(FConfig.ApiKey);
  try
    lChat := lOpenAI.Chat.Create(
      procedure(Params: TChatParams)
      begin
        Params.Messages([TChatMessageBuild.Create(TMessageRole.User, BuildPrompt(AData))]);
        Params.MaxTokens(FConfig.MaxTokens);
        Params.TEMPERATURE(FConfig.TEMPERATURE);
        Params.Model(FConfig.ModelAI);
      end);

    try
      for lChoice in lChat.Choices do
      begin
        Result := FormatResponse(lChoice.Message.Content);
        Break;
      end;
    finally
      lChat.Free;
    end;
  finally
    lOpenAI.Free;
  end;
end;

function TDocMeAIChatGPT.FormatResponse(const AResponse: string): string;
begin
  Result := StringReplace(AResponse, #$A, #13#10, [rfReplaceAll]);
  Result := Result.Replace('`', '').Replace('delphi', '');
end;

class function TDocMeAIChatGPT.New(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder)
  : IDocMeAI;
begin
  Result := Self.Create(AConfig, APromptBuilder);
end;

end.
