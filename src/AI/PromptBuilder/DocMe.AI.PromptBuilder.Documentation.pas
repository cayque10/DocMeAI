unit DocMe.AI.PromptBuilder.Documentation;

interface

uses
  DocMe.AI.PromptBuilder.Interfaces;

type

  TDocMeAIPromptBuilderDocumentation = class(TInterfacedObject, IDocMeAIPromptBuilder)
  private
    constructor Create;
  public
    class function New: IDocMeAIPromptBuilder;
    function BuildPrompt(const AData, AAdditionalInfo: string): string;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils;

{ TDocMeAIPromptBuilderDocumentation }

function TDocMeAIPromptBuilderDocumentation.BuildPrompt(const AData, AAdditionalInfo: string): string;
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
    IfThen(AAdditionalInfo.Trim.IsEmpty, '', Format('additional information about de elements: %s ',
    [AAdditionalInfo]));
end;

constructor TDocMeAIPromptBuilderDocumentation.Create;
begin

end;

class function TDocMeAIPromptBuilderDocumentation.New: IDocMeAIPromptBuilder;
begin
  Result := Self.Create;
end;

end.
