object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #35373#23450
  ClientHeight = 489
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
    Height = 489
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
      Left = 16
      Top = 231
      Width = 193
      Height = 213
      TabOrder = 2
      TitleCaptions.Strings = (
        'ID'
        #33394)
      ColWidths = (
        41
        146)
    end
    object frontmostCheckBox: TCheckBox
      Left = 16
      Top = 70
      Width = 129
      Height = 17
      Caption = #26368#21069#38754#12391#24120#12395#34920#31034#12377#12427
      TabOrder = 3
      OnClick = frontmostCheckBoxClick
    end
  end
  object ColorGroupBox: TGroupBox
    Left = 248
    Top = 8
    Width = 328
    Height = 436
    Caption = #21608#26399'Todo'#12522#12473#12488
    TabOrder = 1
    object ColorListBox1: TColorListBox
      Left = 0
      Top = 341
      Width = 118
      Height = 69
      TabOrder = 0
      OnClick = ColorListBox1Click
    end
    object LoopListView1: TListView
      Left = 3
      Top = 21
      Width = 322
      Height = 236
      Columns = <
        item
          Caption = 'ID'
        end
        item
          Caption = #38917#30446
        end
        item
          Caption = #23455#34892#26085
        end
        item
          Caption = #26178#21051
        end
        item
          Caption = #32972#26223#33394
        end>
      GridLines = True
      Items.ItemData = {
        05D1000000030000000000000000000000FFFFFFFF04000000FFFFFFFF000000
        000330003000310007AC726E30A830B5306E3042669395A8656B2C02CE6BE565
        B0BB6A2C05300032001AFF30003000F8666B2C03720065006400C8646B2C0000
        000001000000FFFFFFFF03000000FFFFFFFF000000000330003000320007AC72
        6E306365696B6E304266939588666B2C030867346CD19158646B2C0531003800
        1AFF3000300048D56A2C0000000002000000FFFFFFFF00000000FFFFFFFF0000
        000003300030003300FFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
    object LoopAddButton: TButton
      Left = 124
      Top = 375
      Width = 75
      Height = 25
      Caption = #36861#21152
      TabOrder = 2
      OnClick = LoopAddButtonClick
    end
    object LoopDeleteButton: TButton
      Left = 250
      Top = 375
      Width = 75
      Height = 25
      Caption = #21066#38500
      TabOrder = 3
    end
  end
  object OKButton: TButton
    Left = 501
    Top = 456
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = OKButtonClick
  end
  object CancelButton: TButton
    Left = 412
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = CancelButtonClick
  end
end
