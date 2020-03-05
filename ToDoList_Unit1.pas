unit ToDoList_Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  System.UITypes, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  Vcl.ExtCtrls, System.Types, System.IniFiles, Vcl.Consts, Vcl.Clipbrd;

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
    Setting_N1: TMenuItem;
    PopupPasteFromClipboardText: TMenuItem;
    N1: TMenuItem;
    SaveListLog: TMenuItem;
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
    procedure SwitchTaskTrayClick(Sender: TObject);
    procedure CheckListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Setting_N1Click(Sender: TObject);
    // procedure Button1Click(Sender: TObject);
    procedure PasteFromClipboardText(Sender: TObject);
    procedure SaveListLogClick(Sender: TObject);
  private
    FQueryEndSession: Boolean; // Windows終了時(シャットダウン)の処理に使用
    procedure CheckListBox1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure CheckListCounterFormCaption(Sender: TObject; ItemsCount: Integer);
    procedure DrawMoveLine(CheckListBox1: TCheckListBox; const Index: Integer);
    function ItemsCheckedCount(ItemsCount: Integer): Integer;
    procedure Savefile(Sender: TObject; EndFlag: Boolean);
    procedure UpdateData(Sender: TObject; Flag:Integer; NewString: string);
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    function textResize(textIsBig: Boolean): Boolean;
    function AlwaysOnTop(IsAlwaysOnTop: Boolean): Boolean;
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

const
  AppName = 'ToDoList';

// 追加のシステムメニューのID値
// 値は任意の整数値
  MyMenu1 = 101;
  MyMenu2 = 102;
  MyMenu3 = 103;

var
  Form1: TForm1;

implementation


{$R *.dfm}

uses Setting_Unit2;

resourcestring
  Str_LargeFont = 'リストの文字を大きくする';
  Str_SmallFont = 'リストの文字を小さくする';
  Str_Nothing_on_the_Clipboard = 'Clipboard にテキストデータがありません';
  Str_PasteSomethingOtherThanText = 'テキスト以外の物を貼り付けようとしました。';
  Str_VK_RETURN_Yes = '”はい”を選んだ場合は選択項目を編集します。';
  Str_VK_RETURN_No = '”いいえ”を選んだ場合は項目を追加します。';
  Str_GetOut_of_TaskTray = 'タスクトレイから出す';
  Str_Store_in_TaskTray = 'タスクトレイに格納する';
  Str_AlwaysShow_in_Front = '常に手前で表示する';
  Str_FunctionCalled_an_UnexpectedArgument = '関数で想定していない引数が呼ばれました。';
  Str_Saved = ' を保存しました。';

var
  FileName: string;
  LInput: TFileStream;
  PrevItemIndex: Integer; // D&D 用の変数
  // ItemsCount: Integer;
  hSysmenu : hMenu;   // 追加のシステムメニュー
  AItemCnt : Integer; // 追加のシステムメニュー
  MyMenu1Text, MyMenu2Text, MyMenu3Text: PWideChar;
  textIsBig, IsAlwaysOnTop{, IsWordWrap}: Boolean;
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
  NewString: string;
begin
   // メインフォームが最前面設定時に 入力ダイアログ の表示中はメインフォームの最前面を解除する。
  if IsAlwaysOnTop then
    begin
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を解除
        NewString := '';
        UpdateData(Sender, 0, NewString);
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を実行
    end
    else
    begin
      NewString := '';
      UpdateData(Sender, 0, NewString);
    end;
end;

procedure TForm1.PasteFromClipboardText(Sender: TObject);
var
  clipbrdStrings: TStringList;
  tempstr: string;
  I: Integer;
begin
  clipbrdStrings := TStringList.Create;

  if Clipboard.AsText = '' then // Clipboard にデータがあるかチェック
  begin
    MessageDlg(Str_Nothing_on_the_Clipboard, mtInformation, [mbOk], 0);
  end
  else
  begin
    Memo1.Clear;
    if Clipboard.HasFormat(CF_TEXT) then // Clipboard にあるデータがテキストかチェック
    begin
      clipbrdStrings.Text := Clipboard.AsText;

      for I := 0 to clipbrdStrings.Count - 1 do // Clipboard にあるデータから各行の空白文字除去
      begin
        tempstr := clipbrdStrings.Strings[I].Trim;
        tempstr := tempstr.Replace('　', ' ');  // 全角空白を半角空白に置換
        clipbrdStrings.Strings[I] := tempstr.Trim; // 全角空白だったの空白文字をtrim
      end;

      for I := clipbrdStrings.Count - 1 downto 0 do // Clipboard にあるデータから空行除去
      begin
        if clipbrdStrings.Strings[I] = '' then
          begin
            clipbrdStrings.Delete(i);
          end;
      end;

      // メインフォームが最前面設定時に 入力ダイアログ の表示中はメインフォームの最前面を解除する。
      if IsAlwaysOnTop then
      begin
        IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を解除
          for I := 0 to clipbrdStrings.Count - 1 do
          UpdateData(Sender, 0, clipbrdStrings.Strings[I]);
        IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を実行
      end
      else
      begin
        for I := 0 to clipbrdStrings.Count - 1 do
          UpdateData(Sender, 0, clipbrdStrings.Strings[I]);
      end;
    end
    else
    begin
      MessageDlg(Str_PasteSomethingOtherThanText, mtInformation, [mbOk], 0);
    end;
  end;

  clipbrdStrings.Free;
