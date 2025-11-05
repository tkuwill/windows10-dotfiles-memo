# --------------------------------------------------------
# [PowerShell 7 專用] PS2EXE 模組編譯腳本
# 解決 PS7 無法處理 Win32 資源（圖示/版本資訊）的問題。
# 原理：從 PS7 呼叫 PS5.1 (powershell.exe) 執行編譯。
# --------------------------------------------------------

# ===== 1. 設定變數 (請修改為您的路徑) =====

# 您的 PowerShell 腳本路徑
$ScriptPath = "C:\TempPS\mpvplayer.ps1"       

# 您的自定義圖示 (.ico) 路徑
$IconPath   = "C:\TempPS\mpvplayer.ico"  

# 最終輸出的 EXE 檔案路徑
$OutputPath = "C:\TempPS\mpv_player_menu.exe" 


# ===== 2. 核心編譯邏輯 (請勿修改) =====

# 備註：以下參數 (如 -fileVersion) 已被移除，因為您的 PS2EXE 版本不支援。
# 僅保留核心功能：輸入、輸出、不顯示控制台、顯示詳細資訊、圖示。

# 建立用於 PS5.1 執行的命令字串
# 使用單行字串來避免 PS7/PS5.1 之間的解析和換行符號問題。
$PS5_Compile_Command = "Import-Module PS2EXE -ErrorAction Stop; Invoke-PS2EXE -InputFile '$ScriptPath' -OutputFile '$OutputPath' -noConsole -verbose -iconFile '$IconPath'"


# ===== 3. 執行編譯程序 (在 PS7 中呼叫 PS5.1) =====

Write-Host "---"
Write-Host "🚀 正在從 PowerShell 7 (pwsh) 啟動 PowerShell 5.1 (powershell.exe) 進行編譯..."
Write-Host "輸入腳本: $ScriptPath"
Write-Host "輸出檔案: $OutputPath"
Write-Host "---"
    
# 使用 & 運算子啟動 powershell.exe，並將命令字串傳遞給 -Command 參數
& powershell.exe -NoProfile -ExecutionPolicy Bypass -Command $PS5_Compile_Command

Write-Host ""
Write-Host "✅ 編譯完成！請檢查 $OutputPath 是否存在並可執行。"