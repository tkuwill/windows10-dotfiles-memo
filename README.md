# windows10-dotfiles-memo
A TODO list after reinstalling windows.

# win10-dotfiles-memo 

### When reinstalling windows, MUST install below softwares.

1. [Apple Music ](https://apps.microsoft.com/detail/9pfhdd62mxs1?hl=zh-TW&gl=US)
2. [BlueStacks* ](https://www.bluestacks.com/download.html)
3. [Google Chrome*](https://www.google.com/intl/zh-TW/chrome/)
4. [Notepad++*](https://notepad-plus-plus.org/)
5. [Microsoft Office](https://support.microsoft.com/zh-tw/office/%E4%B8%8B%E8%BC%89%E4%B8%A6%E5%AE%89%E8%A3%9D%E6%88%96%E9%87%8D%E6%96%B0%E5%AE%89%E8%A3%9D-office-2021-office-2019-%E6%88%96-office-2016-7c695b06-6d1a-4917-809c-98ce43f86479)
6. [Thunderbird](https://www.thunderbird.net/zh-TW/?utm_source=www.mozilla.org&utm_medium=referral&utm_campaign=nav&utm_content=products)
7. [Uninstall Tool*](https://crystalidea.com/)
8. [VLC](https://www.videolan.org/)
9. [Windows Terminal*](https://apps.microsoft.com/detail/9n0dx20hk701?hl=zh-TW&gl=TW)
10. [Logi Options+*](https://www.logitech.com/zh-tw/software/logi-options-plus.html)
11. [weasel 小狼毫輸入法*](https://github.com/rime/weasel)
12. [Google 日本語入力*](https://www.google.co.jp/ime/)
13. [WinRAR*](https://www.win-rar.com/download.html?&L=0)

### MUST install command line tools & packages: 

1. git* 
2. streamlink*
3. yt-dlp*
4. PowerShell 7* (win10 preinstalled psh's version is old.)
5. winget (You may have to install it by yourself.)
6. starship* (For ricing)7. [Sarasa-Mono-TC-Nerd](https://github.com/AlexisKerib/Sarasa-Mono-TC-Nerd)
8. zoxide*9. bat*
10. fzf*

※Softwares with * mean you can install them by `winget`.

### PowerShell 's  config
- [$PROFILE](https://github.com/tkuwill/windows10-dotfiles-memo/blob/master/Microsoft.PowerShell_profile.ps1)

### Some config before using the PowerShell scripts 

1. Create a new directory `C:\bin`
2. copy `yt-dlp.exe` `ffmpeg.exe` `ffprobe.exe` into `C:\bin`.(This should do every time when `yt-dlp` or `ffmpeg` is updated.)
3. Follow below：
	1.	開啟系統屬性視窗：
		-	按下 Win 鍵 + S，搜尋 "環境變數"。
		-	點選 "編輯系統環境變數"。
		-	在彈出的「系統內容」視窗中，點擊右下角的 「環境變數(N)...」 按鈕。
	2.	編輯 Path 系統變數：
		-	在下方 「系統變數」 的列表中，找到並點選 Path 變數。
		-	點擊 「編輯(I)...」 按鈕。
	3.	新增路徑：
		-	在「編輯環境變數」的視窗中，點擊 「新增(N)」。
		-	輸入您在步驟二中建立的目錄的 完整路徑，例如：`C:\bin`。
		-	按下 Enter 鍵確認。
	4.	儲存並退出：
		-	一路點擊 「確定」 關閉所有視窗（「編輯環境變數」→「環境變數」→「系統內容」）。
