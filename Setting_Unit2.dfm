object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #35373#23450
  ClientHeight = 493
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MaxHeight = 750
  Constraints.MaxWidth = 600
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    584
    493)
  PixelsPerInch = 96
  TextHeight = 13
  object SettingCheckBoxGroup: TGroupBox
    Left = 0
    Top = 0
    Width = 584
    Height = 113
    Align = alTop
    Caption = #35373#23450
    TabOrder = 0
    object BR_CheckBox1: TCheckBox
      Left = 16
      Top = 24
      Width = 145
      Height = 17
      Caption = #12454#12451#12531#12489#12454#12398#24133#12391#25240#12426#36820#12377
      Enabled = False
      TabOrder = 0
      OnClick = BR_CheckBox1Click
    end
    object fontBiggerCheckBox: TCheckBox
      Left = 16
      Top = 47
      Width = 145
      Height = 17
      Caption = #12522#12473#12488#12398#25991#23383#12434#22823#12365#12367#12377#12427
      TabOrder = 1
      OnClick = fontBiggerCheckBoxClick
    end
    object frontmostCheckBox: TCheckBox
      Left = 16
      Top = 70
      Width = 129
      Height = 17
      Caption = #26368#21069#38754#12391#24120#12395#34920#31034#12377#12427
      TabOrder = 2
      OnClick = frontmostCheckBoxClick
    end
  end
  object ColorGroupBox: TGroupBox
    Left = 0
    Top = 113
    Width = 584
    Height = 333
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #21608#26399'Todo'#12522#12473#12488
    TabOrder = 1
    ExplicitHeight = 279
    object LoopListView1: TListView
      Left = 2
      Top = 150
      Width = 580
      Height = 181
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'ID'
          MaxWidth = 100
          MinWidth = 50
          Width = 75
        end
        item
          Caption = #38917#30446
          MinWidth = 150
          Width = 150
        end
        item
          Caption = #23455#34892#26085
        end
        item
          Caption = #26178#21051
          MaxWidth = 50
          MinWidth = 50
        end
        item
          Caption = #32972#26223#33394
          MinWidth = 50
        end>
      Constraints.MinHeight = 50
      GridLines = True
      Groups = <
        item
          Header = #27598#26085
          GroupID = 0
          State = [lgsNormal]
          HeaderAlign = taCenter
          FooterAlign = taLeftJustify
          TitleImage = -1
        end
        item
          Header = #27598#36913
          GroupID = 1
          State = [lgsNormal]
          HeaderAlign = taCenter
          FooterAlign = taLeftJustify
          TitleImage = -1
        end
        item
          Header = #27598#26376
          GroupID = 2
          State = [lgsNormal]
          HeaderAlign = taCenter
          FooterAlign = taLeftJustify
          TitleImage = -1
        end>
      Items.ItemData = {
        05F8000000030000000000000000000000FFFFFFFF0400000000000000000000
        000330003000310007AC726E30A830B5306E3042669395D082DE2C02CE6BE565
        8886DE2C05300032001AFF30003000F886DE2C037200650064005086DE2C0000
        000001000000FFFFFFFF0300000001000000000000000330003000320007AC72
        6E306365696B6E30426693959882DE2C030867346CD191C086DE2C0531003800
        1AFF300030003087DE2C0000000002000000FFFFFFFF03000000020000000000
        00000330003000330003E930B830AA303080DE2C01E5654881DE2C0531003500
        1AFF300030001081DE2CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      GroupView = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = LoopListView1SelectItem
      ExplicitHeight = 127
    end
    object LoopAddButton: TButton
      Left = 493
      Top = 23
      Width = 75
      Height = 25
      Caption = #36861#21152
      TabOrder = 1
      OnClick = LoopAddButtonClick
    end
    object LoopDeleteButton: TButton
      Left = 493
      Top = 62
      Width = 75
      Height = 25
      Caption = #21066#38500
      Enabled = False
      TabOrder = 2
      OnClick = LoopDeleteButtonClick
    end
    object PageControl1: TPageControl
      Left = 3
      Top = 23
      Width = 466
      Height = 124
      ActivePage = DailyTabSheet1
      TabOrder = 3
      object DailyTabSheet1: TTabSheet
        Caption = #27598#26085
        object DailyLabel: TLabel
          Left = 3
          Top = 16
          Width = 133
          Height = 16
          Caption = #36861#21152#12434#23455#34892#12377#12427#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object DateTimePicker2: TDateTimePicker
          Left = 142
          Top = 11
          Width = 65
          Height = 24
          Date = 43669.000000000000000000
          Format = 'HH:mm'
          Time = 0.500000000000000000
          DateMode = dmUpDown
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          TabOrder = 0
        end
      end
      object WeeklyTabSheet2: TTabSheet
        Caption = #26332#26085
        ImageIndex = 1
        object WeeklyLabe: TLabel
          Left = 3
          Top = 35
          Width = 133
          Height = 16
          Caption = #36861#21152#12434#23455#34892#12377#12427#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object CheckListBox1: TCheckListBox
          Left = 3
          Top = 3
          Width = 281
          Height = 22
          Columns = 7
          ItemHeight = 13
          Items.Strings = (
            #26085
            #26376
            #28779
            #27700
            #26408
            #37329
            #22303)
          TabOrder = 0
        end
        object DateTimePicker1: TDateTimePicker
          Left = 142
          Top = 31
          Width = 65
          Height = 24
          Date = 43669.000000000000000000
          Format = 'HH:mm'
          Time = 0.500000000000000000
          DateMode = dmUpDown
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          TabOrder = 1
        end
      end
      object DayTabSheet1: TTabSheet
        Caption = #25351#23450#26085
        ImageIndex = 2
        object Label1: TLabel
          Left = 9
          Top = 35
          Width = 133
          Height = 16
          Caption = #36861#21152#12434#23455#34892#12377#12427#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object LabeledEdit1: TLabeledEdit
          Left = 132
          Top = 3
          Width = 121
          Height = 21
          EditLabel.Width = 118
          EditLabel.Height = 16
          EditLabel.Caption = #36861#21152#12434#23455#34892#12377#12427#26085#65306
          EditLabel.Font.Charset = DEFAULT_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -13
          EditLabel.Font.Name = 'Tahoma'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object DateTimePicker3: TDateTimePicker
          Left = 148
          Top = 30
          Width = 65
          Height = 24
          Date = 43669.000000000000000000
          Format = 'HH:mm'
          Time = 0.500000000000000000
          DateMode = dmUpDown
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object OKButton: TButton
    Left = 501
    Top = 456
    Width = 75
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 2
    OnClick = OKButtonClick
    ExplicitTop = 402
  end
end
