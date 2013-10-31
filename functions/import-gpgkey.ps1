function import-gpgkey
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
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [string] $file

)

process {
	$gpgcommand = "gpg --import $file"
	Write-Verbose $gpgcommand
	Invoke-Expression $gpgcommand
	if ($LASTEXITCODE -ne 0)
	{
		throw "GPG Command failed. Exit Code: $LASTEXITCODE. Command run $gpgcommand"
	}
}

}