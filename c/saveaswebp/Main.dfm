object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Save as WebP'
  ClientHeight = 818
  ClientWidth = 1228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 192
  DesignSize = (
    1228
    818)
  TextHeight = 32
  object Label1: TLabel
    Left = 928
    Top = 240
    Width = 213
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akLeft, akTop, akRight]
    Caption = 'WebP quality factor:'
  end
  object Label2: TLabel
    Left = 896
    Top = 381
    Width = 40
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akTop, akRight]
    Caption = 'size'
  end
  object Label3: TLabel
    Left = 1145
    Top = 381
    Width = 72
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akTop, akRight]
    Caption = 'quality'
  end
  object encodingLabel: TLabel
    Left = 880
    Top = 480
    Width = 337
    Height = 65
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Alignment = taCenter
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Encoding image.'#13#10'Please wait...'
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    Visible = False
    WordWrap = True
  end
  object openButton: TButton
    Left = 880
    Top = 11
    Width = 321
    Height = 65
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Action = open
    Anchors = [akTop, akRight]
    TabOrder = 1
  end
  object saveButton: TButton
    Left = 880
    Top = 112
    Width = 321
    Height = 65
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Action = save
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object quitButton: TButton
    Left = 880
    Top = 742
    Width = 321
    Height = 65
    Cursor = crHandPoint
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Action = quit
    Anchors = [akRight, akBottom]
    TabOrder = 3
  end
  object scrollBox: TScrollBox
    Left = 11
    Top = 11
    Width = 857
    Height = 796
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 0
    object image: TImage
      Left = 0
      Top = 0
      Width = 857
      Height = 790
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      AutoSize = True
    end
  end
  object qualityTrackBar: TTrackBar
    Left = 880
    Top = 304
    Width = 337
    Height = 65
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akTop, akRight]
    Ctl3D = True
    Max = 100
    ParentCtl3D = False
    TabOrder = 4
    ThumbLength = 40
  end
  object actions: TActionList
    Left = 1000
    Top = 616
    object open: TAction
      Caption = 'Open image [Ctrl+O]'
      ShortCut = 16463
      OnExecute = openExecute
    end
    object save: TAction
      Caption = 'Save as WebP [Ctrl+S]'
      ShortCut = 16467
      OnExecute = saveExecute
    end
    object quit: TAction
      Caption = 'Quit [Esc]'
      ShortCut = 27
      OnExecute = quitExecute
    end
  end
  object openImageDialog: TOpenDialog
    Filter = 
      'PNG images (*.png)|*.png|JPG images (*.jpg)|*.jpg|All files (*.*' +
      ')|*.*'
    FilterIndex = 0
    Title = 'Choose an image file'
    Left = 912
    Top = 520
  end
  object saveWebPDialog: TSaveDialog
    DefaultExt = 'webp'
    Filter = 'WebP images (*.webp)|*.webp|All files (*.*)|*.*'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Choose the location and file name'
    Left = 1064
    Top = 528
  end
end
