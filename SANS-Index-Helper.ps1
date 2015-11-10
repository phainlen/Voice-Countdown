#SANS Course Index Builder
cls
$Course = Read-Host -Prompt 'Input Course Name (ex. FOR408)'
$CurrentPath = Get-Location
$IndexFilePath = $CurrentPath.ToString()+"\"+$Course+"_Index.txt"
$Date   = Get-Date
$PageNumber = "1"
$Delimeter = ";"  #Do NOT use , otherwise reversed entries will be incorrect
$BookNumber = 1 #Set initial book number to 1

if (Test-Path -Path $IndexFilePath)
{
	#File Exists - Don't recreate it
}
else
{
	Out-File $IndexFilePath
	AC -Path $IndexFilePath -Value "Topic"$Delimeter"Book"$Delimeter"Page"$Delimeter"Description`r"
}

While (($PageNumber -ne "q") -or ($PageNumber -ne "Q"))
{
	cls
	Write-Host "##############################################################"
	Write-Host ""
	Write-Host "  Course: $Course"
	Write-Host "  Date: $Date"
	Write-Host ""
	Write-Host "  -------------------------------------------------------"
	Write-Host "  Type one of these commands into 'Page Number' field"
	Write-Host "    B - Set Book Number (Current Book Number = $BookNumber)"
	Write-Host "    Q - Quit"
	Write-Host "    H - Help"
	Write-Host ""
	Write-Host "  Index File: $IndexFilePath"
	Write-Host "##############################################################"
	$Reverse       = ""
	$Separate      = ""
	$KeywordInput1 = ""
	$KeywordInput2 = ""
	$Description   = ""
	
	$PageNumber    = Read-Host -Prompt "Page Number"
	$PageNumber    = $PageNumber.ToLower()
	if (($PageNumber -ne "b") -and ($PageNumber -ne "q") -and ($PageNumber -ne "h"))
	{
		
		$KeywordInput1 = Read-Host -Prompt 'Key Word 1'
		$KeywordInput2 = Read-Host -Prompt 'Key Word 2'
		$Description = Read-Host -Prompt 'Description'
		if ($KeywordInput2 -ne "")
		{
			$Reverse   = Read-Host -Prompt 'Write additional reversed index entry [default = y]? (y/n)'
			$Separate  = Read-Host -Prompt 'Write additional separated index entries [default = n]? (y/n)'
		}

		$Write = Read-Host "Write the line? (enter or n)"
		if (($Write -ne "n") -and (($KeywordInput1 -ne "") -or ($KeywordInput2 -ne "")))
		{
			#Write the Two Keywords on 1 line
			if (($KeywordInput1 -ne "") -and ($KeywordInput2 -ne ""))
			{
				AC -Path $IndexFilePath -Value $KeywordInput1" "$KeywordInput2$Delimeter$BookNumber$Delimeter$PageNumber$Delimeter$Description"`r"
				#Write the two keywords reversed separated by a comma
				if (($Reverse -eq "") -or ($Reverse -eq "y"))
				{
					AC -Path $IndexFilePath -Value $KeywordInput2", "$KeywordInput1$Delimeter$BookNumber$Delimeter$PageNumber$Delimeter$Description"`r"
				}
			}
			else #Write keyword 1 on the line
			{
				AC -Path $IndexFilePath -Value $KeywordInput1$Delimeter$BookNumber$Delimeter$PageNumber$Delimeter$Description"`r"
			}
			#Write the two keywords on separate lines
			if (($Separate -ne "") -and ($Separate -ne "n"))
			{
				AC -Path $IndexFilePath -Value $KeywordInput1$Delimeter$BookNumber$Delimeter$PageNumber$Delimeter$Description"`r"
				AC -Path $IndexFilePath -Value $KeywordInput2$Delimeter$BookNumber$Delimeter$PageNumber$Delimeter$Description"`r"
			}
		}
	}
	elseif ($PageNumber -eq "b")
	{
		$BookNumber = ""
		While ($BookNumber -eq "")
		{
			$BookNumber = Read-Host -Prompt 'Book Number '
		}
	}
	elseif ($PageNumber -eq "q")
	{
		Write-Host "Quitting..."
		#Get rid of blank lines
		(gc $IndexFilePath) | ? {$_.trim() -ne "" } | set-content $IndexFilePath
	}
	elseif ($PageNumber -eq "h")
	{
		cls
		Write-Host "Instructions:"
		Write-Host ""
		Write-Host "  1. You will be prompted for up to TWO KEY WORDS or phrases per entry"
		Write-Host "  2. A REVERSED entry is your key words reversed with a comma separating"
		Write-Host "        ex. Key Word 1 = SANS"
		Write-Host "            Key Word 2 = Forensics"
		Write-Host "          - One line entry will be written with 'SANS Forensics'"
		Write-Host "          - A second line entry will be written with 'Forensics, SANS'"
		Write-Host "  3. A SEPARATED index entry is if you would like your key words separated"
		Write-Host "     on two separate entries."
		Read-Host -Prompt 'Press Enter'
	}
}

