object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #35373#23450
  ClientHeight = 450
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
    450)
  PixelsPerInch = 96
  TextHeight = 13
  object ColorGroupBox: TGroupBox
    Left = 0
    Top = 0
    Width = 584
    Height = 193
    Align = alTop
    Caption = 'Todo'#36861#21152#12522#12473#12488' :: '#32232#38598
    TabOrder = 0
    object LoopAddButton: TButton
      Left = 493
      Top = 47
      Width = 75
      Height = 25
      Caption = #36861#21152
      TabOrder = 0
      OnClick = LoopAddButtonClick
    end
    object LoopDeleteButton: TButton
      Left = 493
      Top = 112
      Width = 75
      Height = 25
      Caption = #21066#38500
      Enabled = False
      TabOrder = 1
      OnClick = LoopDeleteButtonClick
    end
    object PageControl1: TPageControl
      Left = 3
      Top = 23
      Width = 484
      Height = 162
      ActivePage = DailyTabSheet
      TabOrder = 2
      OnChange = PageControl1Change
      object DailyTabSheet: TTabSheet
        Caption = #27598#26085
        DesignSize = (
          476
          134)
        object DailyTimeLabel: TLabel
          Left = 3
          Top = 48
          Width = 218
          Height = 16
          Caption = 'ToDo'#12522#12473#12488#12395#38917#30446#12398#36861#21152#12434#34892#12358#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object DailyColorLabel: TLabel
          Left = 3
          Top = 75
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
          Left = 225
          Top = 45
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
        object DailyColorBox: TColorBox
          Left = 60
          Top = 75
          Width = 120
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
          TabOrder = 2
        end
        object DailyLabeledEdit: TLabeledEdit
          Left = 184
          Top = 11
          Width = 280
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 172
          EditLabel.Height = 16
          EditLabel.Caption = 'ToDo'#12522#12473#12488#12395#36861#21152#12377#12427#38917#30446#21517
          EditLabel.Font.Charset = DEFAULT_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -13
          EditLabel.Font.Name = 'Tahoma'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          LabelSpacing = 10
          ParentFont = False
          TabOrder = 0
          OnChange = DailyLabeledEditChange
        end
        object DailyCheckBox: TCheckBox
          Left = 225
          Top = 75
          Width = 54
          Height = 23
          Caption = #26377#21177
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 3
        end
      end
      object WeeklyTabSheet: TTabSheet
        Caption = #27598#36913
        ImageIndex = 1
        DesignSize = (
          476
          134)
        object WeeklyTimeLabel: TLabel
          Left = 3
          Top = 79
          Width = 218
          Height = 16
          Caption = 'ToDo'#12522#12473#12488#12395#38917#30446#12398#36861#21152#12434#34892#12358#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object WeeklyColorLabel: TLabel
          Left = 3
          Top = 107
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
          Top = 48
          Width = 281
          Height = 22
          OnClickCheck = WeekdayCheckListBoxClick
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
          TabOrder = 1
          OnClick = WeekdayCheckListBoxClick
        end
        object WeeklyDateTimePicker: TDateTimePicker
          Left = 225
          Top = 74
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
          TabOrder = 2
        end
        object WeeklyColorBox: TColorBox
          Left = 60
          Top = 105
          Width = 120
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          TabOrder = 3
        end
        object WeeklyLabeledEdit: TLabeledEdit
          Left = 184
          Top = 11
          Width = 280
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 172
          EditLabel.Height = 16
          EditLabel.Caption = 'ToDo'#12522#12473#12488#12395#36861#21152#12377#12427#38917#30446#21517
          EditLabel.Font.Charset = DEFAULT_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -13
          EditLabel.Font.Name = 'Tahoma'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          LabelSpacing = 10
          ParentFont = False
          TabOrder = 0
          OnChange = WeeklyLabeledEditChange
        end
        object WeeklyCheckBox: TCheckBox
          Left = 225
          Top = 105
          Width = 54
          Height = 23
          Caption = #26377#21177
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 4
        end
      end
      object MonthlyTabSheet: TTabSheet
        Caption = #27598#26376
        ImageIndex = 2
        DesignSize = (
          476
          134)
        object MonthlyTimeLabel: TLabel
          Left = 3
          Top = 79
          Width = 218
          Height = 16
          Caption = 'ToDo'#12522#12473#12488#12395#38917#30446#12398#36861#21152#12434#34892#12358#26178#21051#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object MonthlyColorLabel: TLabel
          Left = 3
          Top = 106
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
        object MonthlyLabel: TLabel
          Left = 3
          Top = 50
          Width = 203
          Height = 16
          Caption = 'ToDo'#12522#12473#12488#12395#38917#30446#12398#36861#21152#12434#34892#12358#26085#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object MonthlyDateTimePicker: TDateTimePicker
          Left = 225
          Top = 74
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
          TabOrder = 2
        end
        object MonthlyColorBox: TColorBox
          Left = 60
          Top = 105
          Width = 120
          Height = 22
          DefaultColorColor = clWhite
          NoneColorColor = clWhite
          Selected = clWhite
          TabOrder = 3
        end
        object MonthlyLabeledEdit: TLabeledEdit
          Left = 184
          Top = 11
          Width = 280
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 172
          EditLabel.Height = 16
          EditLabel.Caption = 'ToDo'#12522#12473#12488#12395#36861#21152#12377#12427#38917#30446#21517
          EditLabel.Font.Charset = DEFAULT_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -13
          EditLabel.Font.Name = 'Tahoma'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          LabelSpacing = 10
          ParentFont = False
          TabOrder = 0
          OnChange = MonthlyLabeledEditChange
        end
        object MonthlyCheckBox: TCheckBox
          Left = 225
          Top = 104
          Width = 54
          Height = 23
          Caption = #26377#21177
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 4
        end
        object MonthlyComboBoxDay: TComboBox
          Left = 225
          Top = 47
          Width = 75
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = MonthlyComboBoxDayChange
          Items.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23'
            '24'
            '25'
            '26'
            '27'
            '28'
            '29'
            '30'
            '31'
            #26376#26411)
        end
      end
    end
    object LoopEditButton: TButton
      Left = 493
      Top = 81
      Width = 75
      Height = 25
      Caption = #19978#26360#12365#20445#23384
      Enabled = False
      TabOrder = 3
    end
  end
  object OKButton: TButton
    Left = 420
    Top = 413
    Width = 75
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = #20445#23384#12377#12427
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object CancelButton: TButton
    Left = 501
    Top = 413
    Width = 75
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = #20445#23384#12375#12394#12356
    TabOrder = 2
    OnClick = CancelButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 193
    Width = 584
    Height = 216
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'ToDo'#36861#21152#12522#12473#12488' :: '#19968#35239
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object LoopListView1: TListView
      Left = 2
      Top = 15
      Width = 580
      Height = 199
      Align = alClient
      Columns = <
        item
          Caption = 'ID'
          MaxWidth = 50
          MinWidth = 50
        end
        item
          Caption = #38917#30446
          MinWidth = 150
          Width = 150
        end
        item
          Caption = #23455#34892#26085
          MaxWidth = 200
          MinWidth = 50
        end
        item
          Caption = #26178#21051
          MaxWidth = 50
          MinWidth = 50
        end
        item
          Caption = #32972#26223#33394
          MinWidth = 50
        end
        item
          Caption = #27425#22238#36861#21152#20104#23450#26085
          MaxWidth = 100
          MinWidth = 100
          Width = 100
        end
        item
          Caption = #26377#21177'/'#28961#21177
          MaxWidth = 70
          MinWidth = 70
          Width = 70
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
        0571010000040000000000000000000000FFFFFFFF0600000000000000000000
        000330003000310007AC726E30A830B5306E3042669395E0EC964402CE6BE565
        980C974405310032003A0030003000A8EC964402648D7282F8ED96440A320030
        00320030002F00300034002F003000310018ED9644024F004E00C8EB96440000
        000001000000FFFFFFFF0300000001000000000000000330003000320007AC72
        6E306365696B6E304266939558EB9644030867346CD19120EB96440531003800
        1AFF30003000E8EA96440000000002000000FFFFFFFF04000000020000000000
        00000330003000330003E930B830AA3078EA9644023100E56540EA9644053100
        35001AFF3000300008EA964400D0E9964400000000FFFFFFFFFFFFFFFF040000
        000100000000000000033000300034000331900A528C8A60E996440028E99644
        05310033003A0030003000F0E8964400B8E89644FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      GroupView = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = LoopListView1Click
      OnSelectItem = LoopListView1SelectItem
      ExplicitHeight = 225
    end
  end
end
