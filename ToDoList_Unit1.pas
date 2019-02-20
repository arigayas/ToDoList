unit ToDoList_Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  System.UITypes, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  Vcl.ExtCtrls, System.Types;

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
    FQueryEndSession : Boolean;
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession);
        message WM_QUERYENDSESSION;
    function ItemsCheckedCount(ItemsCount: Integer): Integer;
    procedure Savefile(Sender: TObject);
    procedure DrawMoveLine(CheckListBox1: TCheckListBox; const Index: Integer);
    procedure CheckListBox1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure CheckListCounterFormCaption(Sender: TObject);
    { Private �錾 }
  public
    { Public �錾 }
  end;

const
  AppName = 'ToDoList';

var
  Form1: TForm1;
  FileName: string;
  PrevItemIndex: Integer; // D&D �p�̕ϐ�

  LInput: TFileStream;
implementation

{$R *.dfm}

uses Setting_Unit2;

procedure TForm1.AddItemButtonClick(Sender: TObject);
var
  Ans: Boolean;
  NewString: string;
begin
  Ans := InputQuery(AppName +' Input', '�ǉ�������������͂��Ă��������B', NewString);

  if Ans = True then
  begin
    if NewString = '' then
    begin
      MessageDlg('�������͂��Ă�������', mtInformation, [mbOk], 0);
      AddItemButtonClick(Sender);
    end
    else
    begin
      NewString := Trim(NewString); // ������̑O��̋󔒂�����
      CheckListBox1.Items.Add(NewString);
      Memo1.Lines := CheckListBox1.Items;

      Savefile(Sender);
      CheckListCounterFormCaption(Sender);
    end;

  end;
end;

// �`�F�b�N�}�[�N�̐��Ń{�^����ON/OFF���s��
procedure TForm1.BR_N1Click(Sender: TObject);
begin
  if BR_N1.Checked then
  begin
    BR_N1.Caption := '�E�B���h�E�̕��Ő܂�Ԃ�';
    BR_N1.Checked := True;
  end
  else
  begin
    BR_N1.Caption := '�E�B���h�E�̕��Ő܂�Ԃ��Ȃ�';
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

      // �`�F�b�N�{�b�N�X�Ƀ`�F�b�N�}�[�N��2��������ReplaceButton��L���ɂ���
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
  Ans := InputQuery(AppName +' Input', '�ҏW������������͂��Ă��������B', NewString);

  if Ans = True then
  begin
    if NewString = '' then
      MessageDlg('�������͂��邩�A�폜�{�^���������Ă�������', mtInformation, [mbOk], 0)
    else
    begin
      NewString := Trim(NewString); // ������̑O��̋󔒂�����
      CheckListBox1.Items[CheckListBox1.ItemIndex] := NewString;
      Memo1.Lines := CheckListBox1.Items;

      Savefile(Sender);
    end;

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
      if MessageDlg('�h�͂��h��I�񂾏ꍇ�͑I�����ڂ�ҏW���܂��B' + sLineBreak +
        '�h�������h��I�񂾏ꍇ�͍��ڂ�ǉ����܂��B', mtConfirmation, [mbYes, mbNo], 0) = mrYes
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
    ShowMessage('�F�F' + IntToStr(CheckListBox1.Canvas.Pen.Color));
    ShowMessage('���̑����F' + IntToStr(CheckListBox1.Canvas.Pen.Width));
    ShowMessage(CheckListBox1.Items[CheckListBox1.ItemIndex]);
  end;
{$ENDIF}
end;

procedure TForm1.CheckListCounterFormCaption(Sender: TObject);
begin
  Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString + ' ��';

{$IFDEF DEBUG}
  Form1.Caption := AppName + '  -  ' + CheckListBox1.Count.ToString +
    ' �� ::DEBUG::';
{$ENDIF}
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
    //�E�B���h�E�Y���I������ꍇ�̏���
      FormDestroy(Sender);
  end;

  if CanClose then
  begin
    //���ʂɃt�H�[��������ꂽ�ꍇ�̏���
    FormDestroy(Sender);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FStream: TStringList;
  I: Integer;
  LInput: TFileStream;
begin
  Memo1.Visible := False;
  DeleteButton.Enabled := False;
  BR_N1.Checked := False;

{$IFDEF DEBUG}
  Memo1.Visible := True;

  // �t�@�C��[ToDoList.txt]���Ȃ��ꍇ�g����
  for I := 1 to 10 do
    CheckListBox1.Items.Add(I.ToString);

{$ENDIF}
//  FileName := ChangeFileExt(Application.ExeName, '.txt');
  FileName := AppName +'.txt';
  // FileName[ToDoList.txt]�����邩�H

  if FileExists(FileName) then
  begin
    FStream := TStringList.Create;
    FStream.LoadFromFile(FileName);

    CheckListBox1.Items := FStream;

    FStream.Clear;
  end;

//  LInput := TFileStream.Create(FileName,  fmOpenWrite or fmShareDenyWrite );
  DeleteAllChecked.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  LInput.Free;
  Savefile(Sender);

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

procedure TForm1.Savefile(Sender: TObject);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.AddStrings(CheckListBox1.Items);
    SL.SaveToFile(FileName, TEncoding.UTF8);

//    LInput.OpenReadWrite
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
    SwitchTaskTray.Caption := '�^�X�N�g���C����o��';
    Screen.Forms[0].Hide;
  end
  else
  begin
    TrayIcon1.Visible := False;
    SwitchTaskTray.Caption := '�^�X�N�g���C�Ɋi�[����';
    Screen.Forms[0].Show;
    // Form���\���ɂ��Ă���\���������
    // PopUp�������ɂȂ�̂�AutoPopup��L���ɂ���
    PopupMenu1.AutoPopup := True;
  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
//  ShowMessage('�^�X�N�g���C�̃A�C�R�����N���b�N�����牽�������悤��');
  SwitchTaskTrayClick(Sender);
end;

procedure TForm1.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  FQueryEndSession := true;
  inherited;
end;

end.
