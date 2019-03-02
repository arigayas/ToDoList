unit ToDoList_Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  System.UITypes, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  Vcl.ExtCtrls, System.Types, System.IniFiles;

type
  TForm1 = class(TForm)
    AddItemButton: TButton;
    DeleteButton: TButton;
    CheckListBox1: TCheckListBox;
    Memo1: TMemo;
    ReplaceButton: TButton;
    PopupMenu1: TPopupMenu;
    DeleteAllChecked: TMenuItem;
    SwitchTaskTray: TMenuItem;
    TrayIcon1: TTrayIcon;
    BR_N1: TMenuItem;
    Setting_N1: TMenuItem;
    procedure AddItemButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure CheckListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure ReplaceButtonClick(Sender: TObject);
    procedure CheckListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CheckListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DeleteAllCheckedClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SwitchTaskTrayClick(Sender: TObject);
    procedure CheckListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BR_N1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Setting_N1Click(Sender: TObject);
  private
    FQueryEndSession : Boolean; // Windows終了時(シャットダウン)の処理に使用
    procedure CheckListBox1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure CheckListCounterFormCaption(Sender: TObject);
    procedure DrawMoveLine(CheckListBox1: TCheckListBox; const Index: Integer);
    function ItemsCheckedCount(ItemsCount: Integer): Integer;
    procedure Savefile(Sender: TObject; EndFlag: Boolean);
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession);
        message WM_QUERYENDSESSION;
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

const
  AppName = 'ToDoList';

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Setting_Unit2;

var
  FileName: string;
  LInput: TFileStream;
  PrevItemIndex: Integer; // D&D 用の変数

procedure LockFile;
begin
  if FileExists(FileName) then
    LInput := TFileStream.Create(FileName, fmOpenWrite or fmShareDenyWrite);
end;

procedure UnlockFile;
begin
  if Assigned(LInput) then
    FreeAndNil(LInput);
end;


procedure TForm1.AddItemButtonClick(Sender: TObject);
var
  Ans: Boolean;
  NewString: string;
begin
  Ans := InputQuery(AppName +' Input', '追加したい情報を入力してください。', NewString);

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
      CheckListBox1.Items.Add(NewString);
      Memo1.Lines := CheckListBox1.Items;

      Savefile(Sender, false);
      CheckListCounterFormCaption(Sender);
    end;

  end;
end;

// チェックマークの数でボタンのON/OFFを行う
procedure TForm1.BR_N1Click(Sender: TObject);
begin
  if BR_N1.Checked then
  begin
    BR_N1.Caption := 'ウィンドウの幅で折り返す';
    BR_N1.Checked := True;
  end
  else
  begin
    BR_N1.Caption := 'ウィンドウの幅で折り返さない';
    BR_N1.Checked := False;
  end;

end;

procedure TForm1.CheckListBox1ClickCheck(Sender: TObject);
var
  ItemsChecked, ItemsCount: Integer;
begin
  ItemsCount := CheckListBox1.Count;

  if ItemsCount > 0 then
  begin
    ItemsChecked := ItemsCheckedCount(ItemsCount);

    if ItemsChecked > 0 then
    begin
      DeleteButton.Enabled := True;
      DeleteAllChecked.Enabled := True;

      // チェックボックスにチェックマークが2つあったらReplaceButtonを有効にする
      if ItemsChecked = 2 then
        ReplaceButton.Enabled := True
      else
        ReplaceButton.Enabled := False;
    end
    else
    begin
      DeleteButton.Enabled := False;
      DeleteAllChecked.Enabled := False;
    end
  end;
end;

procedure TForm1.CheckListBox1DblClick(Sender: TObject);
var
  Ans: Boolean;
  NewString: string;
begin
  NewString := CheckListBox1.Items[CheckListBox1.ItemIndex];
  Ans := InputQuery(AppName +' Input', '編集したい情報を入力してください。', NewString);

  if Ans = True then
  begin
    if NewString = '' then
      MessageDlg('何か入力するか、削除ボタンを押してください', mtInformation, [mbOk], 0)
    else
    begin
      NewString := Trim(NewString); // 文字列の前後の空白を除去
      CheckListBox1.Items[CheckListBox1.ItemIndex] := NewString;
      Memo1.Lines := CheckListBox1.Items;

      Savefile(Sender, false);
    end;

  end;
end;

