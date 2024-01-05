unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

  public

  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);  //Just Hide the Form when closing
begin

  CanClose := False;  //Cannot Close
  Form2.Visible := False;  //Hide Form

end;

procedure TForm2.Button1Click(Sender: TObject);  //Unblock Button
begin

  if Edit1.Text = Form1.Edit6.Text then begin  //Check Password

    Form1.ToggleBox1.Checked := False;  //Unset Blocking 
    ShowMessage('The Password was input correctly. All Processes are now unblocked.');  //Display Message 
    Form2.Visible := False;  //Hide Password Input

  end
  else begin

    MessageDlg('Advanced Process Blocker', 'Your Password is incorrect.', mtError, [mbOK], '');   //Display Error Message
    Form2.Visible := False;  //Hide Password Input

  end;

end;

end.

