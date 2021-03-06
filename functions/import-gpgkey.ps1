function import-gpgkey {
<#
.SYNOPSIS
Imports a specified key into the GPG keyring

.DESCRIPTION
Calls the GPG.EXE --import command to import the specified key into the keyring (default or specified).

.PARAMETER File
[mandatory][pipeline] path to file containing to be imported

.PARAMETER GPGHome
Location for GPG home directory/keyring

.PARAMETER CustomParams
Any custom gpg.exe custom parameters you which to specify

.INPUTS
Will accept filenames to be imported from the pipeline

.OUTPUTS
GPG Command results, throws errors if exit code is not 0

.EXAMPLE

.EXAMPLE

.NOTES
NAME: import-gpgkey
AUTHOR: Kieran Jacobsen
LASTEDIT: 2014 03 10
KEYWORDS: gpg, pgp, asc, key, import

.LINK 
https://github.com/kjacobsen/GPGFunctions

.LINK 
http://www.gpg4win.org/

#>
[CMDLetBinding()]
param (
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [string] $file, 
	[String] $gpghome,
	[String] $customparams

)

process {
	$gpgcommand = "gpg.exe "
	
	if ($gpghome) {
	 	$gpgcommand = $gpgcommand + "--home $gpghome "
	}
	
	if ($customparams) {
		$gpgcommand = $gpgcommand + $customparams + " "
	}
	
	$gpgcommand = $gpgcommand + "--import $file  2>&1"
	
	Write-Verbose $gpgcommand
	
	Invoke-Expression $gpgcommand
	if ($LASTEXITCODE -ne 0) {
		throw "GPG Command failed. Exit Code: $LASTEXITCODE. Command run $gpgcommand"
	}
}

}
