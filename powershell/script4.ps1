param ($option)

$hostname = $args[0]
$user = $args[1]
$keyfile = $args[2]

$nopasswd = new-object System.Security.SecureString
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $user, $nopasswd

Import-Module "C:\Program Files (x86)\WindowsPowerShell\Modules\Posh-SSH\3.0.0\Posh-SSH"

# Establish the SFTP connection
$SFTPSession = New-SFTPSession -ComputerName $hostname -Credential $Credential -Keyfile $keyfile

		

switch ( $option )
{
	'UPLOAD' {
		$remotedir = $args[3]
		$file = $args[4]
		$directory = $args[5]
		if($directory -eq "T"){
			Set-SFTPItem -sessionID $SFTPSession.SessionID -Destination $remotedir -Path $file/* -Force
		}else{
			Set-SFTPItem -sessionID $SFTPSession.SessionID -Destination $remotedir -Path $file -Force
		}
		write-host "File Transfer sucessfully" 
	}
	
	'LIST' {
		$remotedir = $args[3]
		$FilePath = Get-SFTPChildItem -sessionID $SFTPSession.SessionID -path $remotedir -Verbose
		ForEach ($f in $FilePath)
		{
		 Write-Host $f.name
		}
	}
	
	'DOWNLOAD' {
		$remotedir = $args[3]
		$localdir = $args[4]
		$searchcontent = $args[5]
		New-Item -ItemType Directory -Force -Path $localdir
		if($searchcontent -eq ""){
			Get-SFTPItem -sessionID $SFTPSession.SessionID -Destination $localdir -Path $remotedir
		}
		$FilePath = Get-SFTPChildItem -sessionID $SFTPSession.SessionID -path $remotedir -Verbose
		ForEach ($f in $FilePath){
			if($f.name -Match "$searchcontent"){
				$file = $f.name
				Get-SFTPItem -sessionID $SFTPSession.SessionID -Destination $localdir -Path $remotedir/$file
			}
		}
		
		write-host "Files downloaded: "(Get-ChildItem $localdir | Measure-Object).Count
		write-host "Files downloaded sucessfully" 
	}
	
	'DELETE' {
		$remotedir = $args[3]
		$file = $args[4]
		Remove-SFTPItem -sessionID $SFTPSession.SessionID -Path $remotedir/$file
		write-host "File deleted sucessfully" 
	}
	
	'RENAME' {
		$remotedir = $args[3]
		$file = $args[4]
		$fileNewName = $args[5]
		
		write-host "File rename sucessfully" 
	}
}

$endSession = Remove-SFTPSession -SessionId $SFTPSession.SessionID
