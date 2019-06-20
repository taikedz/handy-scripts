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

## Caps lock change

See `caps_lock_to_control.reg` - double click to apply, in Windows
