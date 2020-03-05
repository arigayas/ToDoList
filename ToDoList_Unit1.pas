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
    FQueryEndSession: Boolean; // Windows�I����(�V���b�g�_�E��)�̏����Ɏg�p
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
    { Private �錾 }
  public
    { Public �錾 }
  end;

const
  AppName = 'ToDoList';

// �ǉ��̃V�X�e�����j���[��ID�l
// �l�͔C�ӂ̐����l
  MyMenu1 = 101;
  MyMenu2 = 102;
  MyMenu3 = 103;

var
  Form1: TForm1;

implementation


{$R *.dfm}

uses Setting_Unit2;

resourcestring
  Str_LargeFont = '���X�g�̕�����傫������';
  Str_SmallFont = '���X�g�̕���������������';
  Str_Nothing_on_the_Clipboard = 'Clipboard �Ƀe�L�X�g�f�[�^������܂���';
  Str_PasteSomethingOtherThanText = '�e�L�X�g�ȊO�̕���\��t���悤�Ƃ��܂����B';
  Str_VK_RETURN_Yes = '�h�͂��h��I�񂾏ꍇ�͑I�����ڂ�ҏW���܂��B';
  Str_VK_RETURN_No = '�h�������h��I�񂾏ꍇ�͍��ڂ�ǉ����܂��B';
  Str_GetOut_of_TaskTray = '�^�X�N�g���C����o��';
  Str_Store_in_TaskTray = '�^�X�N�g���C�Ɋi�[����';
  Str_AlwaysShow_in_Front = '��Ɏ�O�ŕ\������';
  Str_FunctionCalled_an_UnexpectedArgument = '�֐��őz�肵�Ă��Ȃ��������Ă΂�܂����B';
  Str_Saved = ' ��ۑ����܂����B';

var
  FileName: string;
  LInput: TFileStream;
  PrevItemIndex: Integer; // D&D �p�̕ϐ�
  // ItemsCount: Integer;
  hSysmenu : hMenu;   // �ǉ��̃V�X�e�����j���[
  AItemCnt : Integer; // �ǉ��̃V�X�e�����j���[
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
   // ���C���t�H�[�����őO�ʐݒ莞�� ���̓_�C�A���O �̕\�����̓��C���t�H�[���̍őO�ʂ���������B
  if IsAlwaysOnTop then
    begin
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\��������
        NewString := '';
        UpdateData(Sender, 0, NewString);
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\�������s
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

  if Clipboard.AsText = '' then // Clipboard �Ƀf�[�^�����邩�`�F�b�N
  begin
    MessageDlg(Str_Nothing_on_the_Clipboard, mtInformation, [mbOk], 0);
  end
  else
  begin
    Memo1.Clear;
    if Clipboard.HasFormat(CF_TEXT) then // Clipboard �ɂ���f�[�^���e�L�X�g���`�F�b�N
    begin
      clipbrdStrings.Text := Clipboard.AsText;

      for I := 0 to clipbrdStrings.Count - 1 do // Clipboard �ɂ���f�[�^����e�s�̋󔒕�������
      begin
        tempstr := clipbrdStrings.Strings[I].Trim;
        tempstr := tempstr.Replace('�@', ' ');  // �S�p�󔒂𔼊p�󔒂ɒu��
        clipbrdStrings.Strings[I] := tempstr.Trim; // �S�p�󔒂������̋󔒕�����trim
      end;

      for I := clipbrdStrings.Count - 1 downto 0 do // Clipboard �ɂ���f�[�^�����s����
      begin
        if clipbrdStrings.Strings[I] = '' then
          begin
            clipbrdStrings.Delete(i);
          end;
      end;

      // ���C���t�H�[�����őO�ʐݒ莞�� ���̓_�C�A���O �̕\�����̓��C���t�H�[���̍őO�ʂ���������B
      if IsAlwaysOnTop then
      begin
        IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\��������
          for I := 0 to clipbrdStrings.Count - 1 do
          UpdateData(Sender, 0, clipbrdStrings.Strings[I]);
        IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\�������s
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

// �`�F�b�N�}�[�N�̐��Ń{�^����ON/OFF���s��
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
      // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N�}�[�N��2��������ReplaceButton��L���ɂ���
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

