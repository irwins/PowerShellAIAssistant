<#
.SYNOPSIS
    Invokes an AI to explain a given text.

.DESCRIPTION
    The Invoke-AIExplain function is used to invoke an AI to explain a given text. It provides an interactive prompt for the user to enter the text they want to explain. If no text is provided, it will use the last command from the command history. The function supports an optional switch parameter to display the explanation as a bullet list.

.PARAMETER Text
    Specifies the text to be explained. If not provided, the last command from the command history will be used.

.PARAMETER AsBulletList
    Displays the explanation as a bullet list if this switch is specified.

.EXAMPLE
    Invoke-AIExplain -Text "This is a sample text to be explained."

    This example invokes the AI to explain the provided text.

.EXAMPLE
    Invoke-AIExplain -AsBulletList

    This example invokes the AI to explain the last command from the command history and displays the explanation as a bullet list.

.OUTPUTS
    The explanation generated by the AI.
#>
function Invoke-AIExplain {
    [CmdletBinding()]
    [alias("explain")]
    param (
        $Text,
        [Switch]$AsBulletList
    )

    if ($null -eq $Text) {
        # read history
        $Text = (Get-History -Count 1).CommandLine
    }
      
    if ($AsBulletList) {
        $bulletListPrompt = "I have the preference for bulleted lists. I personally digest information better that way."
    }

    $prompt = @"
Be brief, and explain thouroughly.
You are running powershell on $($PSVersionTable.Platform).
$($bulletListPrompt)

Please explain the following:

$text
"@

    Write-Host "Getting explanation..." -ForegroundColor Yellow
    $result = ai $prompt

    if (Get-Command glow -ErrorAction SilentlyContinue) {
        $result | glow
    }
    else {
        $result        
    }
}

<#
$code = @'
$users = Get-ADUser -LDAPFilter "(&(userAccountControl:1.2.840.113556.1.4.803:=2)(|(samaccountname=stah*Xsamaccountname=rams*)))" | Select-Object samaccountname surname, enabled
'@
#>