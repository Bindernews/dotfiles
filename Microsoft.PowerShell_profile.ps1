# Get rid of the annoying bell
Set-PSReadlineOption -BellStyle None

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
#Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Remove some default aliases that I don't want to confuse me
Remove-Item alias:wget
Remove-Item alias:rm

function Workon ($Venv) {
  $paths = @(
    "$Venv\Scripts\Activate.ps1",
    "$HOME\.virtualenvs\$Venv\Scripts\Activate.ps1"
  );
  $found = $false;
  foreach ($pt in $paths) {
    if (Test-Path -PathType Leaf $pt) {
      . $pt;
      $found = $true
      break;
    }
  }
  if (! $found) {
    Write-Error "No virtual environment with the given name!"
  }
}

function Monitor-Off () {
  # https://www.winhelponline.com/blog/turn-off-monitor-shortcut-command-windows/
  (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
}

function Use-Git () {
  Import-Module 'C:\Users\bindernews\Documents\WindowsPowerShell\posh-git\src\posh-git.psd1'
  & 'C:\Program Files\PuTTY\pageant.exe' $env:HOME\.ssh\lattice_rsa.ppk
  # Start-SshAgent
  # Add-SshKey $HOME/.ssh/lattice_rsa
}

function Use-Docker () {
  docker-machine.exe start default
  docker-machine.exe env default | Invoke-Expression
}

function Use-DepotTools () {
  $env:DEPOT_TOOLS_WIN_TOOLCHAIN=0
  $env:PATH="D:\Libraries\depot_tools;$env:PATH"
}

function Use-Faust () {
  $env:PATH="C:\Program Files\Faust\bin;$env:PATH"
}

function Use-CL64 () {
  cmd /k '"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat" && powershell && exit'
}

function Use-CL32 () {
  cmd /k '"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat" && powershell && exit'
}

function Use-WSL-Connect () {
  net use Z: "\\wsl$\Ubuntu-20.04"
}

function Steam-Dev () {
  pushd F:\Steam
  .\steam.exe -dev
  popd
}

function Get-Size {
  #.Synopsis
  #  Calculate the size of a folder on disk
  #.Description
  #  Recursively calculate the size of a folder on disk,
  #  outputting it's size, and that of all it's children,
  #  and optionally, all of their children
  param(
    [string]$root,
    # Show the size for each descendant recursively (otherwise, only immediate children)
    [switch]$recurse
  )
  # Get the full canonical FileSystem path:
  $root = Convert-Path $root

  $size = 0
  $files = 0
  $folders = 0

  $items = Get-ChildItem $root
  foreach($item in $items) {
    if($item.PSIsContainer) {
      # Call myself recursively to calculate subfolder size
      # Since we're streaming output as we go, 
      #   we only use the last output of a recursive call
      #   because that's the summary object
      if($recurse) {
        Get-Size $item.FullName | Tee-Object -Variable subItems
        $subItem = $subItems[-1]
      } else {
        $subItem = Get-Size $item.FullName | Select -Last 1
      }

      # The (recursive) size of all subfolders gets added
      $size += $subItem.Size
      $folders += $subItem.Folders + 1
      $files += $subItem.Files
      Write-Output $subItem
    } else {
      $files += 1
      $size += $item.Length
    }
  }

  # in PS3, use the CustomObject trick to control the output order
  if($PSVersionTable.PSVersion -ge "3.0") {
    [PSCustomObject]@{ 
      Folders = $folders
      Files = $Files
      Size = $size
      Name = $root
    }
  } else {
    New-Object PSObject -Property @{ 
      Folders = $folders
      Files = $Files
      Size = $size
      Name = $root
    }
  }
}

# Configure console colors
$console = $Host.UI.RawUI
$console.BackgroundColor = 'black'
$console.ForegroundColor = 'white'
$colors = $Host.PrivateData
$colors.VerboseBackgroundColor = 'Magenta'
$colors.VerboseForegroundColor = 'Green'
$colors.WarningBackgroundColor = 'Red'
$colors.WarningForegroundColor = 'White'
#$colors.ErrorBackgroundColor = 'DarkCyan'
$colors.ErrorBackgroundColor = 'black'
$colors.ErrorForegroundColor = 'Yellow'

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

