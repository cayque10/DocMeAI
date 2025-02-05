{
  Classe responsável por efetuar execução de determinada tarefa sem travar a aplicação,
  além de permitir que outra ação paralela à execução principal.

  Obs.: Caso for utilizar essa classe, qualquer método que não seja Thread-Safe, deverá usar o
  TThread.Synchronize ao efetuar a chamada aos método Run e aos eventos OnStartCustomTask,
  OnFinishCustomTask, OnErrorCustomTask.

  Cayque D.
  15/04/2022

}

unit Utils.CustomTask;

interface

uses
  System.Threading,
  System.Classes,
  System.SysUtils,
  Utils.CustomTask.Interfaces,
  Utils.Resource.Strings;

type
  TCustomTask = class(TInterfacedObject, ICustomTask)
  private
    FTask: Array of ITask;
    FOnRun: TProc;
    FOnStartCustomTask: TProc;
    FOnFinishCustomTask: TProc;
    FOnErrorCustomTask: TProc<String>;
    constructor Create;
  public
    class function New: ICustomTask;
    destructor Destroy; override;

    /// <summary>
    /// Initiates a custom task with the specified procedure.
    /// </summary>
    /// <param name="AProc">The procedure to execute when the task starts.</param>
    /// <returns>
    /// An instance of <see cref="ICustomTask"/> representing the custom task.
    /// </returns>
    function OnStartCustomTask(const AProc: TProc): ICustomTask;

    /// <summary>
    /// Finalizes a custom task with the specified procedure.
    /// </summary>
    /// <param name="AProc">The procedure to execute when the task finishes.</param>
    /// <returns>
    /// An instance of <see cref="ICustomTask"/> representing the custom task.
    /// </returns>
    function OnFinishCustomTask(const AProc: TProc): ICustomTask;

    /// <summary>
    /// Handles an error during a custom task with the specified procedure.
    /// </summary>
    /// <param name="AProc">The procedure to execute when an error occurs, receiving an error message as a parameter.</param>
    /// <returns>
    /// An instance of <see cref="ICustomTask"/> representing the custom task.
    /// </returns>
    function OnErrorCustomTask(const AProc: TProc<String>): ICustomTask;

    /// <summary>
    /// Executes a custom task with the specified procedure.
    /// </summary>
    /// <param name="AProc">The procedure to execute during the task run.</param>
    /// <returns>
    /// An instance of <see cref="ICustomTask"/> representing the custom task.
    /// </returns>
    function OnRun(const AProc: TProc): ICustomTask;

    /// <summary>
    /// Runs the custom task.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="ICustomTask"/> representing the custom task.
    /// </returns>
    function Run: ICustomTask;
  end;

  TCustomThread = class(TThread)
  private
    FRunProc: TProc;
    FStartProc: TProc;
    FFinishProc: TProc;
    FErrorProc: TProc<String>;
    FCustomTask: ICustomTask;
    procedure InitializeCustomTask;
  protected
    procedure Execute; override;
  public
    constructor Create(const ACreateSuspended: Boolean = True; const AFreeOnTerminate: Boolean = False); overload;
    destructor Destroy; override;

    /// <summary>
    /// Executes the specified procedure when the thread runs.
    /// </summary>
    /// <param name="ARunProc">
    /// The procedure to execute when the thread starts running.
    /// </param>
    /// <returns>
    /// A TCustomThread instance representing the thread.
    /// </returns>
    function OnRun(const ARunProc: TProc): TCustomThread;

    /// <summary>
    /// Executes the specified procedure when the thread starts.
    /// </summary>
    /// <param name="AStartProc">
    /// The procedure to execute when the thread starts.
    /// </param>
    /// <returns>
    /// A TCustomThread instance representing the thread.
    /// </returns>
    function OnStart(const AStartProc: TProc): TCustomThread;

    /// <summary>
    /// Executes the specified procedure when the thread finishes.
    /// </summary>
    /// <param name="AFinishProc">
    /// The procedure to execute when the thread finishes.
    /// </param>
    /// <returns>
    /// A TCustomThread instance representing the thread.
    /// </returns>
    function OnFinish(const AFinishProc: TProc): TCustomThread;

    /// <summary>
    /// Executes the specified procedure when an error occurs in the thread.
    /// </summary>
    /// <param name="AErrorProc">
    /// The procedure to execute when an error occurs, with a string parameter for error details.
    /// </param>
    /// <returns>
    /// A TCustomThread instance representing the thread.
    /// </returns>
    function OnError(const AErrorProc: TProc<String>): TCustomThread;

    /// <summary>
    /// Sets a custom event handler for when the thread terminates.
    /// </summary>
    /// <param name="AEvent">
    /// The event handler to execute when the thread terminates.
    /// </param>
    /// <returns>
    /// A TCustomThread instance representing the thread.
    /// </returns>
    function OnTerminateCustom(const AEvent: TNotifyEvent): TCustomThread;

  end;

