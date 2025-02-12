unit DocMe.DiffComment.Process;

interface

uses
  System.Classes,
  DocMe.Configurations.Interfaces,
  DocMe.AI.Interfaces,
  DocMe.DiffComment.Interfaces;

type
  TDocMeDiffComment = class(TInterfacedObject, IDocMeAIDiffComment)
  private
    FConfig: IDocMeAIConfig;
    FAI: IDocMeAI;
    constructor Create;
    /// <summary>
    /// Executes a Git command and returns the output as a string.
    /// </summary>
    /// <param name="ACommand">The Git command to be executed.</param>
    /// <returns>The output of the Git command as a string.</returns>
    function ExecuteGitCommand(const ACommand: string): string;

    /// <summary>
    /// Retrieves a list of modified files in the current Git repository.
    /// </summary>
    /// <returns>A TStrings object containing the names of modified files.</returns>
    function GetModifiedFiles: TStrings;

    /// <summary>
    /// Retrieves the differences between the specified file and its previous version.
    /// </summary>
    /// <param name="AFileName">The name of the file for which the differences are to be retrieved.</param>
    /// <returns>
    /// A string representing the differences found in the file.
    /// </returns>
    function GetFileDiff(const AFileName: string): string;

    /// <summary>
    /// Retrieves a list of staged files, filtered by specified extensions.
    /// </summary>
    /// <param name="AFiles">A string containing a list of staged files, separated by a delimiter (e.g., newline).</param>
    /// <param name="AExtensions">An array of file extensions to filter by (e.g., ['txt', 'log']).  Case-insensitive.</param>
    /// <returns>A TStrings object containing the list of filtered staged files.
    /// Returns nil if no matching files are found or if input is invalid.
    /// </returns >
    function GetStagedFilesFiltered(const AFiles: string; const AExtensions: array of string): TStrings;

    /// <summary>
    /// Retrieves an array of file extensions.
    /// </summary>
    /// <returns>
    /// An array of strings representing the file extensions.
    /// </returns>
    function GetExtensions: TArray<string>;

    /// <summary>
    /// Executes a command with the specified executable and parameters.
    /// </summary>
    /// <param name="AExecutable">
    /// The path to the executable file to run.
    /// </param>
    /// <param name="AParams">
    /// The parameters to pass to the executable.
    /// </param>
    /// <param name="AWorkingDir">
    /// The working directory in which to execute the command.
    /// </param>
    /// <returns>
    /// The output of the executed command as a string.
    /// </returns>
    function RunCommand(const AExecutable, AParams, AWorkingDir: string): string;
  public
    /// <summary>
    /// Creates a new instance of the IDocMeAIDiffComment interface.
    /// </summary>
    /// <returns>
    /// An instance of the IDocMeAIDiffComment interface.
    /// </returns>
    class function New: IDocMeAIDiffComment;

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

uses
  System.StrUtils,
  Winapi.Windows,
  DocMe.Configurations.Config,
  DocMe.AI.Factory,
  DocMe.AI.PromptBuilder.Types,
  System.SysUtils,
  FMX.Dialogs;

{ TDocMeDiffComment }

constructor TDocMeDiffComment.Create;
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  FAI := TDocMeAIFactory.CreateAI(FConfig, pbtDiffComment);
end;

function TDocMeDiffComment.ExecuteGitCommand(const ACommand: string): string;
var
  lFullParams: string;
  lGitExe: string;
  lRepoPath: string;
begin
  lGitExe := '';
  lRepoPath := FConfig.AIGit.ProjectPath;

  if lRepoPath.Trim.IsEmpty then
    raise Exception.Create('The project path was not found.');

  if not FConfig.AIGit.FilePath.Trim.IsEmpty then
    lGitExe := FConfig.AIGit.FilePath.Trim;

  if not FileExists(lGitExe) then
    raise Exception.Create('The git.exe file path was not found.');

  lFullParams := Format('--git-dir="%s\.git" --work-tree="%s" %s', [lRepoPath, lRepoPath, ACommand]);
  Result := RunCommand(lGitExe, lFullParams, lRepoPath);
end;

function TDocMeDiffComment.GetExtensions: TArray<string>;
var
  lExtensions: string;
  lExtensionsArray: TArray<string>;
  i: Integer;
begin
  lExtensions := FConfig.AIGit.IgnoreExtensions;
  if lExtensions.Trim.IsEmpty then
    Exit;

  lExtensionsArray := lExtensions.Split([','], TStringSplitOptions.ExcludeEmpty);

  for i := 0 to High(lExtensionsArray) do
    lExtensionsArray[i] := Trim(lExtensionsArray[i]);

  Result := lExtensionsArray;
end;

