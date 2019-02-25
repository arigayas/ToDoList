unit Setting_Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    BR_CheckBox1: TCheckBox;
    procedure BR_CheckBox1Click(Sender: TObject);

  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses ToDoList_Unit1;



procedure TForm2.BR_CheckBox1Click(Sender: TObject);
begin
  form2.Caption := Form1.Top.ToString;
end;

end.