procedure TForm1.CheckListBox1DblClick(Sender: TObject); // ���ڂ̕ҏW
var
  NewString: string;
begin
   // ���C���t�H�[�����őO�ʐݒ莞�� ���̓_�C�A���O �̕\�����̓��C���t�H�[���̍őO�ʂ���������B
  if IsAlwaysOnTop then
    begin
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\��������
        NewString :='';
        UpdateData(Sender, 1, NewString);
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\�������s
    end
    else
    begin
      NewString :='';
      UpdateData(Sender, 1, NewString);
    end;
end;

// �h���b�O&�h���b�v�Ɋւ��Ă͈ȉ��̃u���O���Q�l�ɂ����B
// kazina���\�t�g���ꂱ��: ���X�g�{�b�N�X�̍��ڂ��h���b�O&�h���b�v�ŕ��בւ���
// http://kazina.seesaa.net/article/20064657.html
procedure TForm1.CheckListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  idx: Integer;
begin
  // CheckListBox1.AddItem(CheckListBox1.Items[CheckListBox1.ItemIndex], Source);
  // �J�[�\���̂���ʒu�̃A�C�e���C���f�b�N�X���擾�B
  idx := TCheckListBox(Source).ItemAtPos(Point(X, Y), True);

  // ���O�̃h���b�v��\���p�r��������
  DrawMoveLine(TCheckListBox(Sender), PrevItemIndex);

  // ���בւ���
  if idx <> -1 then
    TCheckListBox(Sender).Items.Move(TCheckListBox(Sender).ItemIndex, idx);
end;

