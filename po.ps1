[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(600,400)
$Form.StartPosition = "CenterScreen" #loads the window in the center of the screen
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow #modifies the window border
$Form.Text = "Ping GUI tool" #window description


  
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
}
############################################## Start functions

function procInformation {
try {
if ($arch32.Checked -eq $true) {$arch='32'}
if ($arch64.Checked -eq $true) {$arch='64'}
if ($office1.Checked -eq $true) {$productId = 'O365HomePremRetail'}


Invoke-Command $install

       } #end try

catch {$outputBox.text = "`nOperation could not be completed"}

                           } # end procInformation                  

############################################## end functions

############################################## Start group boxes

$arch = New-Object System.Windows.Forms.GroupBox
$arch.Location = New-Object System.Drawing.Size(10,10) 
$arch.size = New-Object System.Drawing.Size(130,70) 
$arch.text = "Arch:"
$Form.Controls.Add($arch) 

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(250,60) 
$groupBox.size = New-Object System.Drawing.Size(130,150) 
$groupBox.text = "Microsoft 365:"
$Form.Controls.Add($groupBox) 



############################################## end group boxes

############################################## Start check boxes

$arch64 = New-Object System.Windows.Forms.checkbox
$arch64.Location = New-Object System.Drawing.Size(10,20)
$arch64.Size = New-Object System.Drawing.Size(100,20)
$arch64.Checked = $true
$arch64.Text = "64 bit"
$arch.Controls.Add($arch64)

$arch32 = New-Object System.Windows.Forms.checkbox
$arch32.Location = New-Object System.Drawing.Size(10,40)
$arch32.Size = New-Object System.Drawing.Size(100,20)
$arch32.Checked = $false
$arch32.Text = "32 bit"
$arch.Controls.Add($arch32)

$office1 = New-Object System.Windows.Forms.checkbox
$office1.Location = New-Object System.Drawing.Size(10,20)
$office1.Size = New-Object System.Drawing.Size(100,20)
$office1.Checked = $true
$office1.Text = "Home"
$groupBox.Controls.Add($office1)

$office2 = New-Object System.Windows.Forms.checkbox
$office2.Location = New-Object System.Drawing.Size(10,40)
$office2.Size = New-Object System.Drawing.Size(100,20)
$office2.Text = "Business"
$groupBox.Controls.Add($office2)

$procSpeed = New-Object System.Windows.Forms.checkbox
$procSpeed.Location = New-Object System.Drawing.Size(10,60)
$procSpeed.Size = New-Object System.Drawing.Size(100,20)
$procSpeed.Text = "Enterprise"
$groupBox.Controls.Add($procSpeed)

############################################## end check boxes



############################################## Start buttons

$Button = New-Object System.Windows.Forms.Button 
$Button.Cursor = [System.Windows.Forms.Cursors]::Hand
$Button.BackColor = [System.Drawing.Color]::LightGreen
$Button.Location = New-Object System.Drawing.Size(400,30) 
$Button.Size = New-Object System.Drawing.Size(110,40) 
$Button.Text = "Install" 
$Button.Add_Click({procInformation}) 
$Form.Controls.Add($Button) 

############################################## end buttons

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
