unit Setting_Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst,
  Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls, System.UITypes, System.IniFiles,
  System.DateUtils;

type
  TForm2 = class(TForm)
    ColorGroupBox: TGroupBox;
    LoopAddButton: TButton;
    LoopDeleteButton: TButton;
    LoopListView1: TListView;
    OKButton: TButton;
    WeeklyDateTimePicker: TDateTimePicker;
    PageControl1: TPageControl;
    DailyTabSheet: TTabSheet;
    WeeklyTabSheet: TTabSheet;
    MonthlyTabSheet: TTabSheet;
    WeekdayCheckListBox: TCheckListBox;
    DailyDateTimePicker: TDateTimePicker;
    DailyTimeLabel: TLabel;
    WeeklyTimeLabel: TLabel;
    MonthlyTimeLabel: TLabel;
    MonthlyDateTimePicker: TDateTimePicker;
    DailyColorBox: TColorBox;
    DailyColorLabel: TLabel;
    WeeklyColorBox: TColorBox;
    WeeklyColorLabel: TLabel;
    MonthlyColorBox: TColorBox;
    MonthlyColorLabel: TLabel;
    CancelButton: TButton;
    DailyLabeledEdit: TLabeledEdit;
    GroupBox1: TGroupBox;
    DailyCheckBox: TCheckBox;
    WeeklyLabeledEdit: TLabeledEdit;
    MonthlyLabeledEdit: TLabeledEdit;
    LoopEditButton: TButton;
    WeeklyCheckBox: TCheckBox;
    MonthlyCheckBox: TCheckBox;
    MonthlyComboBoxDay: TComboBox;
    MonthlyLabel: TLabel;
    procedure LoopAddButtonClick(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure LoopDeleteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure PageControl1Change(Sender: TObject);
    function WeekdayCheckListBoxClickCheck(Sender: TObject): Boolean;
    function WeekdayCheckedCount(ItemsCount: Integer; WeekdayFlag: Integer): Integer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LoopListView1Click(Sender: TObject);
    function LabelEditTextChange(TextLength: Integer): Boolean;
    procedure DailyLabeledEditChange(Sender: TObject);
    procedure MonthlyLabeledEditChange(Sender: TObject);
    procedure WeeklyLabeledEditChange(Sender: TObject);
    procedure WeekdayCheckListBoxClick(Sender: TObject);
    procedure WeeklyTabSheetLoopAddButtonEnable(Sender: TObject);
    procedure MonthlyComboBoxDayChange(Sender: TObject);
    function GetString_OnOff(CheckBoxFlag:Boolean): string;

  private
    procedure MonthlyTabSheetLoopAddButtonEnable(Sender: TObject);
    function SetColorName(GroupIdNum: Integer): String;
    procedure SaveLoopSettings(Sender: TObject);
    procedure LoadLoopSettings(Sender: TObject);
    function ToHankaku(text: String): String;
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

type LoopListViewItem = record
  Index: Integer; // LoopListView1.ItemIndex
  GroupIdNum   : Int16;
  IDnum: string;  // 通し番号的なID
  Text : string;
  Days : string;  // 毎日か曜日か日付か
  Time : string;
  BackColor    : string;
  ExpectedDate : Tdate ;
  Run  : string;  // 実行の有効/無効
  end;

var
  Form2: TForm2;
  CheckedWeekDay: array [0 .. 7] of string;

implementation

{$R *.dfm}

uses ToDoList_Unit1;

resourcestring
  Str_FunctionCalled_an_UnexpectedArgument = '関数で想定していない引数が呼ばれました。';

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanClose then
  begin
    CanClose := true;
    { 終了処理 }
    Form2.Close;
  end
  else
    CanClose := false;
  Form2.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

  LoopListView1.ViewStyle := vsIcon;   // 起動時に1つ目のグループのヘッダー(毎日)が
  LoopListView1.ViewStyle := vsReport; // 表示されない為の対策の2行。

  PageControl1.ActivePageIndex := 0;
  LoopAddButton.Enabled := false;

  DailyColorBox.Style := [cbStandardColors, cbPrettyNames];
  WeeklyColorBox.Style := [cbStandardColors, cbPrettyNames];
  MonthlyColorBox.Style := [cbStandardColors, cbPrettyNames];
end;

function TForm2.GetString_OnOff(CheckBoxFlag:Boolean): string;
begin
 if CheckBoxFlag then
   Result := 'ON'
 else
   Result := 'OFF';
end;

function TForm2.WeekdayCheckedCount(ItemsCount: Integer; WeekdayFlag: Integer): Integer;
// WeekdayFlag -> 0; 数えるだけ
// WeekdayFlag -> 1; チェックした項目のテキスト取得
var
  ItemsChecked, I: Integer;
begin
  ItemsChecked := 0;
  // チェックボックスにチェックがある数を調べる
  for I := 0 to ItemsCount - 1 do
    if WeekdayCheckListBox.Checked[I] = true then
    begin
      case WeekdayFlag of
        0:
          Inc(ItemsChecked);
        1:
          begin
            CheckedWeekDay[ItemsChecked] := WeekdayCheckListBox.Items[I];
            Inc(ItemsChecked);
          end;
      end;
    end;
  Result := ItemsChecked;
end;

procedure TForm2.WeekdayCheckListBoxClick(Sender: TObject);
var
  IndexNum: Int8;
begin
  // チェックマークのオンオフを文字列部分でも行う
  IndexNum := WeekdayCheckListBox.ItemIndex;
  WeekdayCheckListBox.Checked[IndexNum] := not WeekdayCheckListBox.Checked[IndexNum];

  WeeklyTabSheetLoopAddButtonEnable(Sender);
end;

function TForm2.WeekdayCheckListBoxClickCheck(Sender: TObject): Boolean;
var
  WeekdayItems: Int8;
begin
  WeekdayItems := 7;
  if (WeekdayCheckedCount(WeekdayItems, 0) = 0) or (WeekdayCheckedCount(WeekdayItems, 0) = 7) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TForm2.WeeklyLabeledEditChange(Sender: TObject);
begin
  WeeklyTabSheetLoopAddButtonEnable(Sender);
end;

procedure TForm2.WeeklyTabSheetLoopAddButtonEnable(Sender: TObject);
begin
  if LabelEditTextChange(WeeklyLabeledEdit.GetTextLen) and WeekdayCheckListBoxClickCheck(Sender) then
    LoopAddButton.Enabled := True
  else
    LoopAddButton.Enabled := False;
end;

procedure TForm2.CancelButtonClick(Sender: TObject);
begin
  LoadLoopSettings(Sender);
end;

procedure TForm2.ColorListBox1Click(Sender: TObject);
begin
  // ShowMessage( ColorListBox1.ColorNames[ColorListBox1.Selected] ); // 試しにダブルクリックした色を表示する。
end;

procedure TForm2.DailyLabeledEditChange(Sender: TObject);
begin
  LoopAddButton.Enabled := LabelEditTextChange(DailyLabeledEdit.GetTextLen);
end;

procedure TForm2.MonthlyComboBoxDayChange(Sender: TObject);
begin
  MonthlyTabSheetLoopAddButtonEnable(Sender);
end;

procedure TForm2.MonthlyLabeledEditChange(Sender: TObject);
begin
  MonthlyTabSheetLoopAddButtonEnable(Sender);
end;

procedure TForm2.MonthlyTabSheetLoopAddButtonEnable(Sender: TObject);
begin
  if LabelEditTextChange(MonthlyLabeledEdit.GetTextLen) and (MonthlyComboBoxDay.ItemIndex <> -1) then
    LoopAddButton.Enabled := True
  else
    LoopAddButton.Enabled := False;
end;

procedure TForm2.LoopAddButtonClick(Sender: TObject);
var
  ListItem: TListItem;
//  GroupIdNum: Integer;
//  Ans: Boolean;
//  ListItemID, NewString, TempStr, WeekString, ColorName: string;
  TempStr: string;
  Items: LoopListViewItem;
const
  DefaultTimeString = '12:00:00';
begin
  Items.GroupIdNum := PageControl1.ActivePageIndex;
  ListItem := LoopListView1.Items.Add;
  Items.Index := LoopListView1.Items.Count;
//  ListItemID := Format('%.3d', [LoopListView1.Items.Count]);

  case Items.GroupIdNum of
    0: // 毎日
    begin
      // 前処理 ---------------------------------------------------------
      Items.Text := Trim(DailyLabeledEdit.Text);
      DailyDateTimePicker.Date := System.DateUtils.Today;
      Items.Run := GetString_OnOff(DailyCheckBox.Checked);

      // LoopListView1 への追加処理 -------------------------------------
      ListItem.GroupID := Items.GroupIdNum;
      ListItem.Caption := 'D' + Items.Index.ToString;
      ListItem.SubItems.Add(Items.Text);
      ListItem.SubItems.Add('毎日');
      ListItem.SubItems.Add(FormatDateTime('hh:mm', DailyDateTimePicker.DateTime));
      Items.BackColor := SetColorName(Items.GroupIdNum);
      ListItem.SubItems.Add(Items.BackColor);

      // 次回追加予定日の処理
      if CompareDateTime(DailyDateTimePicker.DateTime, Now) = 1 then
        ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd',System.DateUtils.Today))
      else
        ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd',System.DateUtils.Tomorrow));

      ListItem.SubItems.Add(Items.Run);

      // 初期化 ---------------------------------------------------------
      DailyDateTimePicker.Time := StrToTime(DefaultTimeString);
      DailyColorBox.Selected := clWhite;
    end;
    1: // 毎週
    begin
      // 前処理 ---------------------------------------------------------
      Items.Text := Trim(WeeklyLabeledEdit.Text);
      WeeklyDateTimePicker.Date := System.DateUtils.Today;

      WeekdayCheckedCount(7, 1);
      for TempStr in CheckedWeekDay do
      begin
        Items.Days := Items.Days + TempStr;
      end;
      Items.Run := GetString_OnOff(WeeklyCheckBox.Checked);

      // LoopListView1 への追加処理 -------------------------------------
      ListItem.GroupID := Items.GroupIdNum;
      ListItem.Caption := 'W' + Items.Index.ToString;
      ListItem.SubItems.Add(Items.Text);
      ListItem.SubItems.Add(Items.Days);

      ListItem.SubItems.Add(FormatDateTime('hh:mm', WeeklyDateTimePicker.DateTime));
      Items.BackColor := SetColorName(Items.GroupIdNum);
      ListItem.SubItems.Add(Items.BackColor);

      // 次回追加予定日は とりあえず明日の日付
      ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd',System.DateUtils.Tomorrow));
      ListItem.SubItems.Add(Items.Run);


      // 初期化 ---------------------------------------------------------
      WeeklyDateTimePicker.Time := StrToTime(DefaultTimeString);
      WeeklyColorBox.Selected := clWhite;
      Finalize(CheckedWeekDay);
      WeekdayCheckListBox.CheckAll(cbUnchecked, false, false);
      WeekdayCheckListBoxClickCheck(Sender);
    end;
    2: // 毎月
    begin
      // 前処理 ---------------------------------------------------------
      Items.Text := Trim(MonthlyLabeledEdit.Text);
      Items.Run := GetString_OnOff(MonthlyCheckBox.Checked);
      Items.ExpectedDate := Now;

      if MonthlyComboBoxDay.ItemIndex = 31 then // 月末か判定
      begin
        // 月末の日にちを代入
        TempStr := System.DateUtils.DaysInAMonth(System.DateUtils.YearOf(Items.ExpectedDate),
                                                 System.DateUtils.MonthOf(Items.ExpectedDate)).ToString;
      end
      else
      begin
        TempStr := MonthlyComboBoxDay.Text;
      end;
      TempStr := TempStr.Trim; // 念のため
      MonthlyDateTimePicker.Date := EncodeDate(System.DateUtils.YearOf(Items.ExpectedDate),
                                               System.DateUtils.MonthOf(Items.ExpectedDate),
                                               TempStr.ToInteger);

      // LoopListView1 への追加処理 -------------------------------------
      ListItem.GroupID := Items.GroupIdNum;
      ListItem.Caption := 'M' + Items.Index.ToString;
      ListItem.SubItems.Add(Items.Text);

      if MonthlyComboBoxDay.ItemIndex = 31 then // 月末か判定
      begin
        ListItem.SubItems.Add(MonthlyComboBoxDay.Text);
      end
      else
        ListItem.SubItems.Add(MonthlyComboBoxDay.Text + '日');

      ListItem.SubItems.Add(FormatDateTime('hh:mm', MonthlyDateTimePicker.DateTime));
      Items.BackColor := SetColorName(Items.GroupIdNum);
      ListItem.SubItems.Add(Items.BackColor);

      // 今月中に次回追加予定日があるか判定する -------------------------
      // 次回追加予定日の処理
      if CompareDateTime(MonthlyDateTimePicker.DateTime, Now) = 1 then
        // 実行時の年月日時分を過ぎていなければそのまま追加
        ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd',MonthlyDateTimePicker.Date))
      else
        // 実行時の年月日時分を過ぎていれば来月の日付を追加
        begin
          if TempStr.ToInteger < 29 then // 1-28日まで
            begin
              if System.DateUtils.MonthOf(Items.ExpectedDate) = 12 then // 実行時が12月だったら
              begin
                MonthlyDateTimePicker.Date := EncodeDate(System.DateUtils.YearOf(Items.ExpectedDate)+1,
                                                         1, TempStr.ToInteger);
                ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd', MonthlyDateTimePicker.Date));
              end
              else
              begin
                MonthlyDateTimePicker.Date := EncodeDate(System.DateUtils.YearOf(Items.ExpectedDate),
                                                         System.DateUtils.MonthOf(Items.ExpectedDate)+1,
                                                         TempStr.ToInteger);
                ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd', MonthlyDateTimePicker.Date));
              end;
            end
        else
        begin
          ListItem.SubItems.Add('yyyy/mm/dd');
        end;

//        29日は翌月が2月の場合考慮すべし
//        30-31日は翌月にあるか確認必須

//        ListItem.SubItems.Add(FormatDateTime('yyyy/mm/dd',System.DateUtils.Tomorrow));
//      ShowMessage( FormatDateTime('yyyy/mm/dd', MonthlyDateTimePicker.Date) + #13#10 +
//                   FormatDateTime('hh:mm', MonthlyDateTimePicker.DateTime)
//      );



        end;



      ListItem.SubItems.Add(Items.Run);

      // 初期化 ---------------------------------------------------------
      MonthlyDateTimePicker.Time := StrToTime(DefaultTimeString);
      MonthlyColorBox.Selected := clWhite;
    end;
    else
      begin
        ShowMessage('LoopAddButtonClick' + Str_FunctionCalled_an_UnexpectedArgument);
      end;
  end;
end;

procedure TForm2.LoopDeleteButtonClick(Sender: TObject);
var
  ComfirmString: string;
begin
  if Assigned(LoopListView1.Selected) then
  begin
    ComfirmString := 'ID: ' + LoopListView1.Selected.Caption + sLineBreak +
      LoopListView1.Selected.SubItems.Text + ' を削除しますか？';

    if MessageDlg(ComfirmString, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LoopListView1.Selected.Delete;
      LoopDeleteButton.Enabled := false;
    end;
  end;
end;

procedure TForm2.LoopListView1Click(Sender: TObject);
var
  Items: LoopListViewItem;
  tmpOn: string;
begin // 2つ条件無いと削除した後にLoopListView1の下の方をクリックするとエラーメッセージが出る
  if (LoopListView1.Items.Count > 0 ) and (LoopListView1.ItemIndex >= 0)then
  begin
  // データ取得部  ---------------------------------------------------------
    Items.Index := LoopListView1.ItemIndex;
    Items.GroupIdNum := LoopListView1.Items[Items.Index].GroupID;
    Items.IDnum := LoopListView1.Items[Items.Index].Caption;
    Items.Text  := LoopListView1.Items[Items.Index].SubItems[0];
    if LoopListView1.Items[Items.Index].SubItems.Count > 1 then
      Items.Days  := LoopListView1.Items[Items.Index].SubItems[1];
    if LoopListView1.Items[Items.Index].SubItems.Count > 2 then
    begin
      Items.Time  := LoopListView1.Items[Items.Index].SubItems[2] + ':00'; // 「 + ':00'」は後に削除
      Items.Time := ToHankaku(Items.Time);
    end;
    if LoopListView1.Items[Items.Index].SubItems.Count > 3 then
      Items.BackColor    := LoopListView1.Items[Items.Index].SubItems[3];
//    Items.ExpectedDate := LoopListView1.Items[Items.Index].SubItems[4];
    if LoopListView1.Items[Items.Index].SubItems.Count > 5 then
    begin
      if LoopListView1.Items[Items.Index].SubItems[5].isEmpty then
        Items.Run := 'True'
      else
      begin
        tmpOn := LoopListView1.Items[Items.Index].SubItems[5].ToUpper;
        if tmpon = 'OFF' then
          Items.Run := 'False'
        else
          Items.Run := 'True';
      end;
    end
    else
    begin
      Items.Run := 'True';
    end;

  // null対策 = 初期値？代入 -----------------------------------------------
  if Items.BackColor = '' then
    Items.BackColor := 'clWhite';
  if Items.Run = '' then
    Items.Run := 'True';

  // クリックでデータを切り替えて読み込み ------------------------------------
    PageControl1.ActivePageIndex := Items.GroupIdNum;
    case Items.GroupIdNum of
      0:
      begin
        DailyLabeledEdit.Text    := Items.Text;
        DailyDateTimePicker.Time := strToTime(Items.Time);
        DailyColorBox.Selected   := StringToColor(Items.BackColor);
        DailyCheckBox.Checked    := Items.Run.ToBoolean;
      end;
      1:
      begin
        WeeklyLabeledEdit.Text    := Items.Text;
        WeeklyDateTimePicker.Time := strToTime(Items.Time);
        WeeklyColorBox.Selected   := StringToColor(Items.BackColor);
        WeeklyCheckBox.Checked    := Items.Run.ToBoolean;
      end;
      2:
      begin
        MonthlyLabeledEdit.Text := Items.Text;

        if Items.Days = '月末(実装予定)' then
        begin
          Items.Days := '32'
        end
        else
        begin
          Items.Days := Items.Days.Replace('日', '')
        end;
        MonthlyComboBoxDay.ItemIndex := Items.Days.ToInteger -1;
        MonthlyDateTimePicker.Time := strToTime(Items.Time);
        MonthlyColorBox.Selected   := StringToColor(Items.BackColor);
        MonthlyCheckBox.Checked    := Items.Run.ToBoolean;
      end;
    else
      begin
        ShowMessage('LoopListView1Click' + Str_FunctionCalled_an_UnexpectedArgument);
      end;
    end;

  end;
end;

procedure TForm2.LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Assigned(LoopListView1.Selected) then
    begin
      LoopDeleteButton.Enabled := true;
      LoopEditButton.Enabled := true;
    end
  else
    begin
      LoopDeleteButton.Enabled := false;
      LoopEditButton.Enabled := false;
    end
end;

procedure TForm2.OKButtonClick(Sender: TObject);
var
  IsSave: Boolean;
begin
  IsSave := true;
  SaveLoopSettings(Sender);
  Form2.FormCloseQuery(Sender, IsSave);
end;

procedure TForm2.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: // 毎日
      begin
        DailyLabeledEditChange(Sender);
      end;
    1: // 毎週
      begin
        WeeklyLabeledEditChange(Sender);
      end;
    2: // 毎月
      begin
        MonthlyLabeledEditChange(Sender);
      end;
  else
    begin
      ShowMessage('LoopListView1SelectItem' + Str_FunctionCalled_an_UnexpectedArgument);
    end;
  end;

end;

function TForm2.LabelEditTextChange(TextLength: Integer): Boolean;
begin
  if TextLength > 0 then
    Result := True
  else
    Result := False;
end;

procedure TForm2.LoadLoopSettings(Sender: TObject); // 2020年1月15日作業開始
var
  SettingsIniFileName, LoopID: string;
  SettingsIniFile: TMemIniFile;
begin
  SettingsIniFileName := ExtractFilePath(Application.ExeName) + AppName + '.ini';

  if FileExists(SettingsIniFileName) then // SettingsIniFile が存在チェックする
  begin
    SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);

    ShowMessage('IniFile はあります');
//    ShowMessage(SettingsIniFile.GetStrings());
  end
  else
    ShowMessage('IniFile is no');
end;

procedure TForm2.SaveLoopSettings(Sender: TObject); // 2020年1月15日追加
var
  SettingsIniFileName, LoopID: string;
  SettingsIniFile: TMemIniFile;
  I: Integer;
begin
  if LoopListView1.Items.Count > 0 then
  begin
    SettingsIniFileName := ExtractFilePath(Application.ExeName) + AppName + '.ini';
    SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);

    try
      for I := 0 to LoopListView1.Items.Count - 1 do
      begin
        LoopID := LoopListView1.Items[I].Caption;
        SettingsIniFile.WriteString(LoopID, 'GroupID', LoopListView1.Items[I].GroupID.ToString);
        if LoopListView1.Items[I].SubItems.Count > 0 then  // 項目
          SettingsIniFile.WriteString(LoopID, 'Item', LoopListView1.Items[I].SubItems.Strings[0]);
        if LoopListView1.Items[I].SubItems.Count > 1 then  // 実行日
          SettingsIniFile.WriteString(LoopID, 'Day', LoopListView1.Items[I].SubItems.Strings[1]);
        if LoopListView1.Items[I].SubItems.Count > 2 then  // 追加時刻
        begin
          SettingsIniFile.WriteString(LoopID, 'Time', LoopListView1.Items[I].SubItems.Strings[2]);
          if LoopListView1.Items[I].SubItems.Count > 3 then // 背景色
          begin
            SettingsIniFile.WriteString(LoopID, 'BackgroundColor',LoopListView1.Items[I].SubItems.Strings[3]);
          end;
        end;
      end;
      SettingsIniFile.UpdateFile;
    finally
      SettingsIniFile.Free;
    end;

  end;