procedure TForm1.CheckListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  idx: Integer;
begin
  // �������g����̃h���b�O�̂݋�����B
  // �܂��A�I������Ă��鍀�ځi�ړ�����A�C�e���j���Ȃ��ƃ_���B
  // ��L�ɂ��Ă͂܂�Ȃ��ꍇ�A�����ɏ����𔲂���B
  Accept := (Source = Sender) and (TCheckListBox(Source).ItemIndex <> -1);
  if not Accept then
    Exit;

  // �J�[�\���̂���ʒu�̃A�C�e���C���f�b�N�X���擾�B
  idx := TCheckListBox(Source).ItemAtPos(Point(X, Y), True);

  // ���O�̃h���b�v��\���p�r��������
  DrawMoveLine(TCheckListBox(Sender), PrevItemIndex);

  // �V�����h���b�v��\���p�r����`�悷��
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
      Brush.Color := clHighlight // �I�����̔w�i�F
    else if CheckListBox1.Checked[Index] then
      Brush.Color := clSkyBlue; // �`�F�b�N�����s�̔w�i�F

    FillRect(Rect);
    Offset := 2;
    TextOut(Rect.Left + Offset, Rect.Top, CheckListBox1.Items[Index])

  end;

  (* // �܂�Ԃ��@�\�Â�Delphi�ł͋@�\�����͗l
    with (Control as TCheckListBox) do
    begin
    Canvas.FillRect(Rect);

    //�����ڂ̒���
    //������񂱂������Œ�l�̒������͂悭�Ȃ��͂��Ȃ̂�����
    //VCL�̃\�[�X(StdCtrls.pas TCustomListBox.DrawItem)�ɂ����������Ă��邵�c�c
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

  if (Key = VK_ESCAPE) then // Esc�L�[�Ń`�F�b�N��S���O��
    DeleteAllCheckedClick(Sender);

  if (Key = 78) then // N�L�[�ō��ڒǉ�����
    AddItemButtonClick(Sender);

  if (Key = 80) then // P�L�[�ŃN���b�v�{�[�h�ɂ���e�L�X�g��ǉ��{�^�����g�p�����ǉ�����
    PasteFromClipboardText(Sender);

  if (Key = VK_OEM_PLUS) or (Key = VK_ADD) then
    begin
      textIsBig :=  textResize(textIsBig);
    end;

{$IFDEF DEBUG}
  if (Key = VK_INSERT) then
  begin
    ShowMessage('�F�F' + IntToStr(CheckListBox1.Canvas.Pen.Color));
    ShowMessage('���̑����F' + IntToStr(CheckListBox1.Canvas.Pen.Width));
    ShowMessage(CheckListBox1.Items[CheckListBox1.ItemIndex]);
  end;
{$ENDIF}
end;

procedure TForm1.CheckListCounterFormCaption(Sender: TObject;
  ItemsCount: Integer);
begin
  if ItemsCount > 0 then
  begin
    Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' ���� ' +
      ItemsCount.ToString + ' ���I��';
{$IFDEF DEBUG}
    Form1.Caption := Form1.Caption + ' ::DEBUG::';
{$ENDIF}
  end
  else
  begin
    Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' ��';
{$IFDEF DEBUG}
    Form1.Caption := Form1.Caption + ' ::DEBUG::';
{$ENDIF}
  end;

end;

// �ړ���������r����`�悷��葱��
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
  CheckListBox1.Canvas.Pen.Width := 1; // �`�F�b�N�{�b�N�X�̘g�������Ȃ�̂Ŗ߂�
end;

procedure TForm1.DeleteButtonClick(Sender: TObject);
// �`�F�b�N�{�b�N�X�Ƀ`�F�b�N������A�C�e�����폜����
var
  ItemsCount, ItemsChecked, I, J: Integer;
  iArr: array of Integer; // ���I�z��̐錾
begin
  ItemsCount := CheckListBox1.Count;
  ItemsChecked := 0;
  J := 0;
  Memo1.Clear;

  ItemsChecked := ItemsCheckedCount(ItemsCount); // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����鐔�𒲂ׂ�
  if ItemsChecked > 0 then // Delete�L�[������s���p�Ƀ`�F�b�N�����m�F
  begin
    SetLength(iArr, ItemsChecked); // �z��̒��������߂�
    for I := 0 to ItemsCount - 1 do
    begin
      if CheckListBox1.Checked[I] = True then
      begin
        iArr[J] := I; // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N������A�C�e���̃C���f�b�N�X�擾
        Inc(J);
      end;
    end;

    for I := ItemsChecked - 1 downto 0 do // ���X�g�͍Ōォ��폜���Ȃ��Ɓu�͈͂𒴂���v�G���[�ɂȂ�
    begin
      Memo1.Lines.Add('�C���f�b�N�X�ԍ��F' + iArr[I].ToString);
      CheckListBox1.Items.Delete(iArr[I]);
    end;
{$IFDEF DEBUG}
    ShowMessage(ItemsChecked.ToString + '�� �폜���܂����B');
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
    // �E�B���h�E�Y���I������ꍇ�̏���
    FormDestroy(Sender);
  end;

  if CanClose then
  begin
    // ���ʂɃt�H�[��������ꂽ�ꍇ�̏���
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
  MyMenu3Text := '�E�B���h�E�̕��Ő܂�Ԃ�(������)';
{$ENDIF}
  textIsBig   := False;
  IsAlwaysOnTop := False;

  //�t�H�[���̃V�X�e�����j���[�̃n���h�����擾
  hSysmenu := GetSystemMenu(Handle, False);

  //���݂̍��ڐ����擾
  AItemCnt := GetMenuItemCount(hSysmenu);

  //���݂̃��j���[��ԉ��ɋ�؂��(��4,5������0�ɂ���)��ǉ�
  InsertMenu(hSysmenu, AItemCnt, MF_BYPOSITION, 0, nil);
  //���݂̃��j���[�̈�ԉ��Ƀ��j���[��ǉ�
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
      if Left > WRect.Right - 100 then Form1.Left := WRect.Left; // ���j�^�̉𑜓x���ς���Ă�
      if Left < WRect.Left then Form1.Left := WRect.Left;        // ���v�ɂ��鏈��(4�s)
      if Top < WRect.Top then Form1.Top := WRect.Top;
      if Top > WRect.Bottom - 100 then Form1.Top := WRect.Top;

    *) finally
    SettingsIniFile.Free;
  end;

{$IFDEF DEBUG}
  Memo1.Visible := True;

  // �t�@�C��[ToDoList.txt]���Ȃ��ꍇ�g����
  for I := 1 to 10 do
    CheckListBox1.Items.Add(I.ToString);
{$ENDIF}
  FileName := AppName + '.txt';
  // FileName[ToDoList.txt]�����邩�H

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
    Form1.Caption := AppName + '  -  ' + '�I�����Ă��܂��B';
    Sleep(1500); // DropBox ����������ŉ������̂�҂�
    SettingsIniFile.Free;
    Savefile(Sender, True);
  end;