end;

// チェックマークの数でボタンのON/OFFを行う
procedure TForm1.CheckListBox1ClickCheck(Sender: TObject);
var
  ItemsChecked, ItemsCount: Integer;
begin
  ItemsCount := CheckListBox1.Count;

  if ItemsCount > 0 then
  begin
    ItemsChecked := ItemsCheckedCount(ItemsCount);
    CheckListCounterFormCaption(Sender, ItemsChecked);

    if ItemsChecked > 0 then
    begin
      DeleteButton.Enabled := True;
      DeleteAllChecked.Enabled := True;
      // チェックボックスにチェックマークが2つあったらReplaceButtonを有効にする
      if ItemsChecked = 2 then
        ReplaceButton.Enabled := True
      else
        ReplaceButton.Enabled := false;
    end
    else
    begin
      DeleteButton.Enabled := false;
      DeleteAllChecked.Enabled := false;
    end
  end;
end;

procedure TForm1.CheckListBox1DblClick(Sender: TObject); // 項目の編集
var
  NewString: string;
begin
   // メインフォームが最前面設定時に 入力ダイアログ の表示中はメインフォームの最前面を解除する。
  if IsAlwaysOnTop then
    begin
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を解除
        NewString :='';
        UpdateData(Sender, 1, NewString);
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を実行
    end
    else
    begin
      NewString :='';
      UpdateData(Sender, 1, NewString);
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
      if MessageDlg(Str_VK_RETURN_Yes + sLineBreak + Str_VK_RETURN_No,
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        CheckListBox1DblClick(Sender)
      else
        AddItemButtonClick(Sender);
    end
    else
    begin
      AddItemButtonClick(Sender);
    end;
  end;

  if (Key = VK_ESCAPE) then // Escキーでチェックを全部外す
    DeleteAllCheckedClick(Sender);

  if (Key = 78) then // Nキーで項目追加する
    AddItemButtonClick(Sender);

  if (Key = 80) then // Pキーでクリップボードにあるテキストを追加ボタンを使用せず追加する
    PasteFromClipboardText(Sender);

  if (Key = VK_OEM_PLUS) or (Key = VK_ADD) then
    begin
      textIsBig :=  textResize(textIsBig);
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

procedure TForm1.CheckListCounterFormCaption(Sender: TObject;
  ItemsCount: Integer);
begin
  if ItemsCount > 0 then
  begin
    Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' 件中 ' +
      ItemsCount.ToString + ' 件選択';
{$IFDEF DEBUG}
    Form1.Caption := Form1.Caption + ' ::DEBUG::';
{$ENDIF}
  end
  else
  begin
    Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' 件';
{$IFDEF DEBUG}
    Form1.Caption := Form1.Caption + ' ::DEBUG::';
{$ENDIF}
  end;

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
    ReplaceButton.Enabled := false;
    DeleteButton.Enabled := false;
    DeleteAllChecked.Enabled := false;
    CheckListCounterFormCaption(Sender, ItemsCheckedCount(CheckListBox1.Count));
    if CheckListBox1.Count > 0 then
    begin
      CheckListBox1.SetFocus;
    end
    else
    begin
      AddItemButton.SetFocus;
    end;
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FQueryEndSession then
  begin
    FQueryEndSession := false;
    // ウィンドウズが終了する場合の処理
    FormDestroy(Sender);
  end;

  if CanClose then
  begin
    // 普通にフォームが閉じられた場合の処理
    FormDestroy(Sender);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FStream: TStringList;
  I: Integer;
  // WRect: TRect;
  // SettingsIniFile : TIniFile;
  SettingsIniFile: TMemIniFile;
  SettingsIniFileName: string;

begin
  MyMenu1Text := PWideChar(Str_LargeFont);
  MyMenu2Text := PWideChar(Str_AlwaysShow_in_Front);
{$IFDEF DEBUG}
  MyMenu3Text := 'ウィンドウの幅で折り返す(未実装)';
{$ENDIF}
  textIsBig   := False;
  IsAlwaysOnTop := False;

  //フォームのシステムメニューのハンドルを取得
  hSysmenu := GetSystemMenu(Handle, False);

  //現在の項目数を取得
  AItemCnt := GetMenuItemCount(hSysmenu);

  //現在のメニュー一番下に区切り線(第4,5引数を0にする)を追加
  InsertMenu(hSysmenu, AItemCnt, MF_BYPOSITION, 0, nil);
  //現在のメニューの一番下にメニューを追加
  InsertMenu(hSysmenu, AItemCnt + 1, MF_BYPOSITION, MyMenu1, MyMenu1Text);
  InsertMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION, MyMenu2, MyMenu2Text);
{$IFDEF DEBUG}
  InsertMenu(hSysmenu, AItemCnt + 3, MF_BYPOSITION, MyMenu3, MyMenu3Text);
{$ENDIF}

  Memo1.Visible := false;
  DeleteButton.Enabled := false;
  SettingsIniFileName := AppName + '.ini';
  SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);
  // SettingsIniFile := TIniFile.Create(SettingsIniFileName);

  try
    Form1.Top := SettingsIniFile.ReadInteger('Form', 'Top', 100);
    Form1.Left := SettingsIniFile.ReadInteger('Form', 'Left', 100);
    Form1.Width := SettingsIniFile.ReadInteger('Form', 'WindowWidth', 350);
    Form1.Height := SettingsIniFile.ReadInteger('Form', 'WindowHeight', 250);

    (*
      if Left > WRect.Right - 100 then Form1.Left := WRect.Left; // モニタの解像度が変わっても
      if Left < WRect.Left then Form1.Left := WRect.Left;        // 大丈夫にする処理(4行)
      if Top < WRect.Top then Form1.Top := WRect.Top;
      if Top > WRect.Bottom - 100 then Form1.Top := WRect.Top;

    *) finally
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
  DeleteAllChecked.Enabled := false;
  CheckListCounterFormCaption(Sender, ItemsCheckedCount(CheckListBox1.Count));
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  // SettingsIniFile : TIniFile;
  SettingsIniFile: TMemIniFile;
  SettingsIniFileName: string;
