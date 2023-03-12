$Menu = {
   Write-Host " ******************************************************"
   Write-Host " * Microsoft Office Installation Script               *" 
   Write-Host " * Date:    26/02/2023                                *" 
   Write-Host " * Author:  https://github.com/bonben365              *" 
   Write-Host " * Website: https://bonben365.com/                    *" 
   Write-Host " ******************************************************" 
   Write-Host 
   Write-Host " 1. Install Office 365 / Microsoft 365 (32bit)" 
   Write-Host " 2. Install Office 365 / Microsoft 365 (64bit)" 
   Write-Host " 3. Convert Office 365 / Microsoft 365 from 32-bit to 64-bit" 
   Write-Host " 4. Convert Office 365 / Microsoft 365 from 64-bit to 32-bit" 
   Write-Host " 5. Uninstall All Previous Versions of Microsoft Office"
   Write-Host " 6. Quit or Press Ctrl + C"
   Write-Host 
   Write-Host " Select an option and press Enter: "  -nonewline
}
   cls

$Menu1 = {
   Write-Host " *************************************************"
   Write-Host " * Select a Microsoft Office 365 Product         *" 
   Write-Host " *************************************************" 
   Write-Host 
   Write-Host " 1. Office 365 Home"
   Write-Host " 2. Office 365 Personal"
   Write-Host " 3. Microsoft 365 Apps for Business" 
   Write-Host " 4. Microsoft 365 Apps for Enterprise" 
   Write-Host " 5. Go Back"
   Write-Host 
   Write-Host " Select an option and press Enter: "  -nonewline
} 
   cls

$install = {
   $null = New-Item -Path $env:temp\c2r -ItemType Directory -Force
   Set-Location $env:temp\c2r
   $fileName = "configuration-x$arch.xml"
   New-Item $fileName -ItemType File -Force | Out-Null
   Add-Content $fileName -Value '<Configuration>'
   Add-content $fileName -Value "<Add OfficeClientEdition=`"$arch`" Channel=`"Current`">"
   Add-content $fileName -Value "<Product ID=`"$productId`">"
   Add-content $fileName -Value '<Language ID="en-us" />'
   Add-Content $fileName -Value '</Product>'
   Add-Content $fileName -Value '</Add>'
   Add-Content $fileName -Value '</Configuration>'
   Write-Host
   Write-Host ============================================================
   Write-Host "Installing $productId $arch bit"
   Write-Host ============================================================
   Write-Host

   $uri = 'https://github.com/bonben365/office365-installer/raw/main/setup.exe'
   (New-Object Net.WebClient).DownloadFile($uri, "$env:temp\c2r\setup.exe")
   .\setup.exe /configure .\$fileName
   Start-Sleep -Seconds 10
   
   # Cleanup
   Set-Location $env:temp
   Remove-Item $env:temp\c2r -Recurse -Force
   Start-Sleep -Seconds 10
}

$uninstall = {
   $null = New-Item -Path $env:temp\uninstall -ItemType Directory -Force
   Set-Location $env:temp\uninstall
   $fileName = 'configuration.xml'
   $null = New-Item $fileName -ItemType File -Force
   Add-Content $fileName -Value '<Configuration>'
   Add-Content $fileName -Value '<Remove All="True"/>'
   Add-Content $fileName -Value '</Configuration>'
   $uri = 'https://github.com/bonben365/office365-installer/raw/main/setup.exe'
   (New-Object Net.WebClient).DownloadFile($uri, "$env:temp\c2r\setup.exe")
   .\setup.exe /configure .\configuration.xml

   Write-Host
   Write-Host ============================================================
   Write-Host "Unnstalling...."
   Write-Host ============================================================
   Write-Host

   Write-Host
   Write-Host ============================================================
   Write-Host "Done...."
   Write-Host ============================================================
   Write-Host
   Start-Sleep -Seconds 10

   # Cleanup
   Set-Location $env:temp
   Remove-Item $env:temp\uninstall -Recurse -Force
   Start-Sleep -Seconds 5
}

$convert = {
   $null = New-Item -Path $env:temp\convert -ItemType Directory -Force
   Set-Location $env:temp\convert
   $fileName = "configuration.xml"
   New-Item $fileName -ItemType File -Force | Out-Null
   Add-Content $fileName -Value '<Configuration>'
   Add-content $fileName -Value "<Add OfficeClientEdition=`"$bit`" MigrateArch=`"TRUE`">"
   Add-Content $fileName -Value '</Add>'
   Add-Content $fileName -Value '</Configuration>'
   Write-Host
   Write-Host ============================================================
   Write-Host "Processing..................."
   Write-Host ============================================================
   Write-Host

   $uri = 'https://github.com/bonben365/office365-installer/raw/main/setup.exe'
   (New-Object Net.WebClient).DownloadFile($uri, "$env:temp\c2r\setup.exe")
   .\setup.exe /configure .\$fileName
   Start-Sleep -Seconds 10

   # Cleanup
   Set-Location $env:temp
   Remove-Item $env:temp\convert -Recurse -Force
   Start-Sleep -Seconds 10
}
  
   Do { 
      cls
      Invoke-Command $Menu
      $Select = Read-Host

      if ($select -eq 1) {$arch = '32'}
      if ($select -eq 2) {$arch = '64'}
      if ($select -eq 3) {$bit = '64'}
      if ($select -eq 4) {$bit = '32'}

   Switch ($Select)
      {
         #1. Office 365 / Microsoft 365 (32-bit)
          1 {                       
               Do { 
                  cls
                  Invoke-Command $Menu1
                  $Select1 = Read-Host
      
                  if ($Select1 -eq 1) {$productId = 'O365HomePremRetail'}
                  if ($Select1 -eq 2) {$productId = 'O365HomePremRetail'}
                  if ($Select1 -eq 3) {$productId = 'O365BusinessRetail'}
                  if ($Select1 -eq 4) {$productId = 'O365ProPlusRetail'}
         
               Switch ($Select1) {
                  1 { Invoke-Command $install }
                  2 { Invoke-Command $install }
                  3 { Invoke-Command $install }
                  4 { Invoke-Command $install }
               }
               }

               While ($Select1 -ne 5)
               cls
            }

         #2. Office 365 / Microsoft 365 (64-bit)
          2 {                       
            Do { 
               cls
               Invoke-Command $Menu1
               $Select1 = Read-Host
   
               if ($Select1 -eq 1) {$productId = 'O365HomePremRetail'}
               if ($Select1 -eq 2) {$productId = 'O365HomePremRetail'}
               if ($Select1 -eq 3) {$productId = 'O365BusinessRetail'}
               if ($Select1 -eq 4) {$productId = 'O365ProPlusRetail'}
      
            Switch ($Select1) {
               1 { Invoke-Command $install }
               2 { Invoke-Command $install }
               3 { Invoke-Command $install }
               4 { Invoke-Command $install }
            }
            }

            While ($Select1 -ne 5)
            cls
         }
            
         3 {Invoke-Command $convert}
         4 {Invoke-Command $convert}    
         5 {Invoke-Command $uninstall}



      }
   }
   While ($Select -ne 6)
