unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Grids, LazFileUtils, LCLIntf, ClipBrd, StdCtrls, Spin, Windows, jwatlhelp32,
  ShellApi, Process, Unit2, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckGroup1: TCheckGroup;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox10Change(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
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
    procedure BlockingEvents(PName: String = '');
    function ExecuteCommand(Command: String; Sanitizing: Boolean = True): Boolean;
    function SanitizeInput(const Input: String): String;
    function ProcessExists(PName: String): Boolean;
    procedure ExecuteExternalApp(const ExePath: string); 
    procedure CustomLabelMouseEnter(Sender: TObject);
    procedure CustomLabelMouseLeave(Sender: TObject);

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
  Limit: Boolean = False;  //URL Open Limit
  LimitCmd: Boolean = False;  //CMD Open Limit
  LockDown: Boolean = False;  //Application LockDown Check
  Tries: Integer = 0;  //Password Tries
  ExternalExecutable: String = '';  //Path to extra Executable
  Settings: TIniFile;  //Settings ini File
  SkipSaving: Boolean = False;  //Settings Saving Force Skip

  const License = 'Advanced Process Blocker is licensed under the' + LineEnding +
                  'GNU General Public License v3.0.' + LineEnding +
                  'You should have received a copy of the ' + LineEnding +
                  'GNU General Public License' + LineEnding +
                  'along with this program.' + LineEnding +
                  'If not, see https://www.gnu.org/licenses/';  //The String used for Displaying the License Information

  const Changelog = 'Version 1.0.0:' + LineEnding +
                    ' * Initial Release.' + LineEnding +
                    'Version 1.0.1:' + LineEnding +
                    ' * Added Feature to save Settings.' + LineEnding +
                    ' * Added Searching Feature for the Process List.' + LineEnding +
                    ' * Added CSV export of the Process List.' + LineEnding +
                    ' * Added Copy Indicator for displayed Handle.' + LineEnding + 
                    ' * Added closing confirmation Dialog if blocking is enabled.' + LineEnding +
                    ' * Improved Scrolling with the Process List.' + LineEnding +
                    ' * WIP: Replaced Clear Password with SHA-512 Hash.' + LineEnding +
                    ' * Rewritten Information Section to be more usable.' + LineEnding +
                    ' * Minor visual fixes.';  //The String used for Displaying the latest Changelog

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CustomLabelMouseEnter(Sender: TObject);  //Custom Procedure to underline any Label OnMouseEnter
var
  tempLabel: TLabel = nil;  //Temporary Label
begin

  tempLabel := TLabel(Sender);  //Get Label
  tempLabel.Font.Style := [fsUnderline];  //Set Style

end;

procedure TForm1.CustomLabelMouseLeave(Sender: TObject);  //Custom Procedure to remove underline from any Label OnMouseLeave
var
  tempLabel: TLabel = nil;  //Temporary Label
begin

  tempLabel := TLabel(Sender);  //Get Label
  tempLabel.Font.Style := [];  //Unset Style

end;

procedure TForm1.ExecuteExternalApp(const ExePath: string);
var
  ExternalApp: TProcess;  //Tprocess Variable to start the Executable
begin

  ExternalApp := TProcess.Create(nil);  //Create TProcess
  ExternalApp.Executable := ExePath;  //Set Exe Path
  ExternalApp.Execute;  //Execute App

  FreeAndNil(ExternalApp)

end;

function TForm1.ProcessExists(PName: String): Boolean;  //Check if given Process is running
var
  ContinueLoop: Boolean;  //Loop Variable
  FSnapshotHandle: THandle;  //Snapshot Handle
  FProcessEntry32: TProcessEntry32;  //Process Snapshot
begin

  Result := False;  //Initialize Result

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);  //Create Snapshot
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);  //Set Size
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);  //Get Loop Variable

  while Integer(ContinueLoop) <> 0 do begin  //While Loop

    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(PName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(PName))) then begin  //Check for Name

      Result := True;  //Found Process

    end;

    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);  //See if next to continue

  end;

  CloseHandle(FSnapshotHandle);  //Close Handle

end;

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

