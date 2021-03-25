object DBLogin: TDBLogin
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'DBLogin'
  ClientHeight = 209
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #45208#45588#44256#46357#53076#46377
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 11
  object AdvPanel1: TAdvPanel
    Left = 0
    Top = 0
    Width = 354
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    UseDockManager = True
    Version = '2.5.4.1'
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -11
    Caption.Font.Name = #45208#45588#44256#46357#53076#46377
    Caption.Font.Style = []
    Caption.Indent = 0
    DoubleBuffered = True
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    Text = ''
    FullHeight = 200
    object AdvLabel1: TAdvLabel
      Left = 16
      Top = 6
      Width = 65
      Height = 17
      Text = 
        '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
        ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
        '0\fs16 Server\f1\par'#13#10'}'#13#10#0
      WordWrap = False
      Version = '1.0.0.3'
    end
    object AdvLabel2: TAdvLabel
      Left = 16
      Top = 29
      Width = 65
      Height = 17
      Text = 
        '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
        ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
        '0\fs16 Port\f1\par'#13#10'}'#13#10#0
      WordWrap = False
      Version = '1.0.0.3'
    end
    object AdvLabel3: TAdvLabel
      Left = 16
      Top = 52
      Width = 65
      Height = 17
      Text = 
        '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
        ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
        '0\fs16 Username\f1\par'#13#10'}'#13#10#0
      WordWrap = False
      Version = '1.0.0.3'
    end
    object AdvLabel4: TAdvLabel
      Left = 16
      Top = 75
      Width = 65
      Height = 17
      Text = 
        '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
        ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
        '0\fs16 Password\f1\par'#13#10'}'#13#10#0
      WordWrap = False
      Version = '1.0.0.3'
    end
    object AdvLabel5: TAdvLabel
      Left = 16
      Top = 98
      Width = 65
      Height = 17
      Text = 
        '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
        ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
        '0\fs16 Database\f1\par'#13#10'}'#13#10#0
      WordWrap = False
      Version = '1.0.0.3'
    end
    object eServerName: TAdvEdit
      Left = 96
      Top = 6
      Width = 146
      Height = 19
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      TabOrder = 0
      Text = ''
      Visible = True
      OnKeyDown = eServerNameKeyDown
      Version = '3.4.1.1'
    end
    object eServerPort: TAdvEdit
      Left = 96
      Top = 29
      Width = 146
      Height = 19
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      TabOrder = 1
      Text = ''
      Visible = True
      OnKeyDown = eServerPortKeyDown
      Version = '3.4.1.1'
    end
    object eUsername: TAdvEdit
      Left = 96
      Top = 52
      Width = 146
      Height = 19
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      TabOrder = 2
      Text = ''
      Visible = True
      OnKeyDown = eUsernameKeyDown
      Version = '3.4.1.1'
    end
    object ePassword: TAdvEdit
      Left = 96
      Top = 75
      Width = 146
      Height = 21
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Bitstream Vera Sans Mono'
      Font.Style = []
      ImeMode = imDisable
      ParentFont = False
      PasswordChar = #7
      TabOrder = 3
      Text = ''
      Visible = True
      OnKeyDown = ePasswordKeyDown
      Version = '3.4.1.1'
    end
    object eDatabase: TAdvEdit
      Left = 96
      Top = 98
      Width = 146
      Height = 19
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      TabOrder = 4
      Text = ''
      Visible = True
      OnKeyDown = eDatabaseKeyDown
      Version = '3.4.1.1'
    end
    object AeroBitBtn1: TAeroBitBtn
      Left = 244
      Top = 47
      Width = 110
      Height = 24
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 5
      Version = '1.0.0.1'
      OnClick = AeroBitBtn1Click
    end
    object AeroBitBtn2: TAeroBitBtn
      Left = 244
      Top = 70
      Width = 110
      Height = 24
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
      Version = '1.0.0.1'
      OnClick = AeroBitBtn2Click
    end
    object AeroBitBtn3: TAeroBitBtn
      Left = 244
      Top = 93
      Width = 110
      Height = 24
      Caption = 'Add'
      TabOrder = 7
      Version = '1.0.0.1'
      OnClick = AeroBitBtn3Click
    end
    object AdvComboBox1: TAdvComboBox
      Left = 245
      Top = 25
      Width = 107
      Height = 19
      Color = clWindow
      Version = '1.6.2.1'
      Visible = True
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      Items.Strings = (
        ''
        'SQL Server'
        'Oracle')
      LabelCaption = 'Select Provider'
      LabelPosition = lpTopCenter
      LabelAlwaysEnabled = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 8
      OnChange = AdvComboBox1Change
    end
  end
  object AdvPanel2: TAdvPanel
    Left = 0
    Top = 121
    Width = 354
    Height = 88
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    UseDockManager = True
    Version = '2.5.4.1'
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -11
    Caption.Font.Name = #45208#45588#44256#46357#53076#46377
    Caption.Font.Style = []
    Caption.Indent = 0
    DoubleBuffered = True
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    Text = ''
    FullHeight = 200
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 354
      Height = 88
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #45208#45588#44256#46357#53076#46377
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = ListBox1Click
      OnDblClick = ListBox1DblClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 145
    object t1: TMenuItem
      Caption = #49325#51228
      OnClick = t1Click
    end
  end
end
