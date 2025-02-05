unit Utils.Forms.Interfaces;

interface

uses
  System.Generics.Collections,
  FMX.Types;

type
  ILoading = interface

  /// <summary>
  /// Displays a loading indicator with the specified message.
  /// </summary>
  /// <param name="AOwner">The owner of the loading indicator, represented as a <see cref="TFmxObject"/>.</param>
  /// <param name="AMessage">The message to be displayed alongside the loading indicator.</param>
  /// <returns>An instance of <see cref="ILoading"/> representing the loading indicator.</returns>
  function Show(const AOwner: TFmxObject; const AMessage: string): ILoading;

  /// <summary>
  /// Hides the currently displayed loading indicator.
  /// </summary>
  /// <returns>An instance of <see cref="ILoading"/> representing the loading indicator after it has been hidden.</returns>
  function Hide: ILoading;

  end;

implementation

end.