function TDocMeDiffComment.GetFileDiff(const AFileName: string): string;
begin
  Result := ExecuteGitCommand('diff HEAD ' + AFileName);
end;

function TDocMeDiffComment.GetModifiedFiles: TStrings;
var
  lOutput: string;
begin
  Result := TStringList.Create;
  lOutput := ExecuteGitCommand('diff --name-only HEAD');
  Result.Text := lOutput;
end;

function TDocMeDiffComment.GetStagedFilesFiltered(const AFiles: string; const AExtensions: array of string): TStrings;
var
  lAllFiles, lFilteredFiles: TStringList;
  i: Integer;
  lFileExt: string;
  lNotAllowed: Boolean;
  lExt: string;
begin
  Result := nil;
  lAllFiles := TStringList.Create;
  try
    lFilteredFiles := TStringList.Create;
    try
      lAllFiles.Text := AFiles;
      for i := 0 to lAllFiles.Count - 1 do
      begin
        lFileExt := LowerCase(ExtractFileExt(lAllFiles[i]));
        lNotAllowed := False;
        for lExt in AExtensions do
        begin
          if LowerCase(lExt) = lFileExt then
          begin
            lNotAllowed := True;
            Break;
          end;
        end;
        if not lNotAllowed then
          lFilteredFiles.Add(lAllFiles[i]);
      end;
      Result := lFilteredFiles;
    except
      lFilteredFiles.Free;
    end;
  finally
    lAllFiles.Free;
  end;

end;

class function TDocMeDiffComment.New: IDocMeAIDiffComment;
begin
  Result := Self.Create;
end;

function TDocMeDiffComment.Process(const AAdditionalInfo: string): string;
var
  lModifiedFiles, lStagedModifiedFiles: TStrings;
  lDiffData: string;
  lFile: string;
begin
  lModifiedFiles := GetModifiedFiles;
  try

    lStagedModifiedFiles := GetStagedFilesFiltered(lModifiedFiles.Text, GetExtensions);
    try
      if lStagedModifiedFiles.Count = 0 then
      begin
        ShowMessage('No modifications detected.');
        Abort;
      end;

      for lFile in lStagedModifiedFiles do
        lDiffData := lDiffData + GetFileDiff(lFile) + sLineBreak;

      Result := FAI.GenerateSummary(lDiffData, AAdditionalInfo);
    finally
      lStagedModifiedFiles.Free;
    end;
  finally
    lModifiedFiles.Free;
  end;
end;

function TDocMeDiffComment.RunCommand(const AExecutable, AParams, AWorkingDir: string): string;
var
  lSecurity: TSecurityAttributes;
  lHRead, lHWrite: THandle;
  lStartupInfo: TStartupInfo;
  lProcessInfo: TProcessInformation;
  lBuffer: array [0 .. 255] of AnsiChar;
  lBytesRead: Cardinal;
  lOutput: string;
  lCmdLine: string;
  lLastError: DWORD;
begin
  Result := '';
  lOutput := '';

  FillChar(lSecurity, SizeOf(lSecurity), 0);
  lSecurity.nLength := SizeOf(lSecurity);
  lSecurity.bInheritHandle := True;
  lSecurity.lpSecurityDescriptor := nil;

  if not CreatePipe(lHRead, lHWrite, @lSecurity, 0) then
    Exit('Error creating the pipe');

  try
    FillChar(lStartupInfo, SizeOf(lStartupInfo), 0);
    lStartupInfo.cb := SizeOf(lStartupInfo);
    lStartupInfo.hStdOutput := lHWrite;
    lStartupInfo.hStdError := lHWrite;
    lStartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    lStartupInfo.wShowWindow := SW_HIDE;

    lCmdLine := Format('cmd.exe /c ""%s" %s"', [AExecutable, AParams]);

    if not CreateProcess(nil, PChar(lCmdLine), nil, nil, True, CREATE_NO_WINDOW, nil, PChar(AWorkingDir), lStartupInfo,
      lProcessInfo) then
    begin
      lLastError := GetLastError;
      Result := Format('Error creating the process. Error code: %d', [lLastError]);
      Exit;
    end;

    CloseHandle(lHWrite);
    lHWrite := 0;

    while True do
    begin
      if not ReadFile(lHRead, lBuffer, SizeOf(lBuffer) - 1, lBytesRead, nil) or (lBytesRead = 0) then
        Break;
      lBuffer[lBytesRead] := #0;
      lOutput := lOutput + string(lBuffer);
    end;

    WaitForSingleObject(lProcessInfo.hProcess, INFINITE);
    CloseHandle(lProcessInfo.hProcess);
    CloseHandle(lProcessInfo.hThread);

    Result := lOutput;
  finally
    CloseHandle(lHRead);
    if lHWrite <> 0 then
      CloseHandle(lHWrite);
  end;
end;

end.
