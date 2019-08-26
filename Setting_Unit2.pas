unit Setting_Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst,
  Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls, System.UITypes;

type
  TForm2 = class(TForm)
    BR_CheckBox1: TCheckBox;
    ColorGroupBox: TGroupBox;
    LoopAddButton: TButton;
    LoopDeleteButton: TButton;
    SettingCheckBoxGroup: TGroupBox;
    fontBiggerCheckBox: TCheckBox;
    LoopListView1: TListView;
    frontmostCheckBox: TCheckBox;
    OKButton: TButton;
    CancelButton: TButton;
    DateTimePicker1: TDateTimePicker;
    PageControl1: TPageControl;
    DailyTabSheet1: TTabSheet;
    WeeklyTabSheet2: TTabSheet;
    DayTabSheet1: TTabSheet;
    CheckListBox1: TCheckListBox;
    LabeledEdit1: TLabeledEdit;
    DateTimePicker2: TDateTimePicker;
    DailyLabel: TLabel;
    WeeklyLabe: TLabel;
    Label1: TLabel;
    DateTimePicker3: TDateTimePicker;
    procedure BR_CheckBox1Click(Sender: TObject);
    procedure LoopAddButtonClick(Sender: TObject);
    procedure LoopCheckListBoxClickCheck(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure fontBiggerCheckBoxClick(Sender: TObject);
    procedure frontmostCheckBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoopDeleteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);

  private
    procedure AddItemButtonClick(Sender: TObject);
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses ToDoList_Unit1;

procedure TForm2.AddItemButtonClick(Sender: TObject);
var
  Ans: Boolean;
  NewString,SetTime: string;
  Item: TListItem;
  // i: Integer;
begin
  Ans := InputQuery(AppName + ' Input', '追加したい情報を入力してください。', NewString);

  if Ans = True then
  begin
    if NewString = '' then
    begin
      MessageDlg('何か入力してください', mtInformation, [mbOk], 0);
      AddItemButtonClick(Sender);
    end
    else
    begin
      NewString := Trim(NewString); // 文字列の前後の空白を除去
//      Group := LoopListView1.Groups.Add;
//      Group.Header := 'My header';
      Item := LoopListView1.Items.Add;
//      LoopCheckListBox.Items.Add(NewString);
//      LoopListView1.Items.Add := NewString ;
      Item.Caption := NewString;
      Item.SubItems.Add('***');
      Item.SubItems.Add('*** **');
      Item.SubItems.Add(FormatDateTime('hh:mm',DateTimePicker1.DateTime));
      Item.SubItems.Add('*** **');
      // for i := 1 to 20 do
      // LoopCheckListBox.Items.Add(i.ToString);
      // Memo1.Lines := CheckListBox1.Items;

      // Savefile(Sender, false);
      // CheckListCounterFormCaption(Sender);
    end;

  end;
end;

procedure TForm2.BR_CheckBox1Click(Sender: TObject);
begin
  Form2.Caption := Form1.Top.ToString;
end;

procedure TForm2.fontBiggerCheckBoxClick(Sender: TObject); // フォントサイズを倍化
begin
  Form1.Repaint;
  if fontBiggerCheckBox.Checked then
  begin
    Form1.CheckListBox1.ItemHeight := 38;
    Form1.CheckListBox1.Font.Size := 24;
    Form1.CheckListBox1.Font.Height := -32;
  end
  else
  begin
    Form1.CheckListBox1.ItemHeight := 19;
    Form1.CheckListBox1.Font.Size := 12;
    Form1.CheckListBox1.Font.Height := -16;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  LoopListView1.ViewStyle:= vsIcon;    // 起動時に1つ目のグループのヘッダー(毎日)が
  LoopListView1.ViewStyle := vsReport; // 表示されない為の対策の2行。
end;

procedure TForm2.frontmostCheckBoxClick(Sender: TObject); // 最前面にする
// 参照したサイト
// http://kwikwi.cocolog-nifty.com/blog/2005/12/delphi_90fd.html
// https://oshiete.goo.ne.jp/qa/8745468.html
begin
  if frontmostCheckBox.Checked then
  begin
    // 最前面に表示する
//  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
    SetWindowPos(Form1.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);
  end
  else
  begin
    // 普通に戻す
//  SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    SetWindowPos(Form1.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TForm2.CancelButtonClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.ColorListBox1Click(Sender: TObject);
begin
  // ShowMessage( ColorListBox1.ColorNames[ColorListBox1.Selected] ); // 試しにダブルクリックした色を表示する。
end;

procedure TForm2.LoopAddButtonClick(Sender: TObject);
begin
//  AddItemButtonClick(Sender);
  ShowMessage( PageControl1.ActivePageIndex.ToString );
end;

procedure TForm2.LoopCheckListBoxClickCheck(Sender: TObject);
begin
  // 1つ以上ならLoopDeleteButtonを有効にする処理を書く
end;

procedure TForm2.LoopDeleteButtonClick(Sender: TObject);
var
  ComfirmString : string;
begin
// フォーム表示時にListViewの項目が0の場合に削除ボタンを押せなくする処理を書く
  if Assigned(LoopListView1.Selected) then
  begin
    ComfirmString := 'ID: ' + LoopListView1.Selected.Caption + sLineBreak +
                      LoopListView1.Selected.SubItems.Text + ' を削除しますか？';

    if MessageDlg(ComfirmString, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LoopListView1.Selected.Delete;
      LoopDeleteButton.Enabled := False;
    end;
  end;
end;

procedure TForm2.LoopListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Assigned(LoopListView1.Selected) then
    LoopDeleteButton.Enabled := true
  else
    LoopDeleteButton.Enabled := False;
end;

procedure TForm2.OKButtonClick(Sender: TObject);
begin
  Form2.Close;
end;

end.
