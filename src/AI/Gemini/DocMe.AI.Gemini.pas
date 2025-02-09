unit DocMe.AI.Gemini;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces,
  DocMe.AI.PromptBuilder.Interfaces;

type
  TDocMeAIGemini = class(TInterfacedObject, IDocMeAI)
  private
    FConfig: IDocMeAIConfig;
    FAdditionalInfo: string;
    FPromptBuilder: IDocMeAIPromptBuilder;
    /// <summary>
    /// Initializes a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the instance.</param>
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
  GeminiAPI.Main,
  System.SysUtils,
  System.StrUtils;

{ TDocMeAIGemini }

function TDocMeAIGemini.BuildPrompt(const AData: string): string;
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
    'Here is the method(s) to be documented:' + sLineBreak + sLineBreak + AData + sLineBreak + sLineBreak +
    IfThen(FAdditionalInfo.Trim.IsEmpty, '', Format('additional information about de elements: %s ',
    [FAdditionalInfo]));
end;

constructor TDocMeAIGemini.Create(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder);
begin
  FConfig := AConfig;
  FPromptBuilder := APromptBuilder;
end;

function TDocMeAIGemini.DocumentElements(const AData, AAdditionalInfo: string): string;
begin
  FAdditionalInfo := AAdditionalInfo;

  Result := TGeminiAPI.New(FConfig.ApiKey).Gemini15Flash.Prompt(BuildPrompt(AData)).GenerateContent.Text;

  Result := FormatResponse(Result);
end;

function TDocMeAIGemini.FormatResponse(const AResponse: string): string;
begin
  Result := StringReplace(AResponse, #$A, #13#10, [rfReplaceAll]);
  Result := Result.Replace('`', '').Replace('delphi', '').Replace('{', '').Replace('}', '');
end;

class function TDocMeAIGemini.New(const AConfig: IDocMeAIConfig; const APromptBuilder: IDocMeAIPromptBuilder): IDocMeAI;
begin
  Result := Self.Create(AConfig, APromptBuilder);
end;

end.
