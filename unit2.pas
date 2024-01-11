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

  if (Edit1.Text = Form1.Edit6.Text) AND NOT (Unit1.Tries = 0) then begin  //Check Password

    Form1.ToggleBox1.Checked := False;  //Unset Blocking 
    ShowMessage('Your Password was correct. All Processes are now unblocked.');  //Display Message
    Form2.Visible := False;  //Hide Password Input
    Edit1.Clear;  //Clear Password Field

    if Lockdown = True then begin  //Check for Lockdown Mode

      Form1.TrayIcon1.Visible := True;  //Enable TrayIcon
      Form1.Enabled := True;  //Enable Form
      Form1.PageControl1.Enabled := True;  //Eable Control
      Form1.Button1.Enabled := True;  //Eable Control
      Form1.StringGrid1.Enabled := True;  //Eable Control
      LockDown := False;  //Disable Lockdown Mode
      ShowMessage('Lockdown Mode has been disabled!');  //Show Message

    end;

  end
  else if NOT (Unit1.Tries = 0) then begin  //Check remaining Tries

    MessageDlg('Advanced Process Blocker', 'Your Password is incorrect.', mtError, [mbOK], '');   //Display Error Message
    Form2.Visible := False;  //Hide Password Input 
    Edit1.Clear;  //Clear Password Field

    if Unit1.Tries > 0 then begin  //Check Tries

      Unit1.Tries := Unit1.Tries - 1;  //Remove 1 Password Try

      if Unit1.Tries <> 1 then begin  //Spelling Check for Tries and Try

        ShowMessage('You have ' + IntToStr(Unit1.Tries) + ' Tries left!');  //Display Message

      end
      else begin

        ShowMessage('You have ' + IntToStr(Unit1.Tries) + ' Try left!');  //Display Message

      end;

    end;

  end
  else begin

    MessageDlg('Advanced Process Blocker', 'No more Tries left!', mtError, [mbOK], '');   //Display Error Message
    Form2.Visible := False;  //Hide Password Input
    Edit1.Clear;  //Clear Password Field

  end;

end;

end.

