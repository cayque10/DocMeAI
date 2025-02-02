object FrmDocMeConfigurations: TFrmDocMeConfigurations
  Left = 0
  Top = 0
  Caption = 'Configurations'
  ClientHeight = 313
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 411
    Height = 313
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LbSpecification: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 149
      Height = 17
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      Caption = 'API Consumption Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object PnlButton: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 268
      Width = 399
      Height = 41
      Margins.Left = 6
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object BtnSave: TButton
        Left = 275
        Top = 0
        Width = 124
        Height = 41
        Align = alRight
        Caption = 'Save'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtnSaveClick
      end
    end
    object PnlTemperature: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 224
      Width = 399
      Height = 41
      Margins.Left = 6
      Margins.Top = 10
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LbTemperature: TLabel
        Left = 0
        Top = 0
        Width = 67
        Height = 15
        Align = alTop
        Caption = 'Temperature'
      end
      object EdtTemperature: TEdit
        AlignWithMargins = True
        Left = 0
        Top = 18
        Width = 399
        Height = 20
        Margins.Left = 0
        Margins.Right = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = '0.3'
        ExplicitHeight = 21
      end
    end
    object PnlAPIKey: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 39
      Width = 399
      Height = 73
      Margins.Left = 6
      Margins.Top = 10
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object LbAPIKey: TLabel
        Left = 0
        Top = 0
        Width = 40
        Height = 15
        Align = alTop
        Caption = 'API Key'
      end
      object MemAPIKey: TMemo
        AlignWithMargins = True
        Left = 0
        Top = 18
        Width = 399
        Height = 55
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object PnlModel: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 122
      Width = 399
      Height = 41
      Margins.Left = 6
      Margins.Top = 10
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object LbModel: TLabel
        Left = 0
        Top = 0
        Width = 34
        Height = 15
        Align = alTop
        Caption = 'Model'
      end
      object EdtModel: TEdit
        AlignWithMargins = True
        Left = 0
        Top = 18
        Width = 399
        Height = 20
        Margins.Left = 0
        Margins.Right = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = 'gpt-4o-mini'
        ExplicitHeight = 21
      end
    end
    object PnlMaxToken: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 173
      Width = 399
      Height = 41
      Margins.Left = 6
      Margins.Top = 10
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      object LbMaxToken: TLabel
        Left = 0
        Top = 0
        Width = 57
        Height = 15
        Align = alTop
        Caption = 'Max Token'
      end
      object EdtMaxToken: TEdit
        AlignWithMargins = True
        Left = 0
        Top = 18
        Width = 399
        Height = 20
        Margins.Left = 0
        Margins.Right = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = '2048'
        ExplicitHeight = 21
      end
    end
  end
end
