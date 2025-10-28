Set-Alias -Name 'vim' -Value 'C:\Program Files\Notepad++\notepad++.exe'
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadLineOption -MaximumHistoryCount 60000
Set-PSReadLineOption -EditMode Emacs


$ENV:STARSHIP_CONFIG = "$HOME\starship\starship.toml"
Invoke-Expression (&starship init powershell)