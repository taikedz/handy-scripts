# Windows configurations

Should I ever be pulled back onto a Windows machine

## Prevent Windows from auto rebooting

Locate/create `DWORD32` key:

* Start `regedit`
* Drill down to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU`
* Ensure key `NoAutoRebootWithLoggedOnUsers` with value `1`
* In command window run `gpupdate /force` to make this apply immediately (and not after next undesired reboot)

## Caps lock change

See `caps_lock_to_control.reg` - double click to apply, in Windows
