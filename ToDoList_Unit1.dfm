object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ToDo List'
  ClientHeight = 311
  ClientWidth = 429
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = CheckListBox1KeyDown
  DesignSize = (
    429
    311)
  PixelsPerInch = 96
  TextHeight = 13
  object AddItemButton: TButton
    Left = 8
    Top = 265
    Width = 81
    Height = 38
    Anchors = [akLeft, akBottom]
    Caption = #36861#21152
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #12513#12452#12522#12458
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = AddItemButtonClick
    OnKeyDown = CheckListBox1KeyDown
  end
  object DeleteButton: TButton
    Left = 346
    Top = 265
    Width = 75
    Height = 38
    Anchors = [akRight, akBottom]
    Caption = #21066#38500
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #12513#12452#12522#12458
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = DeleteButtonClick
    OnKeyDown = CheckListBox1KeyDown
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 0
    Width = 429
    Height = 259
    OnClickCheck = CheckListBox1ClickCheck
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeMode = imDisable
    ItemHeight = 19
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ScrollWidth = 5
    ShowHint = True
    Style = lbOwnerDrawFixed
    TabOrder = 1
    OnDblClick = CheckListBox1DblClick
    OnDragDrop = CheckListBox1DragDrop
    OnDragOver = CheckListBox1DragOver
    OnDrawItem = CheckListBox1DrawItem
    OnKeyDown = CheckListBox1KeyDown
    OnMouseEnter = CheckListBox1MouseEnter
  end
  object Memo1: TMemo
    Left = 96
    Top = 158
    Width = 249
    Height = 89
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      'Debug '#34920#31034)
    TabOrder = 3
    OnKeyDown = CheckListBox1KeyDown
  end
  object ReplaceButton: TButton
    Left = 95
    Top = 265
    Width = 81
    Height = 38
    Anchors = [akLeft, akBottom]
    Caption = #20837#12428#26367#12360
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #12513#12452#12522#12458
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ReplaceButtonClick
    OnKeyDown = CheckListBox1KeyDown
  end
  object PopupMenu1: TPopupMenu
    Left = 200
    Top = 272
    object PopupPasteFromClipboardText: TMenuItem
      Caption = #12463#12522#12483#12503#12508#12540#12489#12363#12425#36028#12426#20184#12369
      ShortCut = 16464
      OnClick = PasteFromClipboardText
    end
    object DeleteAllChecked: TMenuItem
      Caption = #12377#12409#12390#12398#12481#12455#12483#12463#12434#22806#12377
      OnClick = DeleteAllCheckedClick
    end
    object SwitchTaskTray: TMenuItem
      Caption = #12479#12473#12463#12488#12524#12452#12395#26684#32013#12377#12427
      OnClick = SwitchTaskTrayClick
    end
    object SaveListLog: TMenuItem
      Caption = #29694#22312#12398#12522#12473#12488#12434#12486#12461#12473#12488#12395#20445#23384#12377#12427
      ShortCut = 16467
      OnClick = SaveListLogClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Setting_N1: TMenuItem
      Caption = #35373#23450#12454#12451#12531#12489#12454
      OnClick = Setting_N1Click
    end
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnClick = TrayIcon1Click
    Left = 264
    Top = 272
  end
end
