unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, Grids, LazFileUtils, LCLIntf, ClipBrd, StdCtrls, Windows, jwatlhelp32, ShellApi, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckGroup1: TCheckGroup;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Timer1: TTimer;
    Timer2: TTimer;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox2Change(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UpdateProcessTable;
    procedure UpdateGUI;
    function KillProcessByPID(const PID: DWORD): Boolean;
    function KillProcessByName(const exeName: String): Boolean;
    function IsAdmin: Boolean;
    function UserInGroup(const group: Dword): Boolean;
    function RunAsAdmin(const filename: String): Boolean;
    procedure FailSuccessLabel(const Value: Boolean);
    procedure BlockingEvents;
    function ExecuteCommand(Command: String; Sanitizing: Boolean = True): Boolean;
    function SanitizeInput(const Input: String): String;

  private

  public

  end;

var
  Form1: TForm1;
  Snapshot: THandle;  //Handle of Snapshot
  PE: TProcessEntry32;  //ProcessEntry Variable
  MasterPID: Integer;  //Current PID Variable
  MasterTitle: String;  //Current Title Variable
  BlockCount: Integer = 0;  //Counting Variable for Blocking

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

function TForm1.SanitizeInput(const Input: String): String;  //Sanitize Input
begin

  Result := StringReplace(Input, '&', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, ';', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, '$', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, '!', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, '(', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, ')', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, '´', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, '`', '', [rfReplaceAll]);  //Remove Symbols
  Result := StringReplace(Result, char(#39), '', [rfReplaceAll]);  //Remove Symbols

end;

function TForm1.ExecuteCommand(Command: String; Sanitizing: Boolean = True): Boolean;  //Custom Command execution procedure through cmd
begin

  Result := False;  //Initialize Result

  if Sanitizing = True then begin  //Check for Sanitizing Flag

    Command := SanitizeInput(Command);  //Sanitize Command

  end;

  with TProcess.Create(nil) do begin  //Create a new Process to run Cmd

    Executable := 'cmd.exe';  //Set cmd.exe as executable
    Parameters.Add('/c');  //the "/c" Parameter allows us to append a new command
    Parameters.Add(Command);  //Add the real command to be executed as parameter

    Options := [poUsePipes, poWaitOnExit, poNoConsole];  //Do set the options to get the result and wait for it and also hide the console

    Execute;  //Execute the Process

    if ExitStatus = 0 then Result := True;  //Set Status to Success (used for the Label)

    Free;  //Free the Process

   end;

end;

procedure TForm1.BlockingEvents;  //Execute Events when Process was blocked
begin

end;

procedure Tform1.FailSuccessLabel(const Value: Boolean);  //Check for Fail or Success of Termination
begin

  if Value = True then begin  //Value Check

    Label4.Caption := 'SUCCESS';  //Set Caption
    Label4.Font.Color := clLime;  //Set Color

  end
  else begin

    Label4.Caption := 'FAIL';  //Set Caption
    Label4.Font.Color := clred;  //Set Color

  end;

  Timer1.Enabled := True;  //Enable Label Reset Timer

end;

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

        Result := False  //Set Result

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

procedure TForm1.Button10Click(Sender: TObject);  //Kill Process by PID with taskkill
begin

  FailSuccessLabel(ExecuteCommand('taskkill /F /PID ' + IntToStr(MasterPID) + ' /T'));  //Kill Task by PID with taskkill

end;

procedure TForm1.Button11Click(Sender: TObject);  //Kill Process by Name with taskkill
begin

  FailSuccessLabel(ExecuteCommand('taskkill /F /IM ' + MasterTitle + ' /T', NOT ToggleBox2.Checked));  //Kill Task by Name with taskkill

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  FailSuccessLabel(KillProcessByPID(MasterPID));  //Kill the choosen Process by its PID

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

  if MessageDlg('Advanced Process Blocker', 'This will completely hide this Application.' + LineEnding +
                'You will have to use the Task Manager to' + LineEnding +
                'terminate Advanced Process Blocker later!' + LineEnding +
                'Do you really want to continue?', mtWarning, [mbYes, mbNo], '') = mrYes then begin

    TrayIcon1.Visible := False;  //Hide Tray Icon
    Form1.Visible := False;  //Hide Form

  end;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin

  FailSuccessLabel(KillProcessByName(MasterTitle));  //Kill the choosen Process by its Name

end;

procedure TForm1.Button7Click(Sender: TObject);  //Add Selected Entry
begin

  Memo1.Lines.Add(MasterTitle);  //Add Master Title to Memo

end;

procedure TForm1.Button8Click(Sender: TObject);  //Clear Button
begin

  Memo1.Clear;  //Clear Blocking Memo List

end;

procedure TForm1.Button9Click(Sender: TObject);  //Reset Blocking Counter
begin

  BlockCount := 0;  //Set Counter to 0
  Label5.Caption := IntToStr(BlockCount) + ' BLOCKED';  //Update Label

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

    end
    else begin

      CheckBox4.Checked := False;  //Unset Checkbox if Set Admin Privileges was unsuccessful

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

procedure TForm1.PageControl1Change(Sender: TObject);
begin

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

procedure TForm1.Timer1Timer(Sender: TObject);  //Fail and Success Label Reset Timer
begin

  Label4.Caption := '';  //Resetting Label Caption
  Timer1.Enabled := False;  //Disable Timer

end;

procedure TForm1.Timer2Timer(Sender: TObject);  //Blocking Timer
var
  i: Integer;  //Temporary Counter Variable
begin

  for i := 0 to Memo1.Lines.Count - 1 do begin  //Iterate through Memo Entries

    if KillProcessByName(Memo1.Lines[i]) then begin  //Try to kill Process

      BlockingEvents;  //Execute BlockingEvents Procedure
      BlockCount += 1;  //Increase Counter by 1
      Label5.Caption := IntToStr(BlockCount) + ' BLOCKED';  //Update Label

    end;

  end;

end;

procedure TForm1.ToggleBox1Change(Sender: TObject);  //Enable Disable Blocking
begin

  if ToggleBox1.Checked = True then begin  //Check for Click

    ToggleBox1.Caption := 'Disable Blocking';  //Set Caption

  end
  else begin

    ToggleBox1.Caption := 'Enable Blocking';  //Set Caption

  end;

  Timer2.Enabled := ToggleBox1.Checked;  //Activate or Deativate Timer

end;

procedure TForm1.ToggleBox2Change(Sender: TObject);  //Enable Disable Input Sanitizing
begin

  if ToggleBox2.Checked = True then begin  //Check for Click

    ToggleBox2.Caption := 'Enable taskkill Input Sanitizing';  //Set Caption

    ShowMessage('You have disabled Input Sanitizing. Now Symbols like &,$,;,!,´,`,(,) or ' + char(#39) + ' will not be edited out of the Process Names. Please be aware that strange Process Names could be used for Command Injection. Please use the terminate by PID option instead!');  //Show Message

  end
  else begin

    ToggleBox2.Caption := 'Disable taskkill Input Sanitizing';  //Set Caption

  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject); //Self Settings to Hide Application after clicking TrayIcon
begin

  Form1.Visible := NOT Form1.Visible;  //Switch Form Visibility Status

end;

end.

