unit DocMe.DiffComment.Interfaces;

interface

type
  IDocMeAIDiffComment = interface
    ['{1AFBDBFA-F9A1-449F-901E-67F27BE17BE8}']

    /// <summary>
    /// Abstractions the processing flow and may return data related to that processing.
    /// </summary>
    /// <param name="AAdditionalInfo">Optional additional information for processing.</param>
    /// <returns>
    /// A string containing the result of the processing.
    /// </returns>
    function Process(const AAdditionalInfo: string = ''): string;
  end;

implementation

end.
