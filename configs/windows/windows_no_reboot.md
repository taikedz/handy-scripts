# Windows configurations

Should I ever be pulled back onto a Windows machine

## Prevent Windows from auto rebooting

Locate/create `DWORD32` key:

* Start `regedit`
* Drill down to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU`
* Ensure key `NoAutoRebootWithLoggedOnUsers` with value `1`
* In command window run `gpupdate /force` to make this apply immediately (and not after next undesired reboot)

## Prevent reboot script

Disable the reboot commandlet by replacing it with a dummy

<https://www.windowscentral.com/how-prevent-windows-10-rebooting-after-installing-updates>

* Open `%windir%\System32\Tasks\Microsoft\Windows\UpdateOrchestrator`
* Rename `Reboot` to `Reboot.old`
* Create folder `Reboot`

### Group Policy

> To configure the policy, open Local Group Policy Editor (GPEdit.msc), the navigate to Computer Configuration -> Administrative Templates -> Windows Components -> Windows Update. Set the status of No auto-restart with logged on users for scheduled automatic updates installations to Enabled so that Automatic Updates will not restart a computer automatically during a scheduled installation if a user is logged in to the computer. Instead, Automatic Updates will notify the user to restart the computer.

### Task Scheduler

<https://techjourney.net/permanently-disable-prevent-automatic-restart-of-windows-update-in-windows-10/>

> Open Task Scheduler.
> In Task Scheduler, expand the Task Scheduler tree to go to Task Scheduler Library -> Microsoft -> Windows -> UpdateOrchestrator.
> Right click on Reboot task, and Disable it.
>
> Disable Reboot in Windows 10
> Windows 10 will attempt to sneakily re-enable the Reboot task automatically. To stop the re-enabling of Reboot task, open File Explorer, and navigate to the following folder:
>
> %Windows%\System32\Tasks\Microsoft\Windows\UpdateOrchestrator
> Right click on the Reboot file (without extension), and select Properties. Go to Security tab then hit Advanced button. Change the ownership to your own user account. Then, hit “Change permissions”, and disable the inheritance of permissions, and all permissions (i.e. SYSTEM, LOCAL SERVICE and your user account) to read or read & execute only (ensure that no write, modify or full control permission is granted). This ensure of Windows OS cannot make any changes to the Reboot task.
>
> Remove Write & Modify Permissions for Reboot Task
>
> Alternatively, rename the Reboot file to another name, such as Reboot.bak (you may need to take ownership of the file). Then create a new folder and name it as “Reboot” to prevent the task with the same name been created again.

## Caps lock change

See `caps_lock_to_control.reg` - double click to apply, in Windows
