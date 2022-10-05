object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Calculate SHA-512 in parallel in Golang'
  ClientHeight = 889
  ClientWidth = 1254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 192
  DesignSize = (
    1254
    889)
  TextHeight = 32
  object Label1: TLabel
    Left = 11
    Top = 22
    Width = 102
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Directory:'
  end
  object dirLabel: TLabel
    Left = 163
    Top = 22
    Width = 897
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'not selected'
    Color = clWindow
    ParentColor = False
    Transparent = False
    Layout = tlCenter
  end
  object calcLabel: TLabel
    Left = 17
    Top = 810
    Width = 529
    Height = 45
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akLeft, akBottom]
    Caption = 'Calculating SHA-512. Please wait ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object selectButton: TButton
    Left = 1104
    Top = 15
    Width = 129
    Height = 49
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Select'
    TabOrder = 0
    OnClick = selectButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 66
    Width = 1232
    Height = 735
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Directory contents'
    TabOrder = 1
    DesignSize = (
      1232
      735)
    object filesGrid: TStringGrid
      Left = 6
      Top = 48
      Width = 1220
      Height = 681
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColCount = 2
      DefaultColWidth = 128
      DefaultRowHeight = 48
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goFixedRowDefAlign]
      TabOrder = 0
    end
  end
  object calcButton: TButton
    Left = 755
    Top = 813
    Width = 289
    Height = 49
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akRight, akBottom]
    Caption = 'Calculate SHA-512'
    TabOrder = 2
    OnClick = calcButtonClick
  end
  object quitButton: TButton
    Left = 1056
    Top = 813
    Width = 177
    Height = 49
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akRight, akBottom]
    Caption = 'Quit'
    TabOrder = 3
    OnClick = quitButtonClick
  end
end
