# PowerShell Configuration

# module Configuration
Set-Alias -Name 'vim' -Value 'C:\Program Files\Notepad++\notepad++.exe'
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadLineOption -MaximumHistoryCount 60000
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

$ENV:STARSHIP_CONFIG = "$HOME\starship\starship.toml"
# zoxide starting
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# prompt Configuration
Invoke-Expression (&starship init powershell)