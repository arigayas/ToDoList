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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    584
    493)
  PixelsPerInch = 96
  TextHeight = 13
  object ColorGroupBox: TGroupBox
    Left = 0
    Top = 0
    Width = 584
    Height = 450
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #21608#26399'Todo'#12522#12473#12488
    TabOrder = 0
    object LoopListView1: TListView
      Left = 2
      Top = 148
      Width = 580
      Height = 300
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
        000330003000310007AC726E30A830B5306E3042669395D059E10502CE6BE565
        785AE10505310032001AFF30003000B05AE10503720065006400E85AE1050000
        000001000000FFFFFFFF0300000001000000000000000330003000320007AC72
        6E306365696B6E3042669395585BE105030867346CD191905BE1050531003800
        1AFF30003000C85BE1050000000002000000FFFFFFFF03000000020000000000
        00000330003000330003E930B830AA30385CE10501E565705CE1050531003500
        1AFF30003000A85CE105FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      GroupView = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = LoopListView1SelectItem
      ExplicitTop = 150
      ExplicitHeight = 183
    end
    object LoopAddButton: TButton
      Left = 493
      Top = 23
      Width = 75
      Height = 25
      Caption = #36861#21152
      Enabled = False
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
      ActivePage = DailyTabSheet
      TabOrder = 3
      OnChange = PageControl1Change
      object DailyTabSheet: TTabSheet
        Caption = #27598#26085
        object DailyTimeLabel: TLabel
          Left = 3
          Top = 9
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
        object DailyColorLabel: TLabel
          Left = 4
          Top = 37
          Width = 53
          Height = 16
          Caption = #32972#26223#33394#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object DailyDateTimePicker: TDateTimePicker
          Left = 142
          Top = 5
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
        object DailyColorBox: TColorBox
          Left = 96
          Top = 35
          Width = 111
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
          TabOrder = 1
        end
      end
      object WeeklyTabSheet: TTabSheet
        Caption = #26332#26085
        ImageIndex = 1
        object WeeklyTimeLabel: TLabel
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
        object WeeklyColorLabel: TLabel
          Left = 3
          Top = 62
          Width = 53
          Height = 16
          Caption = #32972#26223#33394#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object WeekdayCheckListBox: TCheckListBox
          Left = 3
          Top = 8
          Width = 281
          Height = 22
          OnClickCheck = WeekdayCheckListBoxClickCheck
          BorderStyle = bsNone
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
        object WeeklyDateTimePicker: TDateTimePicker
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
        object WeeklyColorBox: TColorBox
          Left = 96
          Top = 60
          Width = 111
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          TabOrder = 2
        end
      end
      object MonthlyTabSheet: TTabSheet
        Caption = #25351#23450#26085
        ImageIndex = 2
        object MonthlyTimeLabel: TLabel
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
        object MonthlyColorLabel: TLabel
          Left = 3
          Top = 62
          Width = 53
          Height = 16
          Caption = #32972#26223#33394#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object MonthlyLabeledEdit: TLabeledEdit
          Left = 126
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
          ImeMode = imAlpha
          LabelPosition = lpLeft
          MaxLength = 2
          NumbersOnly = True
          TabOrder = 0
          OnChange = MonthlyLabeledEditChange
        end
        object MonthlyDateTimePicker: TDateTimePicker
          Left = 142
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
        object MonthlyColorBox: TColorBox
          Left = 96
          Top = 60
          Width = 111
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          TabOrder = 2
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
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
