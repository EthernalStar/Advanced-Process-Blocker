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

### Events Tab
  
![Events Tab Screenshot](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Images/Advanced%20Process%20Blocker%2002.png?raw=true)
  
### Info Tab
  
![Info Tab Screenshot](https://github.com/EthernalStar/Advanced-Process-Blocker/blob/main/Images/Advanced%20Process%20Blocker%2003.png?raw=true)

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
