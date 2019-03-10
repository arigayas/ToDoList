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
    ColorListBox1: TColorListBox;
    LoopAddButton: TButton;
    LoopCheckListBox: TCheckListBox;
    LoopDeleteButton: TButton;
    LoopGroupBox: TGroupBox;
    SettingCheckBoxGroup: TGroupBox;
    fontBiggerCheckBox: TCheckBox;
    ValueListEditor1: TValueListEditor;
    ListView1: TListView;
    procedure BR_CheckBox1Click(Sender: TObject);
    procedure LoopAddButtonClick(Sender: TObject);
    procedure LoopCheckListBoxClickCheck(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure fontBiggerCheckBoxClick(Sender: TObject);

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
  NewString: string;
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
      LoopCheckListBox.Items.Add(NewString);
      ListView1.Items.Add.Caption := NewString;
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

procedure TForm2.ColorListBox1Click(Sender: TObject);
begin
  // ShowMessage( ColorListBox1.ColorNames[ColorListBox1.Selected] ); // 試しにダブルクリックした色を表示する。
end;

procedure TForm2.LoopAddButtonClick(Sender: TObject);
begin
  AddItemButtonClick(Sender);
end;

procedure TForm2.LoopCheckListBoxClickCheck(Sender: TObject);
begin
  // 1つ以上ならLoopDeleteButtonを有効にする処理を書く
end;

end.
