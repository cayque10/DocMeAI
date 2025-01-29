object FrmDocMeDocumentation: TFrmDocMeDocumentation
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Documentation'
  ClientHeight = 311
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object PnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 411
    Height = 311
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LbSpecification: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 399
      Height = 17
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      Caption = 
        'Specify any additional information to be used in the documentati' +
        'on'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 392
    end
    object MemAdditionalInfo: TMemo
      AlignWithMargins = True
      Left = 6
      Top = 35
      Width = 399
      Height = 220
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
    end
    object PnlButton: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 264
      Width = 399
      Height = 41
      Margins.Left = 6
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object BtnDocument: TButton
        Left = 275
        Top = 0
        Width = 124
        Height = 41
        Align = alRight
        Caption = 'Document'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtnDocumentClick
      end
    end
  end
end