// ドラッグ&ドロップに関しては以下のブログを参考にした。
// kazina製ソフトあれこれ: リストボックスの項目をドラッグ&ドロップで並べ替える
// http://kazina.seesaa.net/article/20064657.html
procedure TForm1.CheckListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  idx: Integer;
begin
  // CheckListBox1.AddItem(CheckListBox1.Items[CheckListBox1.ItemIndex], Source);
  // カーソルのある位置のアイテムインデックスを取得。
  idx := TCheckListBox(Source).ItemAtPos(Point(X, Y), True);

  // 直前のドロップ先表示用罫線を消す
  DrawMoveLine(TCheckListBox(Sender), PrevItemIndex);

  // 並べ替える
  if idx <> -1 then
    TCheckListBox(Sender).Items.Move(TCheckListBox(Sender).ItemIndex, idx);
end;

procedure TForm1.CheckListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  idx: Integer;
begin
  // 自分自身からのドラッグのみ許可する。
  // また、選択されている項目（移動するアイテム）がないとダメ。
  // 上記にあてはまらない場合、直ちに処理を抜ける。
  Accept := (Source = Sender) and (TCheckListBox(Source).ItemIndex <> -1);
  if not Accept then
    Exit;

  // カーソルのある位置のアイテムインデックスを取得。
  idx := TCheckListBox(Source).ItemAtPos(Point(X, Y), True);

  // 直前のドロップ先表示用罫線を消す
  DrawMoveLine(TCheckListBox(Sender), PrevItemIndex);

  // 新しいドロップ先表示用罫線を描画する
  DrawMoveLine(TCheckListBox(Sender), idx);

  PrevItemIndex := idx;

end;

procedure TForm1.CheckListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Offset: Integer;
begin
  with CheckListBox1.Canvas Do
  begin
    if odSelected in State then
      Brush.Color := clHighlight // 選択時の背景色
    else if CheckListBox1.Checked[Index] then
      Brush.Color := clSkyBlue; // チェックした行の背景色

    FillRect(Rect);
    Offset := 2;
    TextOut(Rect.Left + Offset, Rect.Top, CheckListBox1.Items[Index])

  end;

  (* // 折り返し機能古いDelphiでは機能した模様
    with (Control as TCheckListBox) do
    begin
    Canvas.FillRect(Rect);

    //見た目の調整
    //もちろんこういう固定値の直書きはよくないはずなのだけど
    //VCLのソース(StdCtrls.pas TCustomListBox.DrawItem)にもこう書いてあるし……
    if not UseRightToLeftAlignment then
    Inc(Rect.Left, 2)
    else
    Dec(Rect.Right, 2);

    DrawText(Canvas.Handle, PChar(Items[Index]), -1, Rect, DT_WORDBREAK);
    end;
  *)
end;

