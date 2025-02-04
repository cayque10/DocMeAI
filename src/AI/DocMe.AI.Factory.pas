unit DocMe.AI.Factory;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces,
  DocMe.AI.ProviderTypes;

type

  TDocMeAIFactory = class
  private
  public
    /// <summary>
    /// Creates an instance of the AI using the provided configuration.
    /// </summary>
    /// <param name="pConfig">An instance of <see cref="IDocMeAIConfig"/> that contains the configuration for the AI.</param>
    /// <returns>An instance of <see cref="IDocMeAI"/> representing the created AI.</returns>
    class function CreateAI(const pConfig: IDocMeAIConfig): IDocMeAI;
  end;

implementation

uses
  System.SysUtils,
  DocMe.AI.ChatGPT,
  DocMe.AI.Gemini,
  DocMe.AI.DeepSeek;

{ TDocMeAIFactory }

class function TDocMeAIFactory.CreateAI(const pConfig: IDocMeAIConfig): IDocMeAI;
begin
  case Ord(pConfig.AIProviderType) of
    Ord(aiChatGPT):
      Result := TDocMeAIChatGPT.New(pConfig);
    Ord(aiGemini):
      Result := TDocMeAIGemini.New(pConfig);
    Ord(aiDeepSeek):
      Result := TDocMeAIDeepSeek.New(pConfig);
  else
    raise Exception.Create('AI type not supported.');
  end;
end;

end.
