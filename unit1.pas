unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, Grids, LazFileUtils, LCLIntf, ClipBrd, StdCtrls, Windows, jwatlhelp32;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckGroup1: TCheckGroup;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UpdateProcessTable;
    procedure UpdateGUI;
    procedure KillProcessByPID(const PID: DWORD);

  private

  public

  end;

var
  Form1: TForm1;
  Snapshot: THandle;
  PE: TProcessEntry32;
  MasterPID: Integer;
  MasterTitle: String;

  const License = 'Advanced Process Blocker is licensed under the' + LineEnding +
                  'GNU General Public License v3.0.' + LineEnding +
                  'You should have received a copy of the ' + LineEnding +
                  'GNU General Public License' + LineEnding +
                  'along with this program.' + LineEnding +
                  'If not, see https://www.gnu.org/licenses/';  //The String used for Displaying the License Information

  const Changelog = 'Version 1.00: Initial Release';  //The String used for Displaying the latest Changelog

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.KillProcessByPID(const PID: DWORD);  //Kill Process by PID function
var
  ProcessHandle: THandle;  //Process Handle
begin

  ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, PID);  //Open Process

  if ProcessHandle <> INVALID_HANDLE_VALUE then  //Check if Handle is valid

    try

      TerminateProcess(ProcessHandle, 0);  //Terminate Process

    finally

      CloseHandle(ProcessHandle);  //Close Process Handle (Terminate Process)

    end;

end;

procedure TForm1.UpdateGUI;  //Update the visible GUI
begin
  Label1.Caption := IntToStr(MasterPID);  //Show choosen PID in Label
end;

procedure TForm1.UpdateProcessTable;  //Initial Procedure to create and Display the List of Handles and Window Titles in the String Grid
var
  i: Integer = 0;  //Counter Variable
begin

  StringGrid1.Clear;  //Reset the String Grid (As the Procedure could be called to update the List)

  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);  //Create Snapshot

  PE.dwSize := SizeOf(PE);  //Initialize Size

  if Process32First(Snapshot, PE) then  //Start

     while Process32Next(Snapshot, PE) do begin  //Iterate through Processes

       StringGrid1.RowCount := i + 2;  //Increase Row Count

       if i = 0 then begin  //Only Init the StringGrid once

         StringGrid1.Cells[0,0] := 'PID';  //Add Description
         StringGrid1.Cells[1,0] := 'Title';  //Add Description
         StringGrid1.ColWidths[1] := 415;  //Extend Column to be better readable

       end;

       StringGrid1.Cells[1,i + 1] := PE.szExeFile;  //Add Name of Exe File to Table
       StringGrid1.Cells[0,i + 1] := IntToStr(PE.th32ProcessID);  //Add PID to Table

       i += 1;  //Counter +1

     end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  UpdateProcessTable;  //Update the Table

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  KillProcessByPID(MasterPID);  //Kill the choosen Process by its PID
end;

procedure TForm1.Button3Click(Sender: TObject);  //Changelog Button
begin

  ShowMessage(Changelog);  //Show the Changelog String

end;

procedure TForm1.Button4Click(Sender: TObject);  //License Button
begin

  ShowMessage(License);  //Show the License String

end;

procedure TForm1.Button5Click(Sender: TObject);  //Hide Application
begin

  TrayIcon1.Visible := False;  //Hide Tray Icon
  Form1.Visible := False;  //Hide Form

end;

procedure TForm1.CheckBox1Change(Sender: TObject);  //Self Settings to switch off Topmost mode
begin

  if CheckBox1.Checked then begin

    Form1.FormStyle := fsNormal;  //FormStyle Normal -> Application not Topmost

  end
  else begin

    Form1.FormStyle := fsSystemStayOnTop;  //FormStyle SystemStayOnTop -> Application Topmost

  end;

end;

procedure TForm1.CheckBox2Change(Sender: TObject);  //Selft Settings to switch off TrayIcon
begin

  if CheckBox2.Checked then begin

    TrayIcon1.Visible := False;  //Hide TrayIcon

  end
  else begin

    TrayIcon1.Visible := True;  //Show TrayIcon

  end;

end;

procedure TForm1.CheckBox3Change(Sender: TObject);  //Selft Settings to switch off Termination
begin

  if CheckBox2.Checked then begin

    Form1.BorderIcons := []; //Disable Border Icons

  end
  else begin

    Form1.BorderIcons := [biSystemMenu,biMinimize];  //Enable Border Icons

  end;

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);  //Form Termination
begin

  TrayIcon1.Visible := False;

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);  //Check for Close Prevention
begin

  CanClose := NOT CheckBox3.Checked;  //Check for Self Setting

end;

procedure TForm1.FormCreate(Sender: TObject);  //Form Creation
begin

  TrayIcon1.Show;  //Show Tray Icon

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

  ClipBrd.Clipboard.AsText := Label1.Caption;  //Copy PID Value to Clipboard

end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin

  if (StringGrid1.Row >= 1) AND (StringGrid1.Cells[0,StringGrid1.Row].Length > 0) then begin  //Only select the current PID if there is something to select in the first column

    TabSheet1.Enabled := True;  //Enable TabSheet after the user selects a PID
    TabSheet2.Enabled := True;  //Enable TabSheet after the user selects a PID

    MasterPID := StrToInt(StringGrid1.Cells[0,StringGrid1.Row]);  //Update the value for the current MasterPID
    MasterTitle := StringGrid1.Cells[1,StringGrid1.Row];  //Update the value for the current MasterTitle

    if MasterPID = Int(GetProcessID) then begin  //Check if selected PID equals Application PID

      ShowMessage('Warning! You have selected the PID of Advanced Process Blocker itself.' + LineEnding + 'Please act with care.');  //Display Warning

    end;

    UpdateGUI;

    end
    else begin

      MessageDlg(Application.Title, 'Please select an entry first!', mtError, [mbOK], 0);  //Error Message if Selection was invalid (Should theoreticaly not be needed)

    end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject); //Self Settings to Hide Application after clicking TrayIcon
begin

  Form1.Visible := NOT Form1.Visible;  //Switch Form Visibility Status

end;

end.