procedure TForm1.CheckListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
    DeleteButtonClick(Sender);

  if (Key = VK_RETURN) then
  begin
    if (CheckListBox1.Count > 0) and (CheckListBox1.ItemIndex >= 0) then
    begin
      if MessageDlg('”はい”を選んだ場合は選択項目を編集します。' + sLineBreak +
        '”いいえ”を選んだ場合は項目を追加します。', mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then
        CheckListBox1DblClick(Sender)
      else
        AddItemButtonClick(Sender);
    end
    else
    begin
      AddItemButtonClick(Sender);
    end;
  end;

{$IFDEF DEBUG}
  if (Key = VK_INSERT) then
  begin
    ShowMessage('色：' + IntToStr(CheckListBox1.Canvas.Pen.Color));
    ShowMessage('線の太さ：' + IntToStr(CheckListBox1.Canvas.Pen.Width));
    ShowMessage(CheckListBox1.Items[CheckListBox1.ItemIndex]);
  end;
{$ENDIF}
end;

procedure TForm1.CheckListCounterFormCaption(Sender: TObject);
begin
  Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' 件';

{$IFDEF DEBUG}
  Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString +
    ' 件 ::DEBUG::';
{$ENDIF}
end;

// 移動先を示す罫線を描画する手続き
procedure TForm1.DrawMoveLine(CheckListBox1: TCheckListBox;
  const Index: Integer);
var
  r: TRect;
  Y: Integer;
begin
  CheckListBox1.Canvas.Pen.Mode := pmXor;
  CheckListBox1.Canvas.Pen.Color := $00FFFF00;
  CheckListBox1.Canvas.Pen.Width := 5;
  if Index <> -1 then
  begin
    r := CheckListBox1.ItemRect(Index);
    if CheckListBox1.ItemIndex < Index then
      Y := r.Bottom
    else
      Y := r.Top;

    CheckListBox1.Canvas.MoveTo(0, Y);
    CheckListBox1.Canvas.LineTo(CheckListBox1.Width, Y);
  end;
  CheckListBox1.Canvas.Pen.Width := 1; // チェックボックスの枠が太くなるので戻す
end;

procedure TForm1.DeleteButtonClick(Sender: TObject);
// チェックボックスにチェックがあるアイテムを削除する
var
  ItemsCount, ItemsChecked, I, J: Integer;
  iArr: array of Integer; // 動的配列の宣言
begin
  ItemsCount := CheckListBox1.Count;
  ItemsChecked := 0;
  J := 0;
  Memo1.Clear;

  ItemsChecked := ItemsCheckedCount(ItemsCount); // チェックボックスにチェックがある数を調べる
  if ItemsChecked > 0 then // Deleteキーから実行時用にチェック数を確認
  begin
    SetLength(iArr, ItemsChecked); // 配列の長さを決める
    for I := 0 to ItemsCount - 1 do
    begin
      if CheckListBox1.Checked[I] = True then
      begin
        iArr[J] := I; // チェックボックスにチェックがあるアイテムのインデックス取得
        Inc(J);
      end;
    end;

    for I := ItemsChecked - 1 downto 0 do // リストは最後から削除しないと「範囲を超える」エラーになる
    begin
      Memo1.Lines.Add('インデックス番号：' + iArr[I].ToString);
      CheckListBox1.Items.Delete(iArr[I]);
    end;
{$IFDEF DEBUG}
    ShowMessage(ItemsChecked.ToString + '個 削除しました。');
{$ENDIF}
    Finalize(iArr);
    ReplaceButton.Enabled := False;
    DeleteButton.Enabled := False;
    DeleteAllChecked.Enabled := False;
    CheckListCounterFormCaption(Sender);

  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FQueryEndSession then begin
    FQueryEndSession := false;
    //ウィンドウズが終了する場合の処理
      FormDestroy(Sender);
  end;

  if CanClose then
  begin
    //普通にフォームが閉じられた場合の処理
    FormDestroy(Sender);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FStream: TStringList;
  I: Integer;
//  WRect: TRect;
//  SettingsIniFile : TIniFile;
  SettingsIniFile : TMemIniFile;
  SettingsIniFileName : string;
begin
  Memo1.Visible := False;
  DeleteButton.Enabled := False;
  BR_N1.Checked := False;
  SettingsIniFileName := AppName + '.ini';
  SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);
//  SettingsIniFile := TIniFile.Create(SettingsIniFileName);

  try
    Form1.Top := SettingsIniFile.ReadInteger('Form', 'Top', 100);
    Form1.Left := SettingsIniFile.ReadInteger('Form', 'Left', 100);
    Form1.Width := SettingsIniFile.ReadInteger('Form', 'WindowWidth', 350);
    Form1.Height := SettingsIniFile.ReadInteger('Form','WindowHeight', 250);

(*
      if Left > WRect.Right - 100 then Form1.Left := WRect.Left; // モニタの解像度が変わっても
      if Left < WRect.Left then Form1.Left := WRect.Left;        // 大丈夫にする処理(4行)
      if Top < WRect.Top then Form1.Top := WRect.Top;
      if Top > WRect.Bottom - 100 then Form1.Top := WRect.Top;
    
*)  finally
    SettingsIniFile.Free;
  end;
  
{$IFDEF DEBUG}
  Memo1.Visible := True;

  // ファイル[ToDoList.txt]がない場合使われる
  for I := 1 to 10 do
    CheckListBox1.Items.Add(I.ToString);
{$ENDIF}

  FileName := AppName + '.txt';
  // FileName[ToDoList.txt]があるか？

  if FileExists(FileName) then
  begin
    FStream := TStringList.Create;
    FStream.LoadFromFile(FileName);

    CheckListBox1.Items := FStream;

    FStream.Free;
  end;

  LockFile;
  DeleteAllChecked.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
//  SettingsIniFile : TIniFile;
  SettingsIniFile : TMemIniFile;
  SettingsIniFileName : string;