end;

function TForm2.ToHankaku(text: String): String;
const
  Dis = $FEE0;
var
  Str   : String;
  i     : Integer;
  AChar : Cardinal;
begin
  Str := '';

  for i := 1 to Length(Text) do begin
    AChar := Ord(Text[i]);
    if (AChar >= $FF10) and (AChar <= $FF5A) then begin
      Str := Str + Chr(AChar - Dis);
    end else begin
      Str := Str + Text[i];
    end;
  end;

  result := Str;
end;


function TForm2.SetColorName(GroupIdNum: Integer): String;
var
  I: Int8;
begin
  case GroupIdNum of
    0: // 毎日
      begin
        I := DailyColorBox.ItemIndex;
        if (I >= 0) then
          Result := DailyColorBox.ColorNames[I];
      end;
    1: // 毎週
      begin
        I := WeeklyColorBox.ItemIndex;
        if (I >= 0) then
          Result := WeeklyColorBox.ColorNames[I];
      end;
    2: // 毎月
      begin
        I := MonthlyColorBox.ItemIndex;
        if (I >= 0) then
          Result := MonthlyColorBox.ColorNames[I];
      end;
  else
    begin
      ShowMessage('SetColorName' + Str_FunctionCalled_an_UnexpectedArgument);
    end;
  end;
end;

end.
