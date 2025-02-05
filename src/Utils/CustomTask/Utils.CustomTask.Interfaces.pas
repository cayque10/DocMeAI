unit Utils.CustomTask.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Threading;

type
  ICustomTask = interface
    ['{51CDE125-67B3-4E53-B96A-9793BAEC689A}']

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

  ICustomThread = interface
    ['{7127AF86-16A4-4237-886E-E2D655752365}']

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

end.
