param ($option)

$hostname = $args[0]
$user = $args[1]
$password = $args[2]

$nopasswd = ConvertTo-SecureString "$password" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $user, $nopasswd

Import-Module "C:\Program Files (x86)\WindowsPowerShell\Modules\Posh-SSH\3.0.0\Posh-SSH"

# Establish the SFTP connection
$SFTPSession = New-SFTPSession -ComputerName $hostname -Credential $Credential

		

switch ( $option )
{
	'UPLOAD' {
		$remotedir = $args[3]
		$file = $args[4]
		$directory = $args[5]
		if($directory -eq "T"){
			#Set-SFTPDirectory -sessionID $SFTPSession.SessionID -Path $file -RemoteLocation $remotedir
			Set-SFTPItem -sessionID $SFTPSession.SessionID -Destination $remotedir -Path $file/* -Force
		}else{
			Set-SFTPItem -sessionID $SFTPSession.SessionID -Destination $remotedir -Path $file -Force
			#Set-SFTPFile -SessionId ($ThisSession).SessionId -LocalFile $FilePath -RemotePath $SftpPath

		}
		
		write-host "File Transfer sucessfully" 
	}
	
	'LIST' {
		$remotedir = $args[3]
		#$LocalPath = "D:\Workplace\workato\powershell"
		# lists directory files into variable
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
		
		write-host "Files downloaded: "(Get-ChildItem $localdir | Measure-Object).Count
		write-host "Files downloaded sucessfully" 
	}
	
	'DELETE' {
		$remotedir = $args[3]
		$file = $args[4]
		
		
		write-host "File deleted sucessfully" 
	}
	
	'RENAME' {
		$remotedir = $args[3]
		$file = $args[4]
		$fileNewName = $args[5]
		
		write-host "File rename sucessfully" 
	}
}

Remove-SFTPSession -SessionId $SFTPSession.SessionID
