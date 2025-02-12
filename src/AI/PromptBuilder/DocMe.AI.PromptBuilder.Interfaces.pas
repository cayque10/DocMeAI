unit DocMe.AI.PromptBuilder.Interfaces;

interface

type
  IDocMeAIPromptBuilder = interface
    ['{9BB2AC6F-267D-40FF-B047-7103558BA5E3}']
    function BuildPrompt(const AData, AAdditionalInfo: string): string;
  end;

implementation

end.
