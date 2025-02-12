unit DocMe.AI.Interfaces;

interface

uses
  System.Generics.Collections;

type
  IAIModelsProvider = interface
    ['{98E2E2AB-1A96-4BCA-B009-A2C075110702}']
    /// <summary>
    /// Retrieves a list of AI models.
    /// </summary>
    /// <returns>
    /// A dictionary where the key is a string representing the model name,
    /// and the value is an array of strings representing the associated model details.
    /// </returns>
    function GetAIModelsList: TDictionary<string, TArray<string>>;
  end;

  IDocMeAI = interface
    ['{71E19B2D-34B3-4A70-8260-B1461E0384B1}']
    /// <summary>
    /// Generates a summary based on the provided data and additional information.
    /// </summary>
    /// <param name="AData">The main data used to create the summary.</param>
    /// <param name="AAdditionalInfo">Optional additional information to include in the summary.</param>
    /// <returns>
    /// A string representing the generated summary.
    /// </returns>
    function GenerateSummary(const AData: string; const AAdditionalInfo: string = ''): string;
  end;

implementation

end.
