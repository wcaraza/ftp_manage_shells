param ($option)

$hostname = $args[0]
$password = $args[1]
$user = $args[2]

switch ( $option )
{
	'UPLOAD' {
		$remotedir = $args[3]
		$file = $args[4]
		$directory = $args[5]
		if($directory -eq "T"){
			$comand = "open $hostname
			user $user $password
			binary  
			cd $remotedir
			lcd $file
			mput *
			"
		}else{
			$comand = "open $hostname
			user $user $password
			binary  
			cd $remotedir
			mput $file
			"
		}
		$comand +
			({ "quit" }) | ftp -i -in
		##($file.split(' ') | %{ "put ""$_""`n" }) | ftp -i -in
		write-host "File Transfer sucessfully" 
	}
	
	'LIST' {
		$remotedir = $args[3]
		$searchcontent = $args[4]
		"open $hostname
		user $user $password
		binary  
		cd $remotedir
		ls *$searchcontent*
		" +
		({ "quit" }) | ftp -i -in
	}
	
	'DOWNLOAD' {
		$remotedir = $args[3]
		$localdir = $args[4]
		$searchcontent = $args[5]
		Remove-Item -Path "$localdir" -Force -Recurse
		New-Item -ItemType Directory -Force -Path $localdir
		"open $hostname
		user $user $password
		binary  
		cd $remotedir
		lcd $localdir
		mget *$searchcontent*
		" +
		({ "quit" }) | ftp -i -in
		write-host "Files downloaded: "(Get-ChildItem $localdir | Measure-Object).Count
		write-host "Files downloaded sucessfully" 
	}
	
	'DELETE' {
		$remotedir = $args[3]
		$file = $args[4]
		"open $hostname
		user $user $password
		binary  
		cd $remotedir
		delete $file
		" +
		({ "quit" }) | ftp -i -in
		
		write-host "File deleted sucessfully" 
	}
	
	'RENAME' {
		$remotedir = $args[3]
		$file = $args[4]
		$fileNewName = $args[5]
		"open $hostname
		user $user $password
		binary  
		cd $remotedir
		rename $file $fileNewName
		" +
		({ "quit" }) | ftp -i -in
		write-host "File rename sucessfully" 
	}
}
