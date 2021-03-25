object ImageProc: TImageProc
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ImageProc'
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 242
    Width = 726
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -18
    ExplicitWidth = 678
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 500
    Width = 726
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -18
    ExplicitWidth = 678
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 242
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      726
      242)
    object lblCurrentNum: TLabel
      Left = 209
      Top = 24
      Width = 279
      Height = 33
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '10001'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -21
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 232
    end
    object Label1: TLabel
      Left = 32
      Top = 24
      Width = 171
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = #54788#51116' '#51652#54665#51473
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -21
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 8
      Top = 136
      Width = 114
      Height = 21
      AutoSize = False
      Caption = #47700#51064' '#49884#51089#48264#54840
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 8
      Top = 171
      Width = 114
      Height = 21
      AutoSize = False
      Caption = #49436#48652' '#49884#51089#48264#54840
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 423
      Top = 136
      Width = 117
      Height = 21
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = #51204#52404' '#54260#45908' '#44160#51613
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 609
      Top = 136
      Width = 18
      Height = 21
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = #44060
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 32
      Top = 64
      Width = 171
      Height = 62
      Alignment = taCenter
      AutoSize = False
      Caption = #45796#51020' '#48264#54840
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -21
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lblNextNum: TLabel
      Left = 209
      Top = 64
      Width = 279
      Height = 62
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '10001'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -48
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 232
    end
    object Label7: TLabel
      Left = 304
      Top = 171
      Width = 59
      Height = 21
      AutoSize = False
      Caption = #44060' '#54028#51068
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 8
      Top = 206
      Width = 114
      Height = 21
      AutoSize = False
      Caption = #47532#49324#51060#51592'('#44032#47196')'
      Layout = tlCenter
    end
    object btnRun: TButton
      Left = 607
      Top = 24
      Width = 113
      Height = 65
      Anchors = [akTop, akRight]
      Caption = #49892#54665
      TabOrder = 10
      OnClick = btnRunClick
    end
    object edtMainNum: TEdit
      Left = 127
      Top = 133
      Width = 171
      Height = 29
      Alignment = taRightJustify
      TabOrder = 0
      Text = '10001'
    end
    object cbxImageInfo: TscCheckBox
      Left = 486
      Top = 206
      Width = 169
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 8
      TabStop = True
      CustomCheckedImageIndex = -1
      CustomCheckedImageHotIndex = -1
      CustomCheckedImagePressedIndex = -1
      CustomCheckedImageDisabledIndex = -1
      CustomUnCheckedImageIndex = -1
      CustomUnCheckedImageHotIndex = -1
      CustomUnCheckedImagePressedIndex = -1
      CustomUnCheckedImageDisabledIndex = -1
      CustomGrayedImageIndex = -1
      CustomGrayedImageHotIndex = -1
      CustomGrayedImagePressedIndex = -1
      CustomGrayedImageDisabledIndex = -1
      UseFontColorToStyleColor = False
      Animation = False
      Caption = 'Create Image Info'
      CanFocused = True
      Spacing = 1
      Layout = blGlyphLeft
      ImageIndex = -1
      GlowEffect.Enabled = False
      GlowEffect.Color = clHighlight
      GlowEffect.AlphaValue = 255
      GlowEffect.GlowSize = 7
      GlowEffect.Offset = 0
      GlowEffect.Intensive = True
      GlowEffect.StyleColors = True
      GlowEffect.HotColor = clNone
      GlowEffect.PressedColor = clNone
      GlowEffect.FocusedColor = clNone
      GlowEffect.PressedGlowSize = 7
      GlowEffect.PressedAlphaValue = 255
      GlowEffect.States = [scsHot, scsPressed, scsFocused]
      ImageGlow = True
      Checked = True
      State = cbChecked
      ShowFocusRect = True
    end
    object btnInit: TButton
      Left = 488
      Top = 24
      Width = 113
      Height = 65
      Anchors = [akTop, akRight]
      Caption = #52488#44592#54868
      TabOrder = 9
      OnClick = btnInitClick
    end
    object btnOpenImages: TscGPGlyphButton
      Left = 664
      Top = 203
      Width = 56
      Height = 36
      Anchors = [akRight, akBottom]
      TabOrder = 11
      TabStop = True
      OnClick = btnOpenImagesClick
      Animation = False
      Caption = 'btnOpenImages'
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
      Options.ShapeStyle = scgpRect
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
    object btnCheckFolder: TButton
      Left = 628
      Top = 133
      Width = 92
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #54260#45908#44160#51613
      TabOrder = 6
      OnClick = btnCheckFolderClick
    end
    object edtCheckFolder: TEdit
      Left = 542
      Top = 133
      Width = 66
      Height = 29
      Anchors = [akTop, akRight]
      NumbersOnly = True
      TabOrder = 5
      Text = 'edtCheckFolder'
    end
    object Button1: TButton
      Left = 628
      Top = 168
      Width = 92
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'Clear Log'
      TabOrder = 7
      OnClick = Button1Click
    end
    object edtCurCount: TEdit
      Left = 256
      Top = 168
      Width = 42
      Height = 29
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 3
      Text = '1'
    end
    object edtResizeWidth: TEdit
      Left = 127
      Top = 203
      Width = 171
      Height = 29
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 4
      Text = '1024'
    end
    object rbColor: TRadioButton
      Left = 127
      Top = 174
      Width = 66
      Height = 17
      Caption = #52972#47084
      TabOrder = 1
      TabStop = True
    end
    object rbBnW: TRadioButton
      Left = 190
      Top = 174
      Width = 66
      Height = 17
      Caption = #55121#48177
      TabOrder = 2
      TabStop = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 245
    Width = 726
    Height = 255
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 361
      Top = 0
      Width = 4
      Height = 255
      ExplicitLeft = 350
    end
    object imgLeft: TImage
      Left = 0
      Top = 0
      Width = 361
      Height = 255
      Align = alLeft
      Stretch = True
      OnClick = ImageClick
    end
    object imgRight: TImage
      Left = 365
      Top = 0
      Width = 361
      Height = 255
      Align = alClient
      Stretch = True
      OnClick = ImageClick
      ExplicitLeft = 339
      ExplicitTop = 6
      ExplicitWidth = 329
      ExplicitHeight = 247
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 503
    Width = 726
    Height = 156
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel5'
    ShowCaption = False
    TabOrder = 2
    object mmLog: TMemo
      Left = 0
      Top = 0
      Width = 726
      Height = 156
      Align = alClient
      Lines.Strings = (
        'mmLog')
      ScrollBars = ssVertical
      TabOrder = 0
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