implementation

{ TCustomTask }

constructor TCustomTask.Create;
begin
  SetLength(FTask, 2);
end;

destructor TCustomTask.Destroy;
begin
  inherited;
end;

class function TCustomTask.New: ICustomTask;
begin
  Result := TCustomTask.Create;
end;

function TCustomTask.OnErrorCustomTask(const AProc: TProc<String>): ICustomTask;
begin
  Result := Self;
  FOnErrorCustomTask := AProc;
end;

function TCustomTask.OnFinishCustomTask(const AProc: TProc): ICustomTask;
begin
  Result := Self;
  FOnFinishCustomTask := AProc;
end;

function TCustomTask.OnStartCustomTask(const AProc: TProc): ICustomTask;
begin
  Result := Self;
  FOnStartCustomTask := AProc;
end;

function TCustomTask.Run: ICustomTask;
var
  LError: String;
begin
  Result := Self;
  LError := SUnableToCompleteRequest;

  if not Assigned(FOnRun) then
  begin
    try
      if Assigned(FOnErrorCustomTask) then
        FOnErrorCustomTask(STheMethodRunIsNotInitialized);
    finally
      raise Exception.Create(STheMethodRunIsNotInitialized);
    end;
  end;

  FTask[0] := TTask.Run(
    procedure
    begin
      FOnRun;
    end);

  FTask[1] := TTask.Run(
    procedure
    begin
      if Assigned(FOnStartCustomTask) then
        FOnStartCustomTask;
    end);

  try
    TTask.WaitForAll(FTask);

    if Assigned(FOnFinishCustomTask) then
      FOnFinishCustomTask;
  except
    on E: EAggregateException do
    begin
      if (E.Count > 0) and Assigned(E[0]) and Assigned(E.InnerExceptions[0]) and not(E.InnerExceptions[0] is EAbort)
      then
        LError := E[0].toString;

      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          if not Assigned(FOnErrorCustomTask) then
            raise Exception.Create(LError)
          else
            FOnErrorCustomTask(LError);
        end)
    end;
  end;
end;

function TCustomTask.OnRun(const AProc: TProc): ICustomTask;
begin
  Result := Self;
  FOnRun := AProc;
end;

{ TCustomThread }

constructor TCustomThread.Create(const ACreateSuspended: Boolean; const AFreeOnTerminate: Boolean);
begin
  inherited Create(ACreateSuspended);
  FreeOnTerminate := AFreeOnTerminate;
end;

destructor TCustomThread.Destroy;
begin

  inherited;
end;

procedure TCustomThread.Execute;
begin
  inherited;
  InitializeCustomTask;
  FCustomTask.Run;
end;

procedure TCustomThread.InitializeCustomTask;
begin
  FCustomTask := TCustomTask.New;
  FCustomTask.OnRun(FRunProc);
  FCustomTask.OnStartCustomTask(FStartProc);
  FCustomTask.OnFinishCustomTask(FFinishProc);
  FCustomTask.OnErrorCustomTask(FErrorProc);
end;

function TCustomThread.OnError(const AErrorProc: TProc<String>): TCustomThread;
begin
  Result := Self;
  FErrorProc := AErrorProc;
end;

function TCustomThread.OnFinish(const AFinishProc: TProc): TCustomThread;
begin
  Result := Self;
  FFinishProc := AFinishProc;
end;

function TCustomThread.OnRun(const ARunProc: TProc): TCustomThread;
begin
  Result := Self;
  FRunProc := ARunProc;
end;

function TCustomThread.OnStart(const AStartProc: TProc): TCustomThread;
begin
  Result := Self;
  FStartProc := AStartProc;
end;

function TCustomThread.OnTerminateCustom(const AEvent: TNotifyEvent): TCustomThread;
begin
  Result := Self;
  Self.OnTerminate := AEvent;
end;

end.
