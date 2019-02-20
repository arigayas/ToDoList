//  アプリケーションの多重起動を禁止して起動中なら切り替える
//  http://owlsperspective.blogspot.com/2008/11/avoiding-multiple-instance.html


program ToDoList;

uses
  Windows,
  SysUtils,
  Messages,
  Vcl.Forms,
  ToDoList_Unit1 in 'ToDoList_Unit1.pas' {Form1},
  Setting_Unit2 in 'Setting_Unit2.pas' {Form2};

{$R *.res}

var
  { Mutex name }
  CMutexName: String;
  hMutex: THandle;
  Wnd: HWnd;
  AppWnd: HWnd;

begin
  CMutexName := 'arigayas_ToDoList';
{$IFDEF DEBUG}
  CMutexName := CMutexName + '_DEBUG';
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  { Create mutex }
  SetLastError(0);
  hMutex := CreateMutex(nil, False, PChar(CMutexName));
  if hMutex = 0 then
  begin
    RaiseLastOSError;
  end;

  try
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      { Search main form }
      Wnd := FindWindow(PChar('TForm1'), nil); // Class name of the main form
      if Wnd = 0 then
      begin
        Exit;
      end;


      { Bring foreground and activate }
      SetForegroundWindow(Wnd);

      { Get window handle of TApplication }
      AppWnd := GetWindowLong(Wnd, GWL_HWNDPARENT);
      if AppWnd <> 0 then
      begin
        Wnd := AppWnd;
      end;

      { Restore if iconized }
      if IsIconic(Wnd) then
      begin
        SendMessage(Wnd, WM_SYSCOMMAND, SC_RESTORE, -1);
      end;

      Exit;
    end;

    Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
  finally
    { Close mutex }
    CloseHandle(hMutex);
  end;

end.
