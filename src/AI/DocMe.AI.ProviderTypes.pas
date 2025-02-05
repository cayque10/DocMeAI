unit DocMe.AI.ProviderTypes;

interface

uses
  System.Generics.Collections,
  DocMe.AI.Interfaces;

type
  /// <summary>
  /// Enumeration representing the different types of AI providers.
  /// </summary>
  TDocMeAIProviderType = (aiChatGPT, aiGemini, aiDeepSeek);

  TAIModelsProvider = class(TInterfacedObject, IAIModelsProvider)
  private
    FAIModels: TDictionary<string, TArray<string>>;
    constructor Create;
  public
    class function New: IAIModelsProvider;
    destructor Destroy; override;
    function GetAIModelsList: TDictionary<string, TArray<string>>;
  end;

const
  DOCME_AI_PROVIDER_NAMES_TYPE: array [TDocMeAIProviderType] of string = ('ChatGPT', 'Gemini', 'DeepSeek');

implementation

{ TAIModelsProvider }

constructor TAIModelsProvider.Create;
begin
  FAIModels := TDictionary <string, TArray<string>>.Create;
  FAIModels.Add('ChatGPT', ['gpt-4o', 'gpt-4o-mini', 'o1', 'o1-mini', 'o3-mini']);
  FAIModels.Add('Gemini', ['gemini-1.5-flash', 'gemini-1.5-flash-8b', 'gemini-1.5-pro', 'gemini-2.0-flash-exp']);
  FAIModels.Add('DeepSeek', ['deepseek-chat', 'deepseek-reasoner']);
end;

destructor TAIModelsProvider.Destroy;
begin
  FAIModels.Free;
  inherited;
end;

function TAIModelsProvider.GetAIModelsList: TDictionary<string, TArray<string>>;
begin
  Result := FAIModels;
end;

class function TAIModelsProvider.New: IAIModelsProvider;
begin
  Result := Self.Create;
end;

end.
