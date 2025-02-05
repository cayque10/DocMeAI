unit DocMe.AI.Interfaces;

interface

uses
  System.Generics.Collections;

type
  IAIModelsProvider = interface
    ['{98E2E2AB-1A96-4BCA-B009-A2C075110702}']
    function GetAIModelsList: TDictionary<string, TArray<string>>;
  end;

  IDocMeAI = interface
    ['{71E19B2D-34B3-4A70-8260-B1461E0384B1}']
    /// <summary>
    /// Documents the elements based on the provided data and additional information.
    /// </summary>
    /// <param name="AData">The data to be documented.</param>
    /// <param name="AAdditionalInfo">Optional additional information for documentation.</param>
    /// <returns>A string representing the documented elements.</returns>
    function DocumentElements(const AData: string; const AAdditionalInfo: string = ''): string;
  end;

implementation

end.
