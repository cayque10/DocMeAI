unit Utils.CustomTask.Wrapper;

interface

uses
  System.Classes,
  System.SysUtils,
  Utils.CustomTask,
  Utils.CustomTask.Interfaces;

type
  TCustomThreadWrapper = class(TInterfacedObject, ICustomThread)
  private
    FCustomThread: TCustomThread;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Executes the specified procedure when the thread runs.
    /// </summary>
    /// <param name="ARunProc">
    /// The procedure to execute on thread run.
    /// </param>
    /// <returns>
    /// An instance of ICustomThread.
    /// </returns>
    function OnRun(const ARunProc: TProc): ICustomThread;

    /// <summary>
    /// Executes the specified procedure when the thread starts.
    /// </summary>
    /// <param name="AStartProc">
    /// The procedure to execute on thread start.
    /// </param>
    /// <returns>
    /// An instance of ICustomThread.
    /// </returns>
    function OnStart(const AStartProc: TProc): ICustomThread;

    /// <summary>
    /// Executes the specified procedure when the thread finishes.
    /// </summary>
    /// <param name="AFinishProc">
    /// The procedure to execute on thread finish.
    /// </param>
    /// <returns>
    /// An instance of ICustomThread.
    /// </returns>
    function OnFinish(const AFinishProc: TProc): ICustomThread;

    /// <summary>
    /// Executes the specified procedure when an error occurs in the thread.
    /// </summary>
    /// <param name="AErrorProc">
    /// The procedure to execute on thread error, which receives an error message as a string.
    /// </param>
    /// <returns>
    /// An instance of ICustomThread.
    /// </returns>
    function OnError(const AErrorProc: TProc<String>): ICustomThread;

    /// <summary>
    /// Sets a custom event handler to be called when the thread terminates.
    /// </summary>
    /// <param name="AEvent">
    /// The event handler to execute on thread termination.
    /// </param>
    /// <returns>
    /// An instance of ICustomThread.
    /// </returns>
    function OnTerminateCustom(const AEvent: TNotifyEvent): ICustomThread;

    /// <summary>
    /// Starts the execution of the thread.
    /// </summary>
    procedure Start;
  end;

implementation

{ TCustomThreadWrapper }

constructor TCustomThreadWrapper.Create;
begin
  FCustomThread := TCustomThread.Create(True, True);
end;

destructor TCustomThreadWrapper.Destroy;
begin
  inherited;
end;

function TCustomThreadWrapper.OnRun(const ARunProc: TProc): ICustomThread;
begin
  FCustomThread.OnRun(ARunProc);
  Result := Self;
end;

function TCustomThreadWrapper.OnStart(const AStartProc: TProc): ICustomThread;
begin
  FCustomThread.OnStart(AStartProc);
  Result := Self;
end;

function TCustomThreadWrapper.OnFinish(const AFinishProc: TProc): ICustomThread;
begin
  FCustomThread.OnFinish(AFinishProc);
  Result := Self;
end;

function TCustomThreadWrapper.OnError(const AErrorProc: TProc<string>): ICustomThread;
begin
  FCustomThread.OnError(AErrorProc);
  Result := Self;
end;

function TCustomThreadWrapper.OnTerminateCustom(const AEvent: TNotifyEvent): ICustomThread;
begin
  FCustomThread.OnTerminateCustom(AEvent);
  Result := Self;
end;

procedure TCustomThreadWrapper.Start;
begin
  FCustomThread.Start;
end;

end.