procedure TForm1.BlockingEvents(PName: String = '');  //Execute Events when Process was blocked
begin

  if CheckBox9.Checked then begin  //Check for Message

    MessageDlg(Edit3.Text, Edit4.Text, mtInformation, [mbOK, mbNo], '');  //Display MessageBox

  end;

  if CheckBox5.Checked then begin  //Check for Command

    if NOT ( CheckBox13.Checked ) OR ( ( CheckBox13.Checked ) AND LimitCmd = False ) then begin  //Check for Limit

      ExecuteCommand(Edit5.Text, False);  //Execute Command
      LimitCmd := True;  //Set Limit

    end;

  end;

  if ( CheckBox8.Checked ) AND ( CheckBox11.Checked ) then begin  //Check for Logic

    ShowMessage('The Execution of the File "' + PName + '" was blocked because "' + Edit2.Text + '" is currently running!');  //Display Message

  end;

  if CheckBox6.Checked then begin  //Open URL Option Check

    if NOT ( CheckBox12.Checked ) OR ( ( CheckBox12.Checked ) AND Limit = False ) then begin  //Check for Limit

      OpenUrl(Edit1.Text);  //Open URL in standart Browser
      Limit := True;  //Set Limit

    end;

  end;

  if ( CheckBox10.Checked ) AND NOT (ExternalExecutable = '') then begin  //Start other Executable

    ExecuteExternalApp(ExternalExecutable);  //Start Executable

  end;

  if CheckBox7.Checked then begin  //Password Option Check

    Form2.Label1.Caption := 'Execution of "' + PName + '" was blocked.' + LineEnding +
                            'If you want to disable blocking please' + LineEnding +
                            'input the correct Password below.';  //Change Label
    Form2.Visible := True;  //Show Password Input

  end;

end;

procedure Tform1.FailSuccessLabel(const Value: Boolean);  //Check for Fail or Success of Termination
begin

  if Value = True then begin  //Value Check

    Label4.Caption := 'SUCCESS';  //Set Caption
    Label4.Font.Color := $0000CE00;  //Set Color

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

procedure TForm1.Button12Click(Sender: TObject);  //Reset Limit
begin

  Limit := False;  //Set Limit False

end;

procedure TForm1.Button13Click(Sender: TObject);  //Reset Cmd Limit
begin

  LimitCmd := False;  //Set Limit False

end;

procedure TForm1.Button14Click(Sender: TObject);  //Lock down Application
begin

  if Edit6.Text = '' then begin  //Check for empty Password

    ShowMessage('Please input a Password first!');  //Display Message

  end
  else begin

    if MessageDlg('Advanced Process Blocker', 'Blocking will be enabled and this Application will enter Lockdown Mode.' + LineEnding +
                'You will have to input the correct Password' + LineEnding +
                'to unblock your Processes!' + LineEnding +
                'Do you really want to continue?', mtWarning, [mbYes, mbNo], '') = mrYes then begin  //Check for Choice

      ToggleBox1.Checked := True;  //Enable Blocking
      TrayIcon1.Visible := False;  //Hide Tray Icon
      Form1.Visible := False;  //Hide Form
      LockDown := True;  //Set Lockdown
      Form1.Enabled := False;  //Disable Form
      Form1.PageControl1.Enabled := False;  //Disable Form 
      Form1.Button1.Enabled := False;  //Disable Control
      Form1.StringGrid1.Enabled := False;  //Disable Control

    end;

  end;

end;

procedure TForm1.Button15Click(Sender: TObject);  //Choose Executable
begin

  if OpenDialog1.Execute = True then begin  //Check for Dialog Option

    ExternalExecutable := OpenDialog1.FileName;  //Set Path of Executable
    Label7.Caption := 'Current Executable: ' + ExtractFileName(ExternalExecutable);  //Set Label caption as Information

  end;

end;

procedure TForm1.Button16Click(Sender: TObject);
begin

  ExternalExecutable := '';  //Reset Executable Path
  Label7.Caption := 'Current Executable: ';  //Set Label caption as Information

  ShowMessage('Executable Path was reset.');  //ShowMessage

end;

procedure TForm1.Button17Click(Sender: TObject);  //Export Process List to CSV File
begin

  if SaveDialog1.Execute then StringGrid1.SaveToCSVFile(SaveDialog1.FileName);  //Save StringGrid to CSV File after choosing Location

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

procedure TForm1.Button6Click(Sender: TObject);  //Kill the Process by Name
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

procedure TForm1.CheckBox10Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox11.Enabled := CheckBox10.Checked;  //Enable Event

  If CheckBox10.Checked = False then begin  //Check for deactivated option

    Button16.Click;  //Click Button as Shortcut for Reseting Executable Path

  end;

end;

procedure TForm1.CheckBox14Change(Sender: TObject);  //Auto Save/Load Settings Checkbox Change
begin

  if NOT CheckBox14.Checked then begin  //Check for disabled Saving Settings

    if FileExists(ExtractFilePath(Application.ExeName) + 'Advanced Process Blocker.ini') then begin  //Check if Settings where allready created

      if MessageDlg('Unsetting this Option will delete the Settings File.' + LineEnding + 'Do you want to continue?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin  //Ask if user wnats to delete current settings

        SysUtils.DeleteFile(ExtractFilePath(Application.ExeName) + 'Advanced Process Blocker.ini');  //Delete the Settings File

      end
      else begin

        CheckBox14.Checked := True;  //Check Checkbox again

      end;

    end;

  end;

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

      SkipSaving := True;  //Skip Saving of settings as the Application is restartet
      Close;  //Terminate Current Application

    end
    else begin

      CheckBox4.Checked := False;  //Unset Checkbox if Set Admin Privileges was unsuccessful

    end;

  end;

end;

procedure TForm1.CheckBox5Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox6.Enabled := CheckBox5.Checked;  //Enable Event

end;

procedure TForm1.CheckBox6Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox7.Enabled := CheckBox6.Checked;  //Enable Event

end;

procedure TForm1.CheckBox7Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox8.Enabled := CheckBox7.Checked;  //Enable Event

end;

procedure TForm1.CheckBox8Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox10.Enabled := CheckBox8.Checked;  //Enable Event

end;

procedure TForm1.CheckBox9Change(Sender: TObject);  //Event Enable Logic
begin

  GroupBox9.Enabled := CheckBox9.Checked;  //Enable Event

end;

procedure TForm1.Edit7Change(Sender: TObject);  //Search Process Name Edit Field Change
var
  i: Integer = 0;  //Temp counter Variable
  j: Integer = 0;  //Temp counter Variable
begin

  for i := 0 to StringGrid1.RowCount - 1 do  //Outer Loop

    for j := 0 to StringGrid1.ColCount - 1 do  //Inner Loop

      if Pos(UpperCase(Edit7.Text), UpperCase(StringGrid1.Cells[j, i])) > 0 then begin  //Check for String Match between Searched Title and Cell content

        StringGrid1.Row := i;  //Select Row
        StringGrid1.TopRow := Max(0, i - (StringGrid1.VisibleRowCount div 2));  //Scroll

        Exit;  //Leave after first match

      end;

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);  //Check for tasks before closing
begin

  CanClose := ( NOT CheckBox3.Checked ) AND ( NOT LockDown );  //Check for Self Setting and Lockdown Mode

  if CanClose = True then begin  //Check if Application will realy close

    if ( CheckBox14.Checked = True ) AND NOT ( SkipSaving = True ) then begin  //Check for Saving Option and Skip Flag

      Settings := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Advanced Process Blocker.ini');  //Create Settings File

      try

        Settings.WriteString('Settings', 'Execute Command', BoolToStr(CheckBox5.Checked));
        Settings.WriteString('Settings', 'Open URL', BoolToStr(CheckBox6.Checked));
        Settings.WriteString('Settings', 'Use Password to unblock', BoolToStr(CheckBox7.Checked));
        Settings.WriteString('Settings', 'Show Message when blocked', BoolToStr(CheckBox9.Checked));
        Settings.WriteString('Settings', 'Watch for running Process', BoolToStr(CheckBox8.Checked));
        Settings.WriteString('Settings', 'Start other Executable', BoolToStr(CheckBox10.Checked));
        Settings.WriteString('Settings', 'Disable Topmost Status', BoolToStr(CheckBox1.Checked));
        Settings.WriteString('Settings', 'Disable Tray Icon', BoolToStr(CheckBox2.Checked));
        Settings.WriteString('Settings', 'Prevent Application Termination', BoolToStr(CheckBox3.Checked));
        Settings.WriteString('Settings', 'Set Administrative Privileges', BoolToStr(CheckBox4.Checked));
        Settings.WriteString('Settings', 'Auto Save/Load Settings', BoolToStr(CheckBox14.Checked));
        Settings.WriteString('Settings', 'Limit CMD to 1 Execution', BoolToStr(CheckBox13.Checked));
        Settings.WriteString('Settings', 'Limit URL to 1 Execution', BoolToStr(CheckBox12.Checked));
        Settings.WriteString('Settings', 'Display Message when Blocking', BoolToStr(CheckBox11.Checked));

        Settings.WriteString('Settings', 'Command Line', '"' + Edit5.Text + '"');
        Settings.WriteString('Settings', 'URL', '"' + Edit1.Text + '"');
        Settings.WriteString('Settings', 'Password', '"' + Edit6.Text + '"');
        Settings.WriteString('Settings', 'Title', '"' + Edit3.Text + '"');
        Settings.WriteString('Settings', 'Message', '"' + Edit4.Text + '"');
        Settings.WriteString('Settings', 'Running Process', '"' + Edit2.Text + '"');
        Settings.WriteString('Settings', 'Other Executable', '"' + ExternalExecutable + '"');
        Settings.WriteString('Settings', 'Blocklist', '"' + StringReplace(Memo1.Text, #13#10, '?', [rfReplaceAll]) + '"');

        Settings.WriteString('Settings', 'Tries', IntToStr(SpinEdit1.Value));

      finally

        Settings.Free;  //Free Settings File

      end;

    end;

    if ToggleBox1.Checked then begin  //Check for blocking Status

      if MessageDlg('The Process blocking is still enabled. ' + LineEnding + 'Do you really want to close the Application?' + LineEnding + 'This will disable Process blocking.', mtWarning, [mbYes, mbNo], 0) = mrYes then begin

        TrayIcon1.Visible := False;  //Hide TrayIcon before closing the Application to prevent Leftovers
        CanClose := True;  //Allow Closing

      end
      else begin

        CanClose := False;  //Allow Closing

      end;

    end
    else begin

      TrayIcon1.Visible := False;  //Hide TrayIcon before closing the Application to prevent Leftovers

    end;

  end;

end;

procedure TForm1.FormCreate(Sender: TObject);  //Form Creation
begin

  TrayIcon1.Show;  //Show Tray Icon

  CheckBox4.Enabled := NOT IsAdmin;  //Test for Admin Status

  CheckBox4.Checked := IsAdmin;  //Set Admin Status

  if FileExists(ExtractFilePath(Application.ExeName) + 'Advanced Process Blocker.ini') then begin  //Check if Settings File is Present

    Settings := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Advanced Process Blocker.ini');

    try

      CheckBox5.Checked := StrToBool(Settings.ReadString('Settings', 'Execute Command', '0'));
      CheckBox6.Checked := StrToBool(Settings.ReadString('Settings', 'Open URL', '0'));
      CheckBox7.Checked := StrToBool(Settings.ReadString('Settings', 'Use Password to unblock', '0'));
      CheckBox9.Checked := StrToBool(Settings.ReadString('Settings', 'Show Message when blocked', '0'));
      CheckBox8.Checked := StrToBool(Settings.ReadString('Settings', 'Watch for running Process', '0'));
      CheckBox10.Checked := StrToBool(Settings.ReadString('Settings', 'Start other Executable', '0'));
      CheckBox1.Checked := StrToBool(Settings.ReadString('Settings', 'Disable Topmost Status', '0'));
      CheckBox2.Checked := StrToBool(Settings.ReadString('Settings', 'Disable Tray Icon', '0'));
      CheckBox3.Checked := StrToBool(Settings.ReadString('Settings', 'Prevent Application Termination', '0'));
      CheckBox14.Checked := StrToBool(Settings.ReadString('Settings', 'Auto Save/Load Settings', '0'));
      CheckBox13.Checked := StrToBool(Settings.ReadString('Settings', 'Limit CMD to 1 Execution', '0'));
      CheckBox12.Checked := StrToBool(Settings.ReadString('Settings', 'Limit URL to 1 Execution', '0'));
      CheckBox11.Checked := StrToBool(Settings.ReadString('Settings', 'Display Message when Blocking', '0'));

      Edit5.Text := Settings.ReadString('Settings', 'Command Line', '');
      Edit1.Text := Settings.ReadString('Settings', 'URL', '');
      Edit6.Text := Settings.ReadString('Settings', 'Password', '');
      Edit2.Text := Settings.ReadString('Settings', 'Running Process', '');
      Edit3.Text := Settings.ReadString('Settings', 'Title', '');
      Edit4.Text := Settings.ReadString('Settings', 'Message', '');
      ExternalExecutable := Settings.ReadString('Settings', 'Other Executable', '');
      Memo1.Text := StringReplace(Settings.ReadString('Settings', 'Blocklist', ''), '?', #13#10, [rfReplaceAll]);

      SpinEdit1.Value := StrToInt(Settings.ReadString('Settings', 'Tries', '0'));
      Label7.Caption := 'Current Executable: ' + ExtractFileName(ExternalExecutable);  //Set Label caption as Information

      if StrToBool(Settings.ReadString('Settings', 'Set Administrative Privileges', '0')) = True then Timer4.Enabled := True;

    finally

      Settings.Free //Free Settings File

    end;

  end;

end;

procedure TForm1.Image2Click(Sender: TObject);  //Github Icon Click
begin

  OpenUrl('https://github.com/EthernalStar/Advanced-Process-Blocker');  //Visit Github Repo Page

end;

procedure TForm1.Image3Click(Sender: TObject);  //Codeberg Icon Click
begin

    OpenUrl('https://codeberg.org/EthernalStar/Advanced-Process-Blocker');  //Visit Codeberg Repo Page

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

  ClipBrd.Clipboard.AsText := Label1.Caption;  //Copy PID Value to Clipboard
  Label1.Font.Color := $0000CE00; //Set Label Color to Green
  Label1.Caption := 'Copied!';  //Display Message indicating a successful Copy
  Timer3.Enabled := True;  //Revert Changes with timer

end;

procedure TForm1.Label3Click(Sender: TObject);  //Mail Label Click
begin

  OpenUrl('mailto:NZSoft@Protonmail.com');  //Open Email with mailto

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin

  if (StringGrid1.Row >= 1) AND (StringGrid1.Cells[0,StringGrid1.Row].Length > 0) then begin  //Only select the current PID if there is something to select in the first column

    GroupBox1.Enabled := True;  //Enable TabSheet after the user selects a PID
    Button7.Enabled := True;  //Enable Add Button after Selection

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

    if ( NOT CheckBox8.Checked ) OR ( ( CheckBox8.Checked ) AND ProcessExists( Edit2.Text ) ) then begin

      if KillProcessByName(Memo1.Lines[i]) then begin  //Try to kill Process

        BlockingEvents(Memo1.Lines[i]);  //Execute BlockingEvents Procedure
        BlockCount += 1;  //Increase Counter by 1
        Label5.Caption := IntToStr(BlockCount) + ' BLOCKED';  //Update Label

      end;

    end;

  end;

end;

procedure TForm1.Timer3Timer(Sender: TObject);  //Label Copy Status Reset
begin

  Label1.Font.Color := clblack;  //Reset Label Color
  Label1.Caption := IntToStr(MasterPID);  //Show Master PID Value again
  Timer3.Enabled := False;  //Disable Timer

end;

procedure TForm1.Timer4Timer(Sender: TObject);  //External Logic to Restart App as Admin if initiated through Settings
begin

  CheckBox4.Checked := True;  //Set Checkbox
  Timer4.Enabled := False;  //Disable Timer

end;

procedure TForm1.ToggleBox1Change(Sender: TObject);  //Enable Disable Blocking
begin

  if ToggleBox1.Checked = True then begin  //Check for Click

    ToggleBox1.Caption := 'Disable Blocking';  //Set Caption

  end
  else begin

    ToggleBox1.Caption := 'Enable Blocking';  //Set Caption

  end;

  Tries := SpinEdit1.Value;  //Set Password Tries

  if SpinEdit1.Value = 0 then begin  //Check for 0 in SpinEdit

    Tries := -1;  //Set unlimited Tries

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

