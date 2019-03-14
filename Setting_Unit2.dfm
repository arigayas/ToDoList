object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #35373#23450
  ClientHeight = 454
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MaxWidth = 600
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SettingCheckBoxGroup: TGroupBox
    Left = 0
    Top = 0
    Width = 242
    Height = 454
    Align = alLeft
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
    object ValueListEditor1: TValueListEditor
      Left = 3
      Top = 238
      Width = 193
      Height = 213
      TabOrder = 2
      ColWidths = (
        41
        146)
    end
  end
  object LoopGroupBox: TGroupBox
    Left = 248
    Top = 0
    Width = 328
    Height = 169
    Caption = #21608#26399'Todo'#12522#12473#12488
    TabOrder = 1
    object LoopAddButton: TButton
      Left = 5
      Top = 135
      Width = 75
      Height = 25
      Caption = #36861#21152
      TabOrder = 0
      OnClick = LoopAddButtonClick
    end
    object LoopDeleteButton: TButton
      Left = 250
      Top = 135
      Width = 75
      Height = 25
      Caption = #21066#38500
      TabOrder = 1
    end
    object LoopCheckListBox: TCheckListBox
      Left = 5
      Top = 16
      Width = 320
      Height = 113
      OnClickCheck = LoopCheckListBoxClickCheck
      Columns = 1
      ItemHeight = 13
      Items.Strings = (
        '11'
        '22'
        '33')
      Sorted = True
      TabOrder = 2
    end
  end
  object ColorGroupBox: TGroupBox
    Left = 248
    Top = 175
    Width = 328
    Height = 269
    Caption = #33394#35373#23450#12522#12473#12488
    TabOrder = 2
    object ColorListBox1: TColorListBox
      Left = 0
      Top = 197
      Width = 118
      Height = 69
      TabOrder = 0
      OnClick = ColorListBox1Click
    end
    object ListView1: TListView
      Left = 3
      Top = 21
      Width = 322
      Height = 170
      Columns = <
        item
          AutoSize = True
          Caption = #38917#30446#20869#23481
          MaxWidth = 900
          MinWidth = 100
        end
        item
          Caption = #21608#26399#23455#34892#26085
        end
        item
          Caption = '00:00'
        end
        item
          Caption = #32972#26223#33394
        end>
      GridLines = True
      Groups = <
        item
          Header = #12464#12523#12540#12503'1'#12388#30446#12398#12504#12483#12480
          GroupID = 0
          State = [lgsNormal]
          HeaderAlign = taLeftJustify
          FooterAlign = taLeftJustify
          Subtitle = #12469#12502#12479#12452#12488#12523'test01'
          TitleImage = -1
        end
        item
          Header = #12472#12515#12531#12523#12392#32972#26223#33394
          GroupID = 1
          State = [lgsNormal]
          HeaderAlign = taLeftJustify
          FooterAlign = taLeftJustify
          Subtitle = 'test02'
          TitleImage = -1
        end>
      Items.ItemData = {
        059E000000030000000000000000000000FFFFFFFF0200000000000000000000
        000330003000310005300035002F003200300020E5D622043100310030003000
        4828D7220000000001000000FFFFFFFF02000000010000000000000003300030
        003200043000300032003200E81CD722043000300030003000781CD722000000
        0002000000FFFFFFFF00000000010000000000000003300030003300FFFFFFFF
        FFFFFFFF}
      GroupView = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
end
