unit DocMe.Documentation.Process.Interfaces;

interface

type
  IDocMeAIDocumentationProcess = interface
    ['{1AFBDBFA-F9A1-449F-901E-67F27BE17BE8}']

    /// <summary>
    /// Abstractions the processing flow and may return data related to that processing.
    /// </summary>
    /// <param name="AAdditionalInfo">Optional additional information for processing.</param>
    procedure Process(const AAdditionalInfo: string = '');
  end;

implementation

end.
