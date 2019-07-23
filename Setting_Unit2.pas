﻿unit Setting_Unit2;

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
    LoopDeleteButton: TButton;
    SettingCheckBoxGroup: TGroupBox;
    fontBiggerCheckBox: TCheckBox;
    ValueListEditor1: TValueListEditor;
    LoopListView1: TListView;
    frontmostCheckBox: TCheckBox;
    OKButton: TButton;
    CancelButton: TButton;
    procedure BR_CheckBox1Click(Sender: TObject);
    procedure LoopAddButtonClick(Sender: TObject);
    procedure LoopCheckListBoxClickCheck(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure fontBiggerCheckBoxClick(Sender: TObject);
    procedure frontmostCheckBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);

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
//  Group: TListGroup;
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
//      ShowMessage(LoopListView1.Items.Count.ToString);
      NewString := Trim(NewString); // 文字列の前後の空白を除去
//      Group := LoopListView1.Groups.Add;
//      Group.Header := 'My header';
      Item := LoopListView1.Items.Add;
//      LoopCheckListBox.Items.Add(NewString);
//      LoopListView1.Items.Add := NewString ;
      Item.Caption := NewString;
      Item.SubItems.Add('***');
      Item.SubItems.Add('*** *');
      Item.SubItems.Add('*** **');
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
  AddItemButtonClick(Sender);
end;

procedure TForm2.LoopCheckListBoxClickCheck(Sender: TObject);
begin
  // 1つ以上ならLoopDeleteButtonを有効にする処理を書く
end;

procedure TForm2.OKButtonClick(Sender: TObject);
begin
  Form2.Close;
end;

end.
