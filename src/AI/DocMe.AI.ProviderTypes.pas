unit DocMe.AI.ProviderTypes;

interface

type
  TDocMeAIProviderType = (aiChatGPT, aiGemini, aiDeepSeek);

const
  DOCME_AI_PROVIDER_NAMES_TYPE: array [TDocMeAIProviderType] of string = ('ChatGPT', 'Gemini', 'DeepSeek');

implementation

end.
