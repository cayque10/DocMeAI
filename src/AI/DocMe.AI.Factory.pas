unit DocMe.AI.Factory;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces,
  DocMe.AI.ProviderTypes,
  DocMe.AI.PromptBuilder.Types;

type

  TDocMeAIFactory = class
  private
  public
    /// <summary>
    /// Creates an instance of the AI using the provided configuration.
    /// </summary>
    /// <param name="AConfig">An instance of <see cref="IDocMeAIConfig"/> that contains the configuration for the AI.</param>
    /// <returns>An instance of <see cref="IDocMeAI"/> representing the created AI.</returns>
    class function CreateAI(const AConfig: IDocMeAIConfig; const ABuilderType: TDocMeAIPromptBuilderTypes): IDocMeAI;
  end;

implementation

uses
  System.SysUtils,
  DocMe.AI.ChatGPT,
  DocMe.AI.Gemini,
  DocMe.AI.DeepSeek,
  DocMe.AI.PromptBuilder.Documentation,
  DocMe.AI.PromptBuilder.DiffComment,
  DocMe.AI.PromptBuilder.Interfaces;

{ TDocMeAIFactory }

class function TDocMeAIFactory.CreateAI(const AConfig: IDocMeAIConfig; const ABuilderType: TDocMeAIPromptBuilderTypes)
  : IDocMeAI;
var
  lPromptBuilder: IDocMeAIPromptBuilder;
begin
  case ABuilderType of
    pbtDocumentation:
      lPromptBuilder := TDocMeAIPromptBuilderDocumentation.New;
    pbtDiffComment:
      lPromptBuilder := TDocMeAIPromptBuilderDiffComment.New;
  else
    raise Exception.Create('Prompt Builder not supported.');
  end;

  case Ord(AConfig.AIProviderType) of
    Ord(aiChatGPT):
      Result := TDocMeAIChatGPT.New(AConfig, lPromptBuilder);
    Ord(aiGemini):
      Result := TDocMeAIGemini.New(AConfig, lPromptBuilder);
    Ord(aiDeepSeek):
      Result := TDocMeAIDeepSeek.New(AConfig, lPromptBuilder);
  else
    raise Exception.Create('AI type not supported.');
  end;
end;

end.