begin
  SettingsIniFileName := ExtractFilePath(Application.ExeName) + AppName
    + '.ini';
  SettingsIniFile := TMemIniFile.Create(SettingsIniFileName, TEncoding.UTF8);
  // SettingsIniFile := TIniFile.Create(SettingsIniFileName);
  UnlockFile;
  LInput.Free;
  try
    SettingsIniFile.WriteInteger('Form', 'Top', Form1.Top);
    SettingsIniFile.WriteInteger('Form', 'Left', Form1.Left);
    SettingsIniFile.WriteInteger('Form', 'WindowWidth', Width);
    SettingsIniFile.WriteInteger('Form', 'WindowHeight', Height);
    SettingsIniFile.UpdateFile;
  finally
    Form1.Caption := AppName + '  -  ' + '終了しています。';
    Sleep(1500); // DropBox が書き込んで解放するのを待つ
    SettingsIniFile.Free;
    Savefile(Sender, True);
  end;

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
    CheckListBox1.CheckAll(cbunChecked, True, false);
    CheckListCounterFormCaption(Sender, ItemsCheckedCount(ItemsCount));
    DeleteAllChecked.Enabled := false;
    DeleteButton.Enabled := false;
    CheckListBox1.Invalidate;
    ReplaceButton.Enabled := false;
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

procedure TForm1.SaveListLogClick(Sender: TObject);
var
  SaveTimeFileName: String;
  SL: TStringList;
begin
  SaveTimeFileName := AppName + '_' + FormatDateTime('yyyy-mmdd-hhnn', Now) + '.log';

  SL := TStringList.Create;
  try
    SL.AddStrings(CheckListBox1.Items);
    SL.SaveToFile(SaveTimeFileName, TEncoding.UTF8);

    MessageDlg(SaveTimeFileName + Str_Saved, mtInformation, [mbOk], 0);
  finally
    SL.Free;
  end;
end;

procedure TForm1.Setting_N1Click(Sender: TObject);
begin
  if IsAlwaysOnTop then
    begin  // 最前面にする設定時に Form2.ShowModal の表示が終わったらメインフォームを最前面にする。
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を解除
      Form2.ShowModal;
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // 最前面の表示を実行
    end
  else
    begin
      Form2.ShowModal;
    end;
end;

