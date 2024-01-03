unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, Grids, LazFileUtils, LCLIntf, ClipBrd, StdCtrls, Windows, jwatlhelp32, ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
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
    procedure Button6Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UpdateProcessTable;
    procedure UpdateGUI;
    function KillProcessByPID(const PID: DWORD): Boolean;
    function KillProcessByName(const exeName: String): Boolean;
    function IsAdmin: Boolean;
    function UserInGroup(const group: Dword): Boolean;
    function RunAsAdmin(const filename: String): Boolean;

  private

  public

  end;

var
  Form1: TForm1;
  Snapshot: THandle;  //Handle of Snapshot
  PE: TProcessEntry32;  //ProcessEntry Variable
  MasterPID: Integer;  //Current PID Variable
  MasterTitle: String;  //Current Title Variable

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

function TForm1.RunAsAdmin(const filename: String): Boolean;  //Run as Process as Administrator
var
  Shell: TShellExecuteInfo;  //Shell Execute Info Variable
begin

  Result := False;  //Initialize Result

  if not (filename = '') then begin  //Check for empty FileName

    ZeroMemory(@Shell, SizeOf(Shell));  //Reserve Size
    Shell.cbSize := SizeOf(TShellExecuteInfo);  //Set Size
    Shell.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;  //Set fMask Parameters to hide console
    Shell.lpVerb := PChar('runas');  //Use runas as command
    Shell.lpFile := PChar(filename);  //Give the filename path as Parameter
    Shell.nShow := SW_SHOWNORMAL;

    Result := ShellExecuteExA(@Shell);  //Get Result as Boolean

  end;

end;

function CheckTokenMembership(TokenHandle: THandle; SidToCheck: Psid; var IsMember: Boolean): Boolean; stdcall; external advapi32;  //Import Function to Check Token Membership (Used for Group Check wich is used for Admin Check)

function TForm1.UserInGroup(const group: Dword): Boolean;  //Check if a User is in  a Group
const
 SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));  //Set SECURITY_NT_AUTHORITY constant as its not available
var
 pIdentifierAuthority: TSIDIdentifierAuthority;  //TSIDIdentifierAuthority for later use
 pSid: Windows.PSID = Nil;  //PSID
 IsMember: Boolean = False;  //Temporary Boolean Variable for Member Check
begin

 pIdentifierAuthority := SECURITY_NT_AUTHORITY;  //Set Authority Variable

 Result := AllocateAndInitializeSid(pIdentifierAuthority,2, $00000020, Group, 0, 0, 0, 0, 0, 0, pSid);  //Initialize Result

 try

   if Result then

     if not CheckTokenMembership(0, pSid, IsMember) then  //Check for Membership

        Result := False;  //Set Result

     else

        Result := IsMember;  //Set Result

 finally

    FreeSid(pSid);  //Free Windows PSID

 end;

end;

function TForm1.IsAdmin: Boolean;  //Check if Application runs as Administrator
begin

 Result := UserInGroup(DOMAIN_ALIAS_RID_ADMINS);  //Get it through User Group

end;

function TForm1.KillProcessByName(const exeName: String): Boolean;  //Kill Process by Name procedure
var
  ContinueLoop: Boolean;  //Loop Check Variable
  FSnapshotHandle: THandle;  //Snapshot Handle
  FProcessEntry32: TProcessEntry32;  //Process Entry Variable  
  ProcessHandle: THandle;  //Process Handle
begin

  Result := False;  //Initialize Result

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);  //Create Snapshot

  try

    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);  //Set Entry Size

    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);  //Open Loop

    while Integer(ContinueLoop) <> 0 do begin  //Loop

      if (UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(exeName)) OR (UpperCase(FProcessEntry32.szExeFile) = UpperCase(exeName)) then begin  //Check for Name without Case

        ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, FProcessEntry32.th32ProcessID);  //Open Process

        if ProcessHandle <> INVALID_HANDLE_VALUE then  //Check if Handle is valid

          try

            Result := TerminateProcess(ProcessHandle, 0);  //Terminate Process

          finally

            CloseHandle(ProcessHandle);  //Close Process Handle (Terminate Process)

          end;

      end;

      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);  //Check Loop

    end;

   finally

     CloseHandle(FSnapshotHandle);  //Close Handle

   end;

end;

function TForm1.KillProcessByPID(const PID: DWORD): Boolean;  //Kill Process by PID procedure
var
  ProcessHandle: THandle;  //Process Handle
begin

  Result := False;  //Initialize Result

  ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, PID);  //Open Process

  if ProcessHandle <> INVALID_HANDLE_VALUE then  //Check if Handle is valid

    try

      Result := TerminateProcess(ProcessHandle, 0);  //Terminate Process

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

procedure TForm1.Button6Click(Sender: TObject);
begin

  KillProcessByName(MasterTitle);  //Kill the choosen Process by its Name

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

  if CheckBox3.Checked then begin

    Form1.BorderIcons := []; //Disable Border Icons

  end
  else begin

    Form1.BorderIcons := [biSystemMenu,biMinimize];  //Enable Border Icons

  end;

end;

procedure TForm1.CheckBox4Change(Sender: TObject);  //Set Administrative Privileges
begin

  if (CheckBox4.Checked = True) AND NOT (IsAdmin = True) then begin  //Check for Click  and Admin Status

    if RunAsAdmin(Application.ExeName) = True then begin  //Restart as Admin

      Close;  //Terminate Current Application

    end;

  end;

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);  //Form Termination
begin

  TrayIcon1.Visible := False;  //Fix TrayIcon not disappearing sometimes

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);  //Check for Close Prevention
begin

  CanClose := NOT CheckBox3.Checked;  //Check for Self Setting

end;

procedure TForm1.FormCreate(Sender: TObject);  //Form Creation
begin

  TrayIcon1.Show;  //Show Tray Icon

  CHeckBox4.Enabled := NOT IsAdmin;  //Test for Admin Status

  CheckBox4.Checked := IsAdmin;  //Set Admin Status

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

