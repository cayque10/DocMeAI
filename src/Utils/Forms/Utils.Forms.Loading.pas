unit Utils.Forms.Loading;

interface

uses System.SysUtils,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Layouts,
  FMX.Forms,
  FMX.Graphics,
  FMX.Ani,
  FMX.VirtualKeyboard,
  FMX.Platform,
  System.Classes,
  Utils.Forms.Interfaces;

type
  TUtilsFormsLoading = class(TInterfacedObject, ILoading)
  private
    FLayout: TLayout;
    FBackground: TRectangle;
    FMessageBackground: TRectangle;
    FArc: TArc;
    FMessage: TLabel;
    FAnimation: TFloatAnimation;
    constructor Create;
  public
    /// <summary>
    /// Creates a new instance of an object that implements the ILoading interface.
    /// </summary>
    /// <returns>
    /// An instance of a class that implements the <see cref="ILoading"/> interface.
    /// </returns>
    class function New: ILoading;

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

{ TUtilsFormsLoading }

constructor TUtilsFormsLoading.Create;
begin

end;

function TUtilsFormsLoading.Hide: ILoading;
begin
  Result := Self;
  if Assigned(FBackground) then
    FBackground.Free;

  FMessage := nil;
  FAnimation := nil;
  FMessageBackground := nil;
  FArc := nil;
  FLayout := nil;
  FBackground := nil;
end;

class function TUtilsFormsLoading.New: ILoading;
begin
  Result := TUtilsFormsLoading.Create;
end;

function TUtilsFormsLoading.Show(const AOwner: TFmxObject; const AMessage: string): ILoading;
var
  FService: IFMXVirtualKeyboardService;
begin
  Result := Self;

  FBackground := TRectangle.Create(AOwner);
  FBackground.Opacity := 1;
  FBackground.Parent := AOwner;
  FBackground.Visible := true;
  FBackground.Align := TAlignLayout.Contents;
  FBackground.Fill.Color := $FFEAEAEA;
  FBackground.Fill.Kind := TBrushKind.Solid;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.Visible := true;
  FMX.Ani.TAnimator.AnimateFloat(FBackground, 'Opacity', 0.5, 0.2);

  FMessageBackground := TRectangle.Create(FBackground);
  FMessageBackground.Opacity := 1;
  FMessageBackground.Parent := AOwner;
  FMessageBackground.Visible := true;
  FMessageBackground.Width := 200;
  FMessageBackground.Height := 78;
  FMessageBackground.Align := TAlignLayout.Center;
  FMessageBackground.Fill.Color := $FFFFFFFF;
  FMessageBackground.Fill.Kind := TBrushKind.Solid;
  FMessageBackground.Stroke.Kind := TBrushKind.None;
  FMessageBackground.Visible := true;
  FMessageBackground.XRadius := 14;
  FMessageBackground.YRadius := 14;

  FLayout := TLayout.Create(FBackground);
  FLayout.Opacity := 0;
  FLayout.Parent := FMessageBackground;
  FLayout.Visible := true;
  FLayout.Align := TAlignLayout.Contents;
  FLayout.Width := 250;
  FLayout.Height := 78;
  FLayout.Visible := true;
  FMX.Ani.TAnimator.AnimateFloat(FLayout, 'Opacity', 1);

  FArc := TArc.Create(FBackground);
  FArc.Visible := true;
  FArc.Parent := FLayout;
  FArc.Align := TAlignLayout.Center;
  FArc.Margins.Bottom := 40;
  FArc.Width := 20;
  FArc.Height := 20;
  FArc.EndAngle := 280;
  FArc.Stroke.Color := $FF252525;
  FArc.Fill.Color := $FF252525;
  FArc.Stroke.Thickness := 2;
  FArc.Position.X := trunc((FLayout.Width - FArc.Width) / 2);
  FArc.Position.Y := 10;

  FAnimation := TFloatAnimation.Create(FBackground);
  FAnimation.Parent := FArc;
  FAnimation.StartValue := 0;
  FAnimation.StopValue := 360;
  FAnimation.Duration := 0.8;
  FAnimation.Loop := true;
  FAnimation.PropertyName := 'RotationAngle';
  FAnimation.AnimationType := TAnimationType.InOut;
  FAnimation.Interpolation := TInterpolationType.Linear;
  FAnimation.Start;

  FMessage := TLabel.Create(FBackground);
  FMessage.Parent := FLayout;
  FMessage.Align := TAlignLayout.Center;
  FMessage.Margins.Top := 70;
  FMessage.Font.Size := 13;
  FMessage.TextSettings.Font.Style := [TFontStyle.fsBold];
  FMessage.Height := 70;
  FMessage.Width := 400;
  FMessage.FontColor := $FF383838;
  FMessage.TextSettings.HorzAlign := TTextAlign.Center;
  FMessage.TextSettings.VertAlign := TTextAlign.Leading;
  FMessage.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  FMessage.Text := AMessage;
  FMessage.VertTextAlign := TTextAlign.Leading;
  FMessage.Trimming := TTextTrimming.None;
  FMessage.TabStop := false;
  FMessage.SetFocus;

  FLayout.BringToFront;

  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
  end;
  FService := nil;
end;

end.
