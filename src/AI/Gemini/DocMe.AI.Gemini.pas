unit DocMe.AI.Gemini;

interface

uses
  DocMe.AI.Interfaces,
  DocMe.Configurations.Interfaces;

type
  TDocMeAIGemini= class(TInterfacedObject, IDocMeAI)
  private
    FConfig: IDocMeAIConfig;
    FAdditionalInfo: string;

    /// <summary>
    /// Initializes a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the instance.</param>
    constructor Create(const pConfig: IDocMeAIConfig);

    /// <summary>
    /// Builds a prompt based on the provided data.
    /// </summary>
    /// <param name="pData">The data to be used for building the prompt.</param>
    /// <returns>A string representing the built prompt.</returns>
    function BuildPrompt(const pData: string): string;

    /// <summary>
    /// Formats the response string.
    /// </summary>
    /// <param name="pResponse">The response string to be formatted.</param>
    /// <returns>A string representing the formatted response.</returns>
    function FormatResponse(const pResponse: string): string;
  protected
  public
    /// <summary>
    /// Creates a new instance of the class with the specified configuration.
    /// </summary>
    /// <param name="pConfig">The configuration to be used for the new instance.</param>
    /// <returns>An instance of IDocMeAI.</returns>
    class function New(const pConfig: IDocMeAIConfig): IDocMeAI;

    /// <summary>
    /// Documents the elements based on the provided data and additional information.
    /// </summary>
    /// <param name="pData">The data to be documented.</param>
    /// <param name="pAdditionalInfo">Optional additional information for documentation.</param>
    /// <returns>A string representing the documented elements.</returns>
    function DocumentElements(const pData: string; const pAdditionalInfo: string = ''): string;
  end;

implementation

{ TDocMeAIGemini }

function TDocMeAIGemini.BuildPrompt(const pData: string): string;
begin

end;

constructor TDocMeAIGemini.Create(const pConfig: IDocMeAIConfig);
begin

end;

function TDocMeAIGemini.DocumentElements(const pData, pAdditionalInfo: string): string;
begin

end;

function TDocMeAIGemini.FormatResponse(const pResponse: string): string;
begin

end;

class function TDocMeAIGemini.New(const pConfig: IDocMeAIConfig): IDocMeAI;
begin
  Result := Self.Create(pConfig);
end;

end.
