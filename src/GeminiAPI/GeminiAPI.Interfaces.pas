unit GeminiAPI.Interfaces;

interface

uses
  GeminiAPI.GenerativeModels;

type
  IGeminiResponse = interface
    ['{8B414A68-DF39-4287-A950-6669A2B2CD88}']
    function Content: string;
    function Text: string;
  end;

  IGeminiAPI = interface
    ['{A67F1327-E54F-40F7-956A-7063214D1A99}']
    function GenerativeModel(const AModel: TGeminiModel): IGeminiAPI;
    function Prompt(const AValue: string): IGeminiAPI;
    function Gemini15Pro: IGeminiAPI;
    function Gemini15Flash8B: IGeminiAPI;
    function Gemini15Flash: IGeminiAPI;
    function Gemini20Flash: IGeminiAPI;
    function GenerateContent: IGeminiResponse;
  end;

implementation

end.
