unit DocMe.AI.PromptBuilder.DiffComment;

interface

uses
  DocMe.AI.PromptBuilder.Interfaces;

type

  TDocMeAIPromptBuilderDiffComment = class(TInterfacedObject, IDocMeAIPromptBuilder)
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

{ TDocMeAIPromptBuilderDiffComment }

function TDocMeAIPromptBuilderDiffComment.BuildPrompt(const AData, AAdditionalInfo: string): string;
begin
  Result := 'Review the following Git diff and, for each changed file, provide a concise plain-text summary of the' +
    ' key functional and structural modifications. ' +
    'For each file, first output the file name on a separate line, then list the changes below, one per line. ' +
    'Do not use any markdown formatting symbols (e.g., "#", "**", "`"). ' +
    'Exclude minor visual or cosmetic adjustments and focus only on significant changes. ' +
    'Keep the summary clear and brief.' + sLineBreak + AData;
end;

constructor TDocMeAIPromptBuilderDiffComment.Create;
begin

end;

class function TDocMeAIPromptBuilderDiffComment.New: IDocMeAIPromptBuilder;
begin
  Result := Self.Create;
end;

end.
