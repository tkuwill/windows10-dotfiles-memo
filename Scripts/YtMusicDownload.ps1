<#
.SYNOPSIS
    YouTube 音樂下載腳本 (PowerShell 版本)
.DESCRIPTION
    使用 yt-dlp 提取 YouTube 音樂，並提示使用者重新命名檔案。
    需要 yt-dlp.exe 和 ffmpeg.exe 且設置正確。
#>

# ----------------------------------------------------
# 📌 步驟 1: 配置變數 (請修改此處的絕對路徑)
# ----------------------------------------------------
# 務必將此路徑替換為您 yt-dlp.exe 的實際絕對路徑
$YT_DLP_CMD = "C:\bin\yt-dlp.exe" 

$DOWNLOAD_DIR = "$env:USERPROFILE\Downloads"
$TEMP_BASENAME = "temp_dl_music"

# 載入所需的 .NET Assembly 以使用圖形介面彈出框
Add-Type -AssemblyName Microsoft.VisualBasic, System.Windows.Forms

# ----------------------------------------------------
# 📌 步驟 2: 輔助函數
# ----------------------------------------------------

# 函數：彈出輸入框 (取代 dialog --inputbox)
function Get-UserInput {
    param(
        [string]$Message,
        [string]$Title
    )
    $input = [Microsoft.VisualBasic.Interaction]::InputBox($Message, $Title, "")
    
    # 如果使用者按下 Cancel 或輸入空字串，則回傳 $null
    if ([string]::IsNullOrEmpty($input)) {
        return $null
    } else {
        return $input
    }
}

# 函數：彈出訊息框 (取代 dialog --msgbox)
function Show-Message {
    param(
        [string]$Message,
        [string]$Title
    )
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
}

# ----------------------------------------------------
# 📌 步驟 3: 主要腳本邏輯
# ----------------------------------------------------

if (-not (Test-Path $YT_DLP_CMD)) {
    Show-Message -Title "嚴重錯誤" -Message "找不到 yt-dlp.exe，請檢查 $YT_DLP_CMD 路徑是否正確。"
    exit
}

while ($true) {
    # 1. 取得 YouTube URL
    $URL = Get-UserInput -Title "音樂下載 (PowerShell)" -Message "請輸入歌曲的 YouTube 連結 (URL):"
    
    # 檢查是否取消
    if (-not $URL) {
        Show-Message -Title "已取消" -Message "下載程序已取消。"
        break
    }
    
    # 2. 設定下載目錄並切換工作目錄
    if (-not (Test-Path $DOWNLOAD_DIR)) {
        Show-Message -Title "錯誤" -Message "找不到下載目錄: $DOWNLOAD_DIR"
        break
    }
    Set-Location $DOWNLOAD_DIR
    Show-Message -Title "下載準備" -Message "已切換工作目錄到: $DOWNLOAD_DIR"

    # 3. 準備 yt-dlp 參數
    $OutputFileTemplate = "$TEMP_BASENAME.%(ext)s" 
    $TempLogFile = [System.IO.Path]::GetTempFileName()
    
    # 使用 Start-Process 傳遞參數：移除 --print-filepath 避免舊版本錯誤
    $arguments = @(
        "-f", "ba", 
        "-x", 
        "--audio-format", "mp3", 
        "`"$URL`"",  # 確保 URL 被引號包圍
        "-o", "`"$DOWNLOAD_DIR\$OutputFileTemplate`"" # 輸出路徑
    )
    
    Write-Host "--- 開始下載 (yt-dlp) ---"
    
    try {
        # 使用 Start-Process 執行 (最穩健的方式)
        $proc = Start-Process -FilePath $YT_DLP_CMD -ArgumentList $arguments -NoNewWindow -Wait -PassThru -RedirectStandardOutput $TempLogFile -WorkingDirectory $DOWNLOAD_DIR
        
        # 檢查程式退出代碼
        if ($proc.ExitCode -ne 0) {
             # 如果返回代碼非零，則判斷為失敗。讀取日誌，顯示錯誤。
             $dlpErrorLog = Get-Content $TempLogFile -ErrorAction SilentlyContinue
             throw "yt-dlp 程式執行失敗，返回代碼 $($proc.ExitCode)。日誌: $($dlpErrorLog -join ' | ')"
        }
        
    } catch {
        Show-Message -Title "下載錯誤" -Message "yt-dlp 執行失敗。錯誤訊息: $($_.Exception.Message)"
        continue
    } finally {
        # 無論成功或失敗，都刪除臨時檔案
        Remove-Item $TempLogFile -ErrorAction SilentlyContinue
    }

    # 4. 檔案捕獲邏輯 (尋找檔案，取代 --print-filepath)
    $SearchPattern = "$TEMP_BASENAME*.mp3"
    
    # 尋找最近下載的檔案 (依據寫入時間排序，取最新的)
    $DownloadedFile = Get-ChildItem -Path $DOWNLOAD_DIR -Filter $SearchPattern | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 1

    if (-not $DownloadedFile) {
        Show-Message -Title "檔案錯誤" -Message "yt-dlp 執行成功 (ExitCode 0)，但找不到檔案：$SearchPattern。請檢查 yt-dlp 是否安裝 FFmpeg。"
        continue
    }
    
    # 取得找到的檔案的完整路徑
    $TEMP_FILE_PATH = $DownloadedFile.FullName

    # 5. 取得最終歌曲名稱並重新命名
    while ($true) {
        $SongName = Get-UserInput -Title "重新命名" -Message "下載完成。請輸入最終歌曲名稱 (不需副檔名):"
        
        if (-not $SongName) {
            Show-Message -Title "警告" -Message "未輸入名稱，跳過重新命名。"
            break
        }
        
        # 確保檔名安全
        $SafeSongName = $SongName -replace '[\\/:*?"<>|]', '_'
        $FINAL_NAME = "$DOWNLOAD_DIR\$SafeSongName.mp3"
        
        try {
            # Move-Item 相當於 mv
            Move-Item -Path $TEMP_FILE_PATH -Destination $FINAL_NAME -Force
            Show-Message -Title "成功" -Message "檔案已重新命名為：$SafeSongName.mp3"
            break # 成功重新命名，退出內層迴圈
        } catch {
            Show-Message -Title "錯誤" -Message "重新命名失敗。請檢查檔案名稱是否包含不允許的字元。錯誤: $($_.Exception.Message)"
        }
    }
}