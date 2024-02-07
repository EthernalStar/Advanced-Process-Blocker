# ![Logo](./Icon.png?raw=true) Advanced Process Blocker

**Advanced Process Blocker** is a Tool for terminating and blocking Processes by their PID or Name.

It utilizes the Windows API and a few tricks for many features.

The Tool was tested with Windows 10 but should also work with Windows 11.

## Documentation

**Please Read the Instructions with care to avoid breaking anything!**

**Also the Tool may be flagged as a false positive by your System.**

**If you are still unsure please check and compile the Source Code yourself or try it in a VM first!** 

The Tool itself is structured into two main segments:
1. The Main Settings Section with the Tabs where you can configure the Processes.
2. The generated Process List.

If you want to hide the Application Window just click on the Tray-Icon on the Taskbar.

### Options Tab

![Options Tab Screenshot](./Images/Advanced%20Process%20Blocker%2001.png?raw=true)

After double clicking an Entry in the PID List below you can choose to simply terminate the choosen process with two different Methodes and Arguments.
You will see visual feedback at the top of the Window if the Process Termination succeeded or failed.
* **Kill Process by PID** uses the internal Windows API to kill the corresponding Process by its PID.
* **Kill Process by Name** does the same as the above but instead for **ALL** Processes with the same Executable Name.
* **Kill Process by PID with takkill** and **Kill Process by Name with taskkill** do the same as the other buttons but utilize the taskkill command instead.

In the Panel for Process Blocking you will find diffrerent options to do just this.
* **Add Selected Entry** simply copies the current Executable Filename to a new Line in the Edit Field. You could also simply write the names in the Field. This Feature is currently only for Executable Names and not PIDs.
* **Clear All** clears the Edit Field and **Enable Blocking** Toggles the Blocking of the Processes on and off.

While **Enable Blocking** is active you'll always be asked for confirmation before closing the Application (As of v1.0.1).

You can also search for the **Name** or **PID** of a Process using the **Search in Process List** Field (As of v1.0.1).

Each time an Application was blocked the Counter on the Top of the Window will increase.

Other Options include the Feature to **Reset the Blocking Counter** or to **Disable taskkill Sanitizing** wich is explained when using this Feature.

Also the current PID will be displayed at the top left corner of the Window. It can be copied by clicking.

### Events Tab

![Events Tab Screenshot](./Images/Advanced%20Process%20Blocker%2002.png?raw=true)

Here you can set various Events wich will be executed when an Application was blocked (not when it was manually terminated):

* **Execute Command**: Executes the written Command (Executes cmd.exe /c <COMMANDLINE>). Can be limited to only 1 Execution. Limit can be reset at runtime.
* **Open URL**: Opens the set URL in your default Browser. Can be limited to only 1 Execution. Limit can be reset at runtime.
* **Use Password to unblock**: Opens a Dialog that requests the User to input the previously set Password to disable Blocking. Max Tries can be set and activating Lockdown Mode diables manual deactivation of the Application without Password or Taskmanager (wich could also be blocked by inputting taskmgr.exe).
* **Watch for running Process**: **Disables Blocking** unless an Application wich bears the set Executable Name is running. Can also display a Message (Looks like this: "Application A.exe could not be started because Application B.exe is currently running"). This also works when the blocking Process is started later.
* **Show Message when blocked**: Shows a Messagebox with custom Title and Message after blocking the Process.
* **Start other Executable**: Starts Annother Executable instead of the one the user wanted to run and displays its Name.

### Info Tab

![Info Tab Screenshot](./Images/Advanced%20Process%20Blocker%2003.png?raw=true)

The Info Tab hold some self Settings for the Application itself:
* **Disable Topmost Status** and **Disable Tray Icon** are self-explanatory.
* **Prevent Application Termination** sets the internal CanClose Boolean from the OnCloseQuery Event to False and also hides the Close Button. This prevents you from closing the Application by accident or by pressing Alt + F4. It will **NOT** prevent closing through Taskmanager. Its also used by the Lockdown Mode.
* **Set Administrative Privileges** grants the Application Administrator Rights if it dos not already have them.
* **Hide Window and Tray Icon** does exactly what it says it does.
* **Auto Save/Load Settings**: toggles the ability to save all Settings in an ini File (As of v1.0.1).
* By pressing the Button **Export Process List to CSV File** you could save your current List for external use (As of v1.0.1).  
* The Button "**See latest Changelog**" just shows the most recent Changelog.
* The Button "**See License Information**" just shows the License of this Project.

There are also links to my Repositories on [Github](https://github.com/EthernalStar) or [Codeberg](https://codeberg.org/EthernalStar) where you could always find the latest Version.
If you have questions please don't hesitate to contact me over [E-Mail](mailto:NZSoft@Protonmail.com) or create an Issue on the Project Page.

## Use Cases

Here are some situations where I use this Tool:

* Stopping Applications wich are out of control or restarting themselves when closed by CMD or the Task-Manager.
* Preventing yourself from beeing distracted by specific Apps.
* Locking Applications with a temporary Password.
* Redirecting the start of an Executable to a URL or Shell Comand (By executing cmd.exe).

## Building

There shouldn't be any Problem building the Application because it doesn't rely on any external installed Packages.
To build the Project you need to have the [Lazarus IDE](https://www.lazarus-ide.org/) Version 2.2.6 installed.
After you have downloaded the Source Code or cloned this Repo just open the Project in your Lazarus Installation.
To do this just open the .lpr file and you should be able to edit and compile the Project.

## Issues

* The Application provides a very simple solution to Block or Terminate Processes.
Therefore it should not be used in serious situations because the Executable Name Blocks can be easily circumvented by renaming the Executable file.
These Issues will not be adressed as this overturns the innitial scope of the Project.

## Planned Features

* Currently there are no planned Features.

## Changelog

* Version 1.0.0:
  * Initial Release.
* Version 1.0.1:
  * Added Feature to save Settings.
  * Added Searching Feature for the Process List.
  * Added CSV export of the Process List.
  * Added Copy Indicator for displayed Handle. 
  * Added closing confirmation Dialog if blocking is enabled.
  * Improved Scrolling with the Process List.
  * WIP: Replaced Clear Password with SHA-512 Hash.
  * Rewritten Information Section to be more usable.
  * Minor visual fixes.

## License

* GNU General Public License v3.0. See [LICENSE](./LICENSE) for further Information.
