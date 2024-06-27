# Required module
Install-Module -Name HtmlAgilityPack -Force

# Function to get cipher suite details from ciphersuite.info
function Get-CipherSuiteDetails {
    param (
        [string]$cipherSuite
    )

    # URL to scrape data from
    $url = "https://ciphersuite.info/cs/?sort=sec-desc&singlepage=true"

    # Load the HtmlAgilityPack module
    Import-Module HtmlAgilityPack

    # Download the HTML content
    $web = Invoke-WebRequest -Uri $url
    $html = $web.Content

    # Parse the HTML content
    $doc = [HtmlAgilityPack.HtmlDocument]::new()
    $doc.LoadHtml($html)

    # Find the relevant node
    $nodes = $doc.DocumentNode.SelectNodes('//ul[@class="prettylist"]/li')
    
    $cipherDetails = @()
    
    foreach ($node in $nodes) {
        $nameNode = $node.SelectSingleNode('.//span[@class="ciphername"]')
        if ($nameNode -ne $null) {
            $name = $nameNode.InnerText.Trim()
            if ($name -eq $cipherSuite) {
                $securityLevelNode = $node.SelectSingleNode('.//span[contains(@class, "security-level")]')
                $details = @{
                    "Name" = $name
                    "Security Level" = $securityLevelNode.InnerText.Trim()
                    "Details" = $node.InnerText.Trim()
                }
                $cipherDetails += $details
            }
        }
    }

    return $cipherDetails
}

# Known cipher suite to compare
$knownCipherSuite = "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"

# Get the cipher suite details
$cipherSuiteDetails = Get-CipherSuiteDetails -cipherSuite $knownCipherSuite

# Output the details
if ($cipherSuiteDetails.Count -gt 0) {
    $cipherSuiteDetails | Format-Table -AutoSize
} else {
    Write-Output "No matching cipher suite found."
}
