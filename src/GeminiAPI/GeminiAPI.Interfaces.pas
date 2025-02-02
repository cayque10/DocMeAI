unit GeminiAPI.Interfaces;

interface

uses
  GeminiAPI.GenerativeModels;

type
  IGeminiAPI = interface
    ['{A67F1327-E54F-40F7-956A-7063214D1A99}']
    function GenerativeModel(const AModel: TGeminiModel): IGeminiAPI;
    function Prompt(const AValue: string): IGeminiAPI;
    function Gemini15Pro: IGeminiAPI;
    function Gemini15Flash8B: IGeminiAPI;
    function Gemini15Flash: IGeminiAPI;
    function Gemini20Flash: IGeminiAPI;
    function GenerateContent: string;
  end;

implementation

end.
