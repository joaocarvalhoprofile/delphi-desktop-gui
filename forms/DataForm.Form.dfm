inherited DataForm_Form: TDataForm_Form
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'DataForm_Form'
  ClientHeight = 424
  ClientWidth = 629
  Position = poOwnerFormCenter
  ExplicitWidth = 635
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnl_titulo: TPanel
    Width = 629
    TabOrder = 1
    ExplicitWidth = 629
  end
  inherited StatusBar: TStatusBar
    Top = 400
    Width = 609
    ExplicitTop = 400
    ExplicitWidth = 609
  end
  object Panel2: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 348
    Width = 623
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
  end
  inherited DsrData: TDataSource
    Left = 512
    Top = 98
  end
end
