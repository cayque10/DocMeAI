unit DocMe.IDE.ActiveProject.Interfaces;

interface

type
  IDocMeActiveProjectPath = interface
    ['{7B3A8E1D-4C2F-4A6E-9B1A-2F5C8D6E9A10}']
    /// <summary>
    /// Retrieves the directory of the project currently active in the IDE.
    /// </summary>
    /// <returns>
    /// The active project's directory, or an empty string if no project is open
    /// or the code is not running inside the IDE.
    /// </returns>
    function GetActiveProjectPath: string;
  end;

implementation

end.