end;

function TForm1.ItemsCheckedCount(ItemsCount: Integer): Integer;
var
  ItemsChecked, I: Integer;
begin
  ItemsChecked := 0;
  // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����鐔�𒲂ׂ�
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

procedure TForm1.DeleteAllCheckedClick(Sender: TObject); // ���ׂẴ`�F�b�N���O��
var
  ItemsCount, ItemsChecked: Integer;
begin
  ItemsCount := CheckListBox1.Count;
  ItemsChecked := ItemsCheckedCount(ItemsCount); // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����鐔�𒲂ׂ�

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
      iArr[J] := I; // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N������A�C�e���̃C���f�b�N�X�擾
      Inc(J);
    end;
  end;
  Memo1.Clear;
  Memo1.Lines.Add('�C���f�b�N�X�ԍ�0�F' + iArr[0].ToString + ' | ' + CheckListBox1.Items
    [iArr[0]]);
  Memo1.Lines.Add('�C���f�b�N�X�ԍ�1�F' + iArr[1].ToString + ' | ' + CheckListBox1.Items
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
    begin  // �őO�ʂɂ���ݒ莞�� Form2.ShowModal �̕\�����I������烁�C���t�H�[�����őO�ʂɂ���B
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\��������
      Form2.ShowModal;
      IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop); // �őO�ʂ̕\�������s
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
    // Form���\���ɂ��Ă���\���������
    // PopUp�������ɂȂ�̂�AutoPopup��L���ɂ���
    PopupMenu1.AutoPopup := True;
  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  SwitchTaskTrayClick(Sender);
end;

procedure TForm1.UpdateData(Sender: TObject; Flag:Integer; NewString: string);
// �ǉ�Flag -> 0
// �ҏWFlag -> 1
// NewString �̓N���b�v�{�[�h�̃e�L�X�g������
var
  Ans: Boolean;
  StrArray: array[0..3] of string;
begin
  case Flag of
    0:begin
      StrArray[0] := '�ǉ�������������͂��Ă��������B';
      StrArray[1] := '�������͂��Ă�������';
    end;
    1:begin
      StrArray[0] := '�ҏW������������͂��Ă��������B';
      StrArray[1] := '�������͂��邩�A�폜�{�^���������Ă�������';
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
      NewString := NewString.Trim; // ������̑O��̋󔒂�����
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
//  �ǉ������V�X�e�����j���[��I���������̃��b�Z�[�W����
//=============================================================================
procedure TForm1.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType of
    MyMenu1 : textIsBig:= textResize(textIsBig);// �����̑傫����ς��鏈��
    MyMenu2 : IsAlwaysOnTop := AlwaysOnTop(IsAlwaysOnTop);// �őO�ʂɕ\�����鏈��
{$IFDEF DEBUG}
    MyMenu3 : // �܂�Ԃ��\���̏���
      Showmessage('���߂�Ȃ����B�������ł��B');
{$ENDIF}
  end;

  inherited;
end;

function TForm1.AlwaysOnTop(IsAlwaysOnTop: Boolean): Boolean;
begin
  MyMenu2Text := PWideChar(Str_AlwaysShow_in_Front);
  if IsAlwaysOnTop then
  // �Q�Ƃ����T�C�g
  // http://kwikwi.cocolog-nifty.com/blog/2005/12/delphi_90fd.html
  // https://oshiete.goo.ne.jp/qa/8745468.html
  begin
    // ���ʂɖ߂�
    // SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    SetWindowPos(Form1.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);

    // �V�X�e�����j���[�̑���
    DeleteMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION or MF_CHECKED);
    InsertMenu(hSysmenu, AItemCnt + 2, MF_BYPOSITION, MyMenu2, MyMenu2Text);
    Result := False;
  end
  else
  begin
    // �őO�ʂɕ\������
    // SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
    SetWindowPos(Form1.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or
    SWP_NOSIZE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);

    // �V�X�e�����j���[�̑���(�`�F�b�N�}�[�N��t����)
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
