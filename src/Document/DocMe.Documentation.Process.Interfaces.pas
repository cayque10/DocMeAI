unit DocMe.Documentation.Process.Interfaces;

interface

type
  IDocMeAIProcess = interface
    ['{1AFBDBFA-F9A1-449F-901E-67F27BE17BE8}']

    /// <summary>
    /// Processes the documentation with optional additional information.
    /// </summary>
    /// <param name="pAdditionalInfo">
    /// Optional additional information to be used during processing.
    /// </param>
    procedure Process(const pAdditionalInfo: string = '');
  end;

implementation

end.
