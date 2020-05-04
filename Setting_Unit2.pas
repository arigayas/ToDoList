unit Setting_Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst,
  Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls, System.UITypes, System.IniFiles;

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
    procedure WeekdayCheckListBoxClickCheck(Sender: TObject);
    function WeekdayCheckedCount(ItemsCount: Integer; WeekdayFlag: Integer): Integer;
    procedure MonthlyLabeledEdit22Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure WeekdayCheckListBoxDblClick(Sender: TObject);
    procedure LoopListView1Click(Sender: TObject);

  private
    function SetColorName(GroupIdNum: Integer): String;
    procedure SaveLoopSettings(Sender: TObject);
    procedure LoadLoopSettings(Sender: TObject);
    function ToHankaku(text: String): String;
    { Private 宣言 }
  public
    { Public 宣言 }
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
  LoopAddButton.Enabled := true;

  DailyColorBox.Style := [cbStandardColors, cbPrettyNames];
  WeeklyColorBox.Style := [cbStandardColors, cbPrettyNames];
  MonthlyColorBox.Style := [cbStandardColors, cbPrettyNames];
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

procedure TForm2.WeekdayCheckListBoxClickCheck(Sender: TObject);
var
  WeekdayItems: Int8;
begin
  WeekdayItems := 7;
  if (WeekdayCheckedCount(WeekdayItems, 0) = 0) or (WeekdayCheckedCount(WeekdayItems, 0) = 7) then
  begin
    LoopAddButton.Enabled := false;
  end
  else
  begin
    LoopAddButton.Enabled := true;
  end;
end;

procedure TForm2.WeekdayCheckListBoxDblClick(Sender: TObject);
var
  IndexNum: Integer;
begin
  // チェックマークのオンオフを文字列部分でも行う
  IndexNum := WeekdayCheckListBox.ItemIndex;
  WeekdayCheckListBox.Checked[IndexNum] := not WeekdayCheckListBox.Checked[IndexNum];

  WeekdayCheckListBoxClickCheck(Sender);
end;

procedure TForm2.CancelButtonClick(Sender: TObject);
begin
  LoadLoopSettings(Sender);
end;

procedure TForm2.ColorListBox1Click(Sender: TObject);
begin
  // ShowMessage( ColorListBox1.ColorNames[ColorListBox1.Selected] ); // 試しにダブルクリックした色を表示する。
end;

procedure TForm2.MonthlyLabeledEdit22Change(Sender: TObject);
var
  everyMonth: Int8;
begin
  if MonthlyLabeledEdit.Text = '' then
  begin
    LoopAddButton.Enabled := false;
  end
  else
  begin
    LoopAddButton.Enabled := true;
    everyMonth := StrToInt(MonthlyLabeledEdit.Text);

    (*
      if (everyMonth > 0) or (everyMonth < 32) then
      begin
      ShowMessage('1以上');
      end
      else
      begin
      ShowMessage('0');
      end;
    *)
  end;
end;

procedure TForm2.LoopAddButtonClick(Sender: TObject);
var
  ListItem: TListItem;
  GroupIdNum: Integer;
  Ans: Boolean;
  ListItemID, NewString, TempStr, WeekString, ColorName: string;
const
  TimeString = '12:00:00';
begin
  GroupIdNum := PageControl1.ActivePageIndex;
  ListItem := LoopListView1.Items.Add;
  ListItemID := Format('%.3d', [LoopListView1.Items.Count]);

  Ans := InputQuery(AppName + ' Input', '追加したい情報を入力してください。', NewString);

  if Ans = true then
  begin
    if NewString = '' then
    begin
      MessageDlg('何か入力してください', mtInformation, [mbOk], 0);
      LoopAddButtonClick(Sender);
    end
    else
    begin
      NewString := Trim(NewString); // 文字列の前後の空白を除去

      case GroupIdNum of
        0: // 毎日
          begin
            ListItem.GroupID := GroupIdNum;
            ListItem.Caption := 'D' + ListItemID;
            ListItem.SubItems.Add(NewString);
            ListItem.SubItems.Add('毎日');

            ListItem.SubItems.Add(FormatDateTime('hh:mm', DailyDateTimePicker.DateTime));
            DailyDateTimePicker.Time := StrToTime(TimeString);

            ColorName := SetColorName(GroupIdNum);
            ListItem.SubItems.Add(ColorName);
            DailyColorBox.Selected := clWhite;
          end;
        1: // 毎週
          begin
            ListItem.GroupID := GroupIdNum;
            ListItem.Caption := 'W' + ListItemID;
            ListItem.SubItems.Add(NewString);

            WeekdayCheckedCount(7, 1);
            for TempStr in CheckedWeekDay do
            begin
              WeekString := WeekString + TempStr;
            end;
            ListItem.SubItems.Add(WeekString);

            ListItem.SubItems.Add(FormatDateTime('hh:mm', WeeklyDateTimePicker.DateTime));
            WeeklyDateTimePicker.Time := StrToTime(TimeString);

            ColorName := SetColorName(GroupIdNum);
            ListItem.SubItems.Add(ColorName);
            WeeklyColorBox.Selected := clWhite;

            Finalize(CheckedWeekDay);
            WeekdayCheckListBox.CheckAll(cbUnchecked, false, false);
            WeekdayCheckListBoxClickCheck(Sender);
          end;
        2: // 毎月
          begin
            ListItem.GroupID := GroupIdNum;
            ListItem.Caption := 'M' + ListItemID;
            ListItem.SubItems.Add(NewString);
            ListItem.SubItems.Add(MonthlyLabeledEdit.Text + '日');

            ListItem.SubItems.Add(FormatDateTime('hh:mm', MonthlyDateTimePicker.DateTime));
            MonthlyDateTimePicker.Time := StrToTime(TimeString);

            ColorName := SetColorName(GroupIdNum);
            ListItem.SubItems.Add(ColorName);
            MonthlyColorBox.Selected := clWhite;
          end;
      else
        begin
          ShowMessage('LoopAddButtonClick' + Str_FunctionCalled_an_UnexpectedArgument);
        end;
      end;
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
type LoopListViewItem = record
  Index: Integer;
  GroupIdNum   : Int16;
  IDnum: string;
  Text : string;
  Days : string;  // 毎日か曜日か日付か
  Time : string;
  BackColor    : string;
  ExpectedDate : Tdate ;
  Run  : string;  // 実行の有効/無効
  end;
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
        LoopAddButton.Enabled := true;
      end;
    1: // 毎週
      begin
        // LoopAddButton.Enabled := false;
        WeekdayCheckListBoxClickCheck(Sender);
      end;
    2: // 毎月
      begin
        // LoopAddButton.Enabled := false;
        MonthlyLabeledEdit22Change(Sender);
      end;
  else
    begin
      ShowMessage('LoopListView1SelectItem' + Str_FunctionCalled_an_UnexpectedArgument);
    end;
  end;

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
