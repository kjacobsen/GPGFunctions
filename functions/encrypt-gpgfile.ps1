function encrypt-gpgfile {
<#
.SYNOPSIS
Encrypts a file using GPG

.DESCRIPTION
Encrypt-GpgFile will encrypt a file using the GPG/PGP protocol. The resulting output file will only be readible by the specified recipients.

Recipients are specified as they would be in GPG/PGP by specifying their keyname/email address. Additional recipiences can be specified by passing an 
array @("recpipient1", "recpient2") to the cmdlet.

Source File and output file must be specified. Options to always trust the public key and to sign the resulting encrypted file.

.PARAMETER Recipient
[mandatory] A single recipient or array of recipients.

.PARAMETER SourceFile
[mandatory][pipeline] Source file to be encrypted

.PARAMETER OutputFile
[Optional] Output encrypted file, if not specified, default to <name>.gpg

.PARAMETER AlwaysTrust
[Optional][SWITCH] always trust recipients public key

.PARAMETER Sign
[Optional][SWITCH] sign the resulting encrypting file with out private key

.PARAMETER gpghome
[Optional] Location of GPG home directory/key files

.PARAMETER customeparams
[Optional] addisional GPG options

.INPUTS
A list of files to be encrypted can be sent into the command via the pipeline

.OUTPUTS
GPG Command results, throws errors if exit code is not 0

.EXAMPLE

.EXAMPLE

.NOTES
NAME: encrypt-gpgfile
AUTHOR: Kieran Jacobsen
LASTEDIT: 2014 03 10
KEYWORDS: pgp, gpg, encryption, decryption, encrypt, decrypt

.LINK 
https://github.com/kjacobsen/GPGFunctions

.LINK 
http://www.gpg4win.org/

#>
[CMDLetBinding()]
param (
	[Parameter(mandatory=$true)] [string[]] $recipient,
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [String] $sourcefile,
	[String] $outputfile,
	[switch] $alwaystrust,
	[switch] $sign, 
	[String] $gpghome,
	[String] $customparams
)

process {
	#base expression is gpg with encyption
	$gpgcommand = "gpg.exe --encrypt "
	
	#optional sign parameter
	if ($sign) {
		$gpgcommand = $gpgcommand + "--sign "
	}
	
	#add the batch option
	$gpgcommand = $gpgcommand + "--batch "
	
	#add each recipient as required
	foreach ($rec in $recipient) {
		$gpgcommand = $gpgcommand + "--recipient '$rec' "
	}
	
	#Always trust the recipient key?
	if ($alwaystrust) {
		$gpgcommand = $gpgcommand + "--always-trust "
	}
	
	#gpg home
	if ($gpghome) {
	 	$gpgcommand = $gpgcommand + "--home $gpghome "
	}
	
	#any other custom paramters
	if ($customparams) {
		$gpgcommand = $gpgcommand + $customparams + " "
	}
	
	#if oputput file isn't specified, make it .gpg
	if ($outputfile -eq $null) {
		$outputfile = $sourcefile + ".gpg"
	}
	
	#finally, add the output file and then source file name
	$gpgcommand = $gpgcommand + "--output '$outputfile' '$sourcefile'  2>&1"
	
	Write-Verbose $gpgcommand
	
	Invoke-Expression $gpgcommand
	if ($LASTEXITCODE -ne 0) {
		throw "GPG Command failed. Exit Code: $LASTEXITCODE. Command run $gpgcommand"
	}
}

}
