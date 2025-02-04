unit DocMe.AI.ProviderTypes;

interface

type
  /// <summary>
  /// Enumeration representing the different types of AI providers.
  /// </summary>
  TDocMeAIProviderType = (aiChatGPT, aiGemini, aiDeepSeek);

const
  DOCME_AI_PROVIDER_NAMES_TYPE: array [TDocMeAIProviderType] of string = ('ChatGPT', 'Gemini', 'DeepSeek');

implementation

end.
