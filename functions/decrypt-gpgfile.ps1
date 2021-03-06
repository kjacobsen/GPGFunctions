function Decrypt-GPGFile {
<#
.SYNOPSIS
Decrypts a file encrypted with GPG/PGP encyption

.DESCRIPTION
Using gpg.exe, decrypt a GPG/PGP file. This cmdlet by default will use the --batch paramater, can support setting the home directory, as well as any optional "custom" paramaters using the customparams.

.PARAMETER File
[Mandatory][Pipeline] File to be decrypted

.PARAMETER GPGHome
[Optional] GPGHome/Keys

.PARAMETER CustomParams
[Optional] Custom GPG paramaters

.INPUTS
A list of filenames to be decrypted can be specified

.EXAMPLE

.OUTPUTS
GPG Command results, throws errors if exit code is not 0

.NOTES
NAME: decrypt-gpgfile
AUTHOR: Kieran Jacobsen
LASTEDIT: 10/03/2014
KEYWORDS: gpg, pgp, encrypt, decrypt

.LINK 
https://github.com/kjacobsen/GPGFunctions

.LINK 
http://www.gpg4win.org/

#>
[CMDLetBinding()]
param (
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [string] $File,
	[String] $GPGHome,
	[String] $CustomParams
)

process {
	#base expression is gpg.exe, add the home and any other paramaters as specified
	$gpgcommand = "gpg.exe "
	
	if ($gpghome) {
	 	$gpgcommand = $gpgcommand + "--home $gpghome "
	}
	
	if ($CustomParams) {
		$gpgcommand = $gpgcommand + $CustomParams + " "
	}
	
	#specify --batch and the filename
	$gpgcommand = $gpgcommand + "--batch '$file' 2>&1"
	
	Write-Verbose $gpgcommand
	
	#run the expression and check for any errors, throw them if they occur.
	Invoke-Expression $gpgcommand
	if ($LASTEXITCODE -ne 0) {
		throw "GPG Command failed. Exit Code: $LASTEXITCODE. Command run $gpgcommand"
	}
}

}
