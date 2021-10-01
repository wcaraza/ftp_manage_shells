param ($option)


switch ( $option )
{
	'ZIP' {
		$directory = $args[0]
		Compress-Archive -Path $directory -DestinationPath $directory
		Move-Item -Path "$directory.zip" -Destination $directory -Force
		write-host "Directory compressed sucessfully" 
	}
	'UNZIP' {
		$directory = $args[0]
		$filePath = $args[1]
		Expand-Archive -LiteralPath $filePath -DestinationPath $directory
		write-host "File uncompressed sucessfully" 
	}
	'REMOVETOPLINE' {
		$filePath = $args[0]
		(Get-Content $filePath | Select-Object -Skip 1) | Set-Content $filePath
		write-host "Remove top line sucessfully" 
	}
	'ENCODEANSITOUTF8' {
		$directory = $args[0]
		Get-ChildItem "$directory\*.txt" | ForEach-Object { (Get-Content $_) | Out-File -Encoding ASCII $_ }
		write-host "Encode from ANSI to UTF8 done sucessfully" 
	}
	
}
