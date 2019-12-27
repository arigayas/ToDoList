﻿unit Setting_Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst,
  Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls, System.UITypes{, VCLTee.TeCanvas};

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
    MonthlyLabeledEdit: TLabeledEdit;
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
    procedure LoopAddButtonClick(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure LoopDeleteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure PageControl1Change(Sender: TObject);
    procedure WeekdayCheckListBoxClickCheck(Sender: TObject);
    function WeekdayCheckedCount(ItemsCount: Integer; WeekdayFlag: Integer): Integer;
    procedure MonthlyLabeledEditChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function SetColorName(GroupIdNum: Integer): String;
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

  LoopListView1.ViewStyle := vsIcon; // 起動時に1つ目のグループのヘッダー(毎日)が
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

procedure TForm2.ColorListBox1Click(Sender: TObject);
begin
  // ShowMessage( ColorListBox1.ColorNames[ColorListBox1.Selected] ); // 試しにダブルクリックした色を表示する。
end;

procedure TForm2.MonthlyLabeledEditChange(Sender: TObject);
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

procedure TForm2.LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Assigned(LoopListView1.Selected) then
    LoopDeleteButton.Enabled := true
  else
    LoopDeleteButton.Enabled := false;
end;

procedure TForm2.OKButtonClick(Sender: TObject);
var
  IsSave: Boolean;
begin
  IsSave := true;
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
        MonthlyLabeledEditChange(Sender);
      end;
  else
    begin
      ShowMessage('LoopListView1SelectItem' + Str_FunctionCalled_an_UnexpectedArgument);
    end;
  end;

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
