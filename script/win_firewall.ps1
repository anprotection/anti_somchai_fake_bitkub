# ใช้ relative path ไปยังโฟลเดอร์ list
$dirPath = ".\list"

# ดึงไฟล์ .txt ทั้งหมดในโฟลเดอร์ list
$txtFiles = Get-ChildItem -Path $dirPath -Filter *.txt

foreach ($file in $txtFiles) {
    # อ่านเนื้อหาไฟล์ (แต่ละบรรทัดคือโดเมน)
    $domains = Get-Content -Path $file.FullName

    foreach ($domain in $domains) {
        $domain = $domain.Trim()
        if (-not [string]::IsNullOrWhiteSpace($domain)) {
            $ruleName = "Block_$domain"

            # ตรวจสอบว่ามี rule อยู่แล้วหรือยัง
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
