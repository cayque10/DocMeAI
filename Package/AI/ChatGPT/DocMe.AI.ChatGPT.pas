unit DocMe.AI.ChatGPT;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces;

type
  TDocMeAIChatGPT = class(TInterfacedObject, IDocMeAI)
  private
    FConfig: IDocMeAIConfig;
    FAdditionalInfo: string;

    /// <summary>
    /// Initializes a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the instance.</param>
    constructor Create(const pConfig: IDocMeAIConfig);

    /// <summary>
    /// Builds a prompt based on the provided data.
    /// </summary>
    /// <param name="pData">The data to be used for building the prompt.</param>
    /// <returns>A string representing the built prompt.</returns>
    function BuildPrompt(const pData: string): string;

    /// <summary>
    /// Formats the response string.
    /// </summary>
    /// <param name="pResponse">The response string to be formatted.</param>
    /// <returns>A string representing the formatted response.</returns>
    function FormatResponse(const pResponse: string): string;
  protected
  public
    /// <summary>
    /// Creates a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the new instance.</param>
    /// <returns>An instance of IDocMeAI.</returns>
    class function New(const pConfig: IDocMeAIConfig): IDocMeAI;

    /// <summary>
    /// Documents the elements based on the provided data and additional information.
    /// </summary>
    /// <param name="pData">The data to be documented.</param>
    /// <param name="pAdditionalInfo">Optional additional information for documentation.</param>
    /// <returns>A string representing the documented elements.</returns>
    function DocumentElements(const pData: string; const pAdditionalInfo: string = ''): string;
  end;

implementation

uses
  OpenAI,
  OpenAI.Chat,
  System.StrUtils,
  System.SysUtils;

{ TDocMeAIChatGPT }

function TDocMeAIChatGPT.BuildPrompt(const pData: string): string;
begin
  Result := 'Your goal is to document procedures, functions, properties, and units provided in the Delphi XML' +
    ' comment format in English. ' + 'Follow these instructions:' + sLineBreak +
    '1. Document each method using XML comments directly above its declaration.' + sLineBreak +
    '2. Use the tags <summary>, <param>, and <returns> as needed.' + sLineBreak +
    '3. The <summary> tag should explain the purpose of the method.' + sLineBreak +
    '4. Use the <param> tag to describe each parameter.' + sLineBreak +
    '5. Use the <returns> tag to describe the return value, if applicable.' + sLineBreak +
    '6. Use the <see cref="type"/> tag to describe data type, if applicable.' + sLineBreak +
    '7. Do not modify the implementation of the method.' + sLineBreak +
    '8. Each XML comment should be on its own line, properly formatted and clean.' + sLineBreak +
    '9. Always return only the documentation, with no additional comments or explanations.' + sLineBreak + sLineBreak +
    'Here is the method(s) to be documented:' + sLineBreak + sLineBreak + pData + sLineBreak + sLineBreak +
    IfThen(FAdditionalInfo.Trim.IsEmpty, '', Format('additional information about de elements: %s ',
    [FAdditionalInfo]));
end;

constructor TDocMeAIChatGPT.Create(const pConfig: IDocMeAIConfig);
begin
  FConfig := pConfig;
end;

function TDocMeAIChatGPT.DocumentElements(const pData: string; const pAdditionalInfo: string = ''): string;
var
  lOpenAI: TOpenAI;
  lChat: TChat;
begin
  FAdditionalInfo := pAdditionalInfo;

  lOpenAI := TOpenAI.Create(FConfig.ApiKey);
  try
    lChat := lOpenAI.Chat.Create(
      procedure(Params: TChatParams)
      begin
        Params.Messages([TChatMessageBuild.Create(TMessageRole.User, BuildPrompt(pData))]);
        Params.MaxTokens(FConfig.MaxTokens);
        Params.TEMPERATURE(FConfig.TEMPERATURE);
        Params.Model(FConfig.ModelAI);
      end);

    try
      for var lChoice in lChat.Choices do
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

function TDocMeAIChatGPT.FormatResponse(const pResponse: string): string;
begin
  Result := StringReplace(pResponse, #$A, #13#10, [rfReplaceAll]);
  Result := Result.Replace('`', '').Replace('delphi', '');
end;

class function TDocMeAIChatGPT.New(const pConfig: IDocMeAIConfig): IDocMeAI;
begin
  Result := Self.Create(pConfig);
end;

end.
