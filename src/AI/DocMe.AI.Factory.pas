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
  case pConfig.AIProviderType of
    aiChatGPT:
      Result := TDocMeAIChatGPT.New(pConfig);
    aiGemini:
      Result := TDocMeAIGemini.New(pConfig);
    aiDeepSeek:
      Result := TDocMeAIDeepSeek.New(pConfig);
  else
    raise Exception.Create('AI type not supported.');
  end;
end;

end.
