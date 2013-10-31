function encrypt-gpgfile
{
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.INPUTS
Nothing can be piped directly into this function

.EXAMPLE

.EXAMPLE

.OUTPUTS

.NOTES
NAME: 
AUTHOR: 
LASTEDIT: 
KEYWORDS:

.LINK

#>
[CMDLetBinding()]
param
(
	[Parameter(mandatory=$true)] [string[]] $recipient,
	[Parameter(mandatory=$true)] $sourcefile,
	[Parameter(mandatory=$true)] $outputfile,
	[switch] $alwaystrust,
	[switch] $sign
)

process {
	$gpgcommand = "gpg --encrypt "
	if ($sign)
	{
		$gpgcommand = $gpgcommand + "--sign "
	}
	
	$gpgcommand = $gpgcommand + "--batch "
	
	foreach ($rec in $recipient)
	{
		$gpgcommand = $gpgcommand + "--recipient '$rec' "
	}
	
	if ($alwaystrust)
	{
		$gpgcommand = $gpgcommand + "--always-trust "
	}
	
	$gpgcommand = $gpgcommand + "--output $outputfile $sourcefile"
	
	Write-Verbose $gpgcommand
	
	Invoke-Expression $gpgcommand
	if ($LASTEXITCODE -ne 0)
	{
		throw "GPG Command failed. Exit Code: $LASTEXITCODE. Command run $gpgcommand"
	}
}

}
