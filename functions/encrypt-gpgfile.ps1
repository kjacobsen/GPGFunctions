function encrypt-gpgfile
{
<#
.SYNOPSIS
Encrypts a file using GPG

.DESCRIPTION
Encrypt-GpgFile will encrypt a file using the GPG/PGP protocol. The resulting output file will only be readible by the specified recipients.

Recipients are specified as they would be in GPG/PGP by specifying their keyname/email address. Additional recipiences can be specified by passing an 
array @("recpipient1", "recpient2") to the cmdlet.

Source File and output file must be specified. Options to always trust the public key and to sign the resulting encrypted file.

.PARAMETER Recipient
A single recipient or array of recipients.

.PARAMETER SourceFile
Source file to be encrypted

.PARAMETER OutputFile
Output encrypted file

.PARAMETER AlwaysTrust
[SWITCH] always trust recipients public key

.PARAMETER Sign
[SWITCH] sign the resulting encrypting file with out private key

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
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [String] $sourcefile,
	[String] $outputfile,
	[switch] $alwaystrust,
	[switch] $sign, 
	[String] $gpghome
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
	
	if ($gpghome)
	{
	 	$gpgcommand = $gpgcommand + "--home $gpghome "
	}
	
	if ($outputfile -eq $null)
	{
		$outputfile = $sourcefile + ".gpg"
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
