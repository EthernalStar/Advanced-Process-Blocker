# ![Logo](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Icon.png?raw=true) Advanced Process Blocker

**Advanced Process Blocker** is a Tool for terminating and blocking Processes by their PID or Name.  
It utilizes the Windows API and a few tricks for many features.  
The Tool was tested with Windows 10 but should also work with Windows 11.  
  

## Documentation

**Please Read the Instructions with care to avoid breaking anything!**  
  
The Tool itself is structured into two main segments:  
1. The Main Settings Section with the Tabs where you can configure the Processes.
2. The generated Process List.
  
**Also the Tool may be flagged as a false positive by your System.**
**If you are still unsure please check and compile the Source Code yourself or try it in a VM first!**   
  
If you want to hide the Application just click the Mini-Icon on the Taskbar.  
When manually terminating Applications a Status Message will briefly be displayed at the top of the Window.  
Also the current PID will be displayed at the top left corner of the Window. It can be copied by clicking.  
The number of currently blocked processes will also be displayed at the top of the Window.  

### Options Tab
  
![Options Tab Screenshot](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Images/Advanced%20Process%20Blocker%2001.png?raw=true)

After double clicking an Entry in the PID List below you can choose to simply terminate the choosen process with two different Methodes and Arguments.  
You will see visual feedback if the Process Termination succeeded or failed.  
**Kill Process by PID** uses the internal Windows API to kill the corresponding Process by its PID.  
**Kill Process by Name** does the same as the above but instead for **ALL** Processes with the same Executable Name.  
**Kill Process by PID with takkill** and **Kill Process by Name with taskkill** do the same as the other buttons but utilize the taskkill command instead.  

In the Panel for Process Blocking you will find diffrerent options to do just this.  
**Add Selected Entry** simply copies the current Executable Filename to a new Line in the Edit Field. You could also simply write the names in the Field.  
This Feature is currently only for Executable Names and not PIDs.  
**Clear All** clears the Edit Field and **Enable Blocking** Toggles the Blocking of the Processes on and off.  
Each time a Application was blocked the Counter on the Top of the Application will increase.  

Other Options include the Feature to **Reset the Blocking Counter** or to **Disable taskkill Sanitizing** (Explained when using this Feature).  


### Events Tab
  
![Events Tab Screenshot](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Images/Advanced%20Process%20Blocker%2002.png?raw=true)  

Here you can set various Events wich will be executed when an Application was blocked (not when it was manually terminated).  
Events:  
**Execute Command**: Executes the written Command (Executes cmd.exe /c <COMMANDLINE>). Can be limited to only 1 Execution. Limit can be reset at runtime.  
**Open URL**: Opens the set URL in your default Browser. Can be limited to only 1 Execution. Limit can be reset at runtime.  
**Use Password to unblock**: Opens a Dialog that requests the User to input the previously set Password to disable Blocking. Max Tries can be set and activating Lockdown Mode diables manual deactivation of the Application without Password or Taskmanager (wich could also be blocked by inputting taskmgr.exe).  
**Watch for running Process**: **Disables Blocking** unless an Application wich bears the set Executable Name is running. Can also display a Message (Looks like this: "Application A.exe could not be started because Application B.exe is currently running"). This also works when the blocking Process ist started later.  
**Show Message when blocked**: Shows a Message with custom Title after blocking the Process.  
**Start other Executable**: Starts Annother Executable instead of the one the user wanted to run and displays its Name.  


### Info Tab
  
![Info Tab Screenshot](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Images/Advanced%20Process%20Blocker%2003.png?raw=true)  

The Info Tab hold some self Settings for the Application itself.  
**Disable Topmost Status** and **Disable Tray Icon** are self-explanatory.  
**Prevent Application Termination** sets the internal CanClose Boolean from the OnCloseQuery Event to False and also hides the Close Button. This prevents you from closing the Application by accident or by pressing Alt + F4. It will **NOT** prevent closing through Taskmanager. Its also used by the Lockdown Mode.  
**Set Administrative Privileges** grants the Application Administrator Rights if it dos not already have them.  
**Hide Window and Tray Icon** does exactly what it says it does.  
  

## Use Cases
  
Ill admit that there are only a few real sittuations where this Application is useful but it helped me a lot when experimenting with stuff:  
  
Stopping applications wich are out of control or restarting themselves when closes by CMD or Task-Manager (playing with Form.OnClose is not allways a good Idea...).  
Preventing yourself from beeing distracted by specific Apps.  
Locking Applications with a temporary Password.  
Redirection the start of an Executable to a URL or Shell Comand (By executing cmd.exe).  
  

## Building

There should not be any Problem building the Application because it does not rely on any external installed Packages.  
To build the Project you need to have the Lazarus IDE Version 2.2.6 installed and clone this Repository to your local Machine.  
Now just open the .lpr file in your Lazarus Installation and you should be able to edit and compile the Project.  
  

## Issues
  
The Application provides a very simple solution to Block or Terminate Processes.  
Therefore it should not be used in serious situations because the Executable Name Blocks can be easily circumvented by renaming the Executable file.  
These Issues will not be adressed as this overturns the innitial scope of the Project.  
  

## Planned Features
  
Maybe something with blocking specific Hashes of Executable Files.  
Autostart with saved blocking Entries and Configurations.  
  

## Changelog

Version 1.0.0: Initial Release.  
  

## License

GNU General Public License v3.0. See [LICENSE](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/LICENSE) for further Information.
