object AllFileProc: TAllFileProc
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'AllFileProc'
  ClientHeight = 659
  ClientWidth = 726
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 659
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel6'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      726
      659)
    object Label10: TLabel
      Left = 20
      Top = 21
      Width = 117
      Height = 21
      Caption = 'Selected Folder'
    end
    object Label11: TLabel
      Left = 20
      Top = 88
      Width = 120
      Height = 29
      AutoSize = False
      Caption = 'Resize('#44032#47196#44600#51060')'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 20
      Top = 53
      Width = 101
      Height = 29
      AutoSize = False
      Caption = 'Sub Folder'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Label19: TLabel
      Left = 20
      Top = 157
      Width = 124
      Height = 29
      AutoSize = False
      Caption = 'Rename('#49884#51089')'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object edtPath: TEdit
      Left = 143
      Top = 18
      Width = 530
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btnResizeAllImage: TButton
      Left = 506
      Top = 88
      Width = 207
      Height = 29
      Hint = #47784#46304' '#51060#48120#51648#47484' '#54620#48264#50640' '#47532#49324#51060#51592
      Anchors = [akTop, akRight]
      Caption = 'Resize All Images'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnResizeAllImageClick
    end
    object Button2: TButton
      Left = 506
      Top = 53
      Width = 207
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 3
      OnClick = Button2Click
    end
    object mmResizeLog: TMemo
      Left = 4
      Top = 193
      Width = 718
      Height = 462
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Lines.Strings = (
        'mmResizeLog')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 11
    end
    object edtResizeAllWidth: TEdit
      Left = 143
      Top = 88
      Width = 124
      Height = 29
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 4
      Text = '1024'
    end
    object edtSubFolder: TEdit
      Left = 143
      Top = 53
      Width = 124
      Height = 29
      Alignment = taRightJustify
      TabOrder = 2
      Text = 'subFolder'
    end
    object btnOpenFolder: TscGPGlyphButton
      Left = 679
      Top = 18
      Width = 34
      Height = 29
      Anchors = [akTop, akRight]
      TabOrder = 1
      TabStop = True
      OnClick = btnOpenFolderClick
      Animation = False
      Caption = 'btnOpenFolder'
      CanFocused = True
      CustomDropDown = False
      Layout = blGlyphLeft
      TransparentBackground = True
      ColorValue = clRed
      Options.NormalColor = clBtnText
      Options.HotColor = clBtnText
      Options.PressedColor = clBtnText
      Options.FocusedColor = clBtnFace
      Options.DisabledColor = clBtnText
      Options.NormalColorAlpha = 10
      Options.HotColorAlpha = 20
      Options.PressedColorAlpha = 30
      Options.FocusedColorAlpha = 255
      Options.DisabledColorAlpha = 5
      Options.FrameNormalColor = clBtnText
      Options.FrameHotColor = clBtnText
      Options.FramePressedColor = clBtnText
      Options.FrameFocusedColor = clHighlight
      Options.FrameDisabledColor = clBtnText
      Options.FrameWidth = 2
      Options.FrameNormalColorAlpha = 70
      Options.FrameHotColorAlpha = 100
      Options.FramePressedColorAlpha = 150
      Options.FrameFocusedColorAlpha = 255
      Options.FrameDisabledColorAlpha = 30
      Options.FontNormalColor = clBtnText
      Options.FontHotColor = clBtnText
      Options.FontPressedColor = clBtnText
      Options.FontFocusedColor = clBtnText
      Options.FontDisabledColor = clBtnShadow
      Options.ShapeFillGradientAngle = 90
      Options.ShapeFillGradientPressedAngle = -90
      Options.ShapeCornerRadius = 10
      Options.ShapeStyle = scgpRoundedRect
      Options.ArrowSize = 9
      Options.StyleColors = True
      GlyphOptions.NormalColor = clBtnText
      GlyphOptions.HotColor = clBtnText
      GlyphOptions.PressedColor = clBtnText
      GlyphOptions.FocusedColor = clBtnText
      GlyphOptions.DisabledColor = clBtnText
      GlyphOptions.NormalColorAlpha = 200
      GlyphOptions.HotColorAlpha = 255
      GlyphOptions.PressedColorAlpha = 255
      GlyphOptions.FocusedColorAlpha = 255
      GlyphOptions.DisabledColorAlpha = 100
      GlyphOptions.Kind = scgpbgkFileOpen
      GlyphOptions.Thickness = 2
      GlyphOptions.StyleColors = True
      TextMargin = -1
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      RepeatClick = False
      RepeatClickInterval = 100
      ShowGalleryMenuFromTop = False
      ShowGalleryMenuFromRight = False
      ShowMenuArrow = True
      ShowFocusRect = True
      Down = False
      GroupIndex = 0
      AllowAllUp = False
    end
    object btnRenameOnly: TButton
      Left = 506
      Top = 158
      Width = 207
      Height = 29
      Hint = #47932#54400#49324#51652' '#51060#47492#48320#44221#50857
      Anchors = [akTop, akRight]
      Caption = 'Rename Only'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = btnRenameOnlyClick
    end
    object btnSeperateImage: TButton
      Left = 20
      Top = 123
      Width = 207
      Height = 29
      Hint = #51221#47732#49324#51652#44284' '#52769#47732#49324#51652#48324#47196' '#54260#45908#47484' '#48516#47532#54616#50668' '#51200#51109
      Caption = #51221#52769#47732#48516#47532
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnSeperateImageClick
    end
    object btnDevide: TButton
      Left = 264
      Top = 123
      Width = 207
      Height = 29
      Hint = #51060#48120#51648' '#53356#47213' '#54980' '#53685#51004#47196' '#47784#50668#51080#45716' '#54028#51068#51012' '#44033#44033#51032' '#54260#45908#47196' '#48373#49324
      Anchors = [akTop]
      Caption = #45208#45572#44592
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = btnDevideClick
    end
    object edtRenStart: TEdit
      Left = 143
      Top = 158
      Width = 124
      Height = 29
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 9
      Text = '1024'
    end
    object btnCompareWH: TButton
      Left = 506
      Top = 123
      Width = 207
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #51060#48120#51648#44600#51060
      TabOrder = 8
      OnClick = btnCompareWHClick
    end
  end
  object ProgressTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ProgressTimerTimer
    Left = 24
    Top = 536
  end
end
