# ใช้ relative path ไปยังโฟลเดอร์ list
$dirPath = "..\list"   # ถ้ารันจาก script/
# หรือถ้ารันจาก project-root ให้ใช้ ".\list"

# ดึงไฟล์ .txt ทั้งหมดในโฟลเดอร์ list
$txtFiles = Get-ChildItem -Path $dirPath -Filter *.txt

foreach ($file in $txtFiles) {
    $domains = Get-Content -Path $file.FullName

    foreach ($domain in $domains) {
        $domain = $domain.Trim()
        if (-not [string]::IsNullOrWhiteSpace($domain)) {
            $ruleName = "Block_$domain"

            $existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
            if (-not $existingRule) {
                New-NetFirewallRule -DisplayName $ruleName `
                                    -Direction Outbound `
                                    -Action Block `
                                    -RemoteFqdn $domain `
                                    -Enabled True
                Write-Host "Added rule for $domain"
            } else {
                Write-Host "Rule for $domain already exists"
            }
        }
    }
}