begin

  SettingsIniFileName := ExtractFilePath(Application.ExeName) + AppName +'.ini';
  SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);
//  SettingsIniFile := TIniFile.Create(SettingsIniFileName);
  UnlockFile;
  LInput.Free;
  try
    SettingsIniFile.WriteInteger('Form', 'Top', Form1.Top);
    SettingsIniFile.WriteInteger('Form', 'Left', Form1.Left);
    SettingsIniFile.WriteInteger('Form', 'WindowWidth', Width);
    SettingsIniFile.WriteInteger('Form', 'WindowHeight', Height);
    SettingsIniFile.UpdateFile;
  finally
    SettingsIniFile.Free;
    Savefile(Sender, true);
//    LInput.Free;
  end;

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  CheckListCounterFormCaption(Sender);
end;

function TForm1.ItemsCheckedCount(ItemsCount: Integer): Integer;
var
  ItemsChecked, I: Integer;
begin
  ItemsChecked := 0;
  // チェックボックスにチェックがある数を調べる
  for I := 0 to ItemsCount - 1 do
    if CheckListBox1.Checked[I] = True then
    begin
      Inc(ItemsChecked);

    end;
  Result := ItemsChecked;
end;

procedure TForm1.CheckListBox1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  PrevItemIndex := -1;
end;

procedure TForm1.DeleteAllCheckedClick(Sender: TObject); // すべてのチェックを外す
var
  ItemsCount, ItemsChecked: Integer;
begin
  ItemsCount := CheckListBox1.Count;
  ItemsChecked := ItemsCheckedCount(ItemsCount); // チェックボックスにチェックがある数を調べる

  if ItemsChecked > 0 then
  begin
    CheckListBox1.CheckAll(cbunChecked, True, False);
    DeleteAllChecked.Enabled := False;
    DeleteButton.Enabled := False;
    CheckListBox1.Invalidate;
    ReplaceButton.Enabled := False;
  end;
end;

procedure TForm1.ReplaceButtonClick(Sender: TObject);
var
  I, J: Integer;
  iArr: array [0 .. 1] of Integer;
  tempString: string;
begin
  tempString := '';
  iArr[0] := 0;
  iArr[1] := 0;
  J := 0;

  for I := 0 to CheckListBox1.Count - 1 do
  begin
    if CheckListBox1.Checked[I] = True then
    begin
      iArr[J] := I; // チェックボックスにチェックがあるアイテムのインデックス取得
      Inc(J);
    end;
  end;
  Memo1.Clear;
  Memo1.Lines.Add('インデックス番号0：' + iArr[0].ToString + ' | ' + CheckListBox1.Items
    [iArr[0]]);
  Memo1.Lines.Add('インデックス番号1：' + iArr[1].ToString + ' | ' + CheckListBox1.Items
    [iArr[1]]);

  tempString := CheckListBox1.Items[iArr[0]];
  CheckListBox1.Items[iArr[0]] := CheckListBox1.Items[iArr[1]];
  CheckListBox1.Items[iArr[1]] := tempString;

end;

procedure TForm1.Savefile(Sender: TObject; EndFlag: Boolean);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    UnlockFile;
    SL.AddStrings(CheckListBox1.Items);
    SL.SaveToFile(FileName, TEncoding.UTF8);
    if not EndFlag then
    begin
      LockFile;
    end;
  finally
    SL.Free;
  end;
end;

procedure TForm1.Setting_N1Click(Sender: TObject);
begin
  Form2.ShowModal
end;

procedure TForm1.SwitchTaskTrayClick(Sender: TObject);
begin
  if TrayIcon1.Visible = False then
  begin
    TrayIcon1.Visible := True;
    SwitchTaskTray.Caption := 'タスクトレイから出す';
    Screen.Forms[0].Hide;
  end
  else
  begin
    TrayIcon1.Visible := False;
    SwitchTaskTray.Caption := 'タスクトレイに格納する';
    Screen.Forms[0].Show;
    // Formを非表示にしてから表示させると
    // PopUpが無効になるのでAutoPopupを有効にする
    PopupMenu1.AutoPopup := True;
  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
//  ShowMessage('タスクトレイのアイコンをクリックしたら何をさせようか');
  SwitchTaskTrayClick(Sender);
end;

procedure TForm1.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  FQueryEndSession := true;
  inherited;
end;



end.