procedure TForm1.SwitchTaskTrayClick(Sender: TObject);
begin
  if TrayIcon1.Visible = false then
  begin
    TrayIcon1.Visible := True;
    SwitchTaskTray.Caption := Str_GetOut_of_TaskTray;
    Screen.Forms[0].Hide;
  end
  else
  begin
    TrayIcon1.Visible := false;
    SwitchTaskTray.Caption := Str_Store_in_TaskTray;
    Screen.Forms[0].Show;
    // Formを非表示にしてから表示させると
    // PopUpが無効になるのでAutoPopupを有効にする
    PopupMenu1.AutoPopup := True;
  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  SwitchTaskTrayClick(Sender);
end;

procedure TForm1.UpdateData(Sender: TObject; Flag:Integer; NewString: string);
// 追加Flag -> 0
// 編集Flag -> 1
// NewString はクリップボードのテキストが入る
var
  Ans: Boolean;
  StrArray: array[0..3] of string;
begin
  case Flag of
    0:begin
      StrArray[0] := '追加したい情報を入力してください。';
      StrArray[1] := '何か入力してください';
    end;
    1:begin
      StrArray[0] := '編集したい情報を入力してください。';
      StrArray[1] := '何か入力するか、削除ボタンを押してください';
      NewString := CheckListBox1.Items[CheckListBox1.ItemIndex];
    end;
    else begin
      ShowMessage('UpdateData' + Str_FunctionCalled_an_UnexpectedArgument);
    end;
  end;

  Ans := InputQuery(AppName + ' Input', StrArray[0], NewString);

  if Ans = True then
  begin
    if NewString = '' then
      begin
        MessageDlg(StrArray[1], mtInformation, [mbOk], 0);
        if Flag = 0 then
        begin
          UpdateData(Sender, Flag, NewString);
        end
      end
    else
    begin
      NewString := NewString.Trim; // 文字列の前後の空白を除去
      case Flag of
      0:begin
        CheckListBox1.Items.Add(NewString);
      end;
      1:begin
        CheckListBox1.Items[CheckListBox1.ItemIndex] := NewString;
      end;
      end;
      Memo1.Lines := CheckListBox1.Items;

      Form1.Savefile(Sender, false);
      if Flag = 0 then
        CheckListCounterFormCaption(Sender,
          ItemsCheckedCount(CheckListBox1.Count));
    end;
  end;
end;

procedure TForm1.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  FQueryEndSession := True;
  inherited;
end;

//=============================================================================
//  追加したシステムメニューを選択した時のメッセージ処理
//=============================================================================
procedure TForm1.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType of
    MyMenu1 : textIsBig:= textResize(textIsBig);// 文字の大きさを変える処理
    MyMenu2 : IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop);// 最前面に表示する処理
{$IFDEF DEBUG}
    MyMenu3 : // 折り返し表示の処理
      Showmessage('ごめんなさい。未実装です。');
{$ENDIF}
  end;

  inherited;
end;

function TForm1.AlwaysOnTop(IsAlwaysOnTop: Boolean): Boolean;
begin
  MyMenu2Text := PWideChar(Str_AlwaysShow_in_Front);
  if IsAlwaysOnTop then
  // 参照したサイト
  // http://kwikwi.cocolog-nifty.com/blog/2005/12/delphi_90fd.html
  // https://oshiete.goo.ne.jp/qa/8745468.html
  begin
    // 普通に戻す
    // SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    SetWindowPos(Form1.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);

    // システムメニューの操作
    DeleteMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION or MF_CHECKED);
    InsertMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION, MyMenu2, MyMenu2Text);
    Result := False;
  end
  else
  begin
    // 最前面に表示する
    // SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
    SetWindowPos(Form1.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or
    SWP_NOSIZE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);

    // システムメニューの操作(チェックマークを付ける)
    DeleteMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION);
    InsertMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION or MF_CHECKED, MyMenu2, MyMenu2Text);
    Result := True;
  end;
end;

function TForm1.textResize(textIsBig: Boolean): Boolean;
begin
  if textIsBig = True then
  begin
    CheckListBox1.ItemHeight := 19;
    CheckListBox1.Font.Size := 12;
    CheckListBox1.Font.Height := -16;

    MyMenu1text := PWideChar(Str_LargeFont);
    DeleteMenu(hSysmenu, AItemCnt + 1, MF_BYPOSITION);
    InsertMenu(hSysmenu, AItemCnt + 1, MF_BYPOSITION, MyMenu1, MyMenu1Text);
    Result := False;
  end
  else
  begin
    CheckListBox1.ItemHeight := 38;
    CheckListBox1.Font.Size := 24;
    CheckListBox1.Font.Height := -32;

    MyMenu1text := PWideChar(Str_SmallFont);
    DeleteMenu(hSysmenu, AItemCnt + 1, MF_BYPOSITION);
    InsertMenu(hSysmenu, AItemCnt + 1, MF_BYPOSITION, MyMenu1, MyMenu1Text);
    Result := True;
  end;

  inherited;
end;

end.
