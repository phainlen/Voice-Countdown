param ([string]$week, [bool]$getSchedule=$false, [string]$Years="2019-2020")
################################################################################################
# _    __           _       __    __         
#| |  / /___ ______(_)___ _/ /_  / /__  _____
#| | / / __ `/ ___/ / __ `/ __ \/ / _ \/ ___/
#| |/ / /_/ / /  / / /_/ / /_/ / /  __(__  ) 
#|___/\__,_/_/  /_/\__,_/_.___/_/\___/____/  
################################################################################################
$Error.Clear()
$Username = "xxxxxx"
$Password = "xxxxxxxxxxxxxxxxxxxx" #For 1.x API
#$Password = "MYSPORTSFEEDS" #For 2.x API
$Season = "$Years-regular"
$API_Token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxx"
$Token_Text = "$($API_Token):$($Password)"
$standingsfile = $PSScriptRoot+"\Week$week-overall_team_standings-nfl-$Season.csv"
$schedulefile = $PSScriptRoot+"\full_game_schedule-nfl-$Season.csv"
################################################################################################
#    ___         __  __               __  _            __  _           
#   /   | __  __/ /_/ /_  ___  ____  / /_(_)________ _/ /_(_)___  ____ 
#  / /| |/ / / / __/ __ \/ _ \/ __ \/ __/ / ___/ __ `/ __/ / __ \/ __ \
# / ___ / /_/ / /_/ / / /  __/ / / / /_/ / /__/ /_/ / /_/ / /_/ / / / /
#/_/  |_\__,_/\__/_/ /_/\___/_/ /_/\__/_/\___/\__,_/\__/_/\____/_/ /_/ 
################################################################################################
$Encoded_Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Token_Text))
$basicAuthValue = "Basic $Encoded_Token"
$ForDate = (Get-Date).ToString("yyyyMMdd")
$headers = New-Object "System.Collections.Generic.Dictionary[[string],[string]]"
$headers.add("Authorization","$($basicAuthValue)")
$headers.add("Accept-Encoding", "gzip")
$headers.add("fordate", $ForDate)
###############################################################################################
#    ____                           __     ______              __    
#   /  _/___ ___  ____  ____  _____/ /_   / ____/__  ___  ____/ /____
#   / // __ `__ \/ __ \/ __ \/ ___/ __/  / /_  / _ \/ _ \/ __  / ___/
# _/ // / / / / / /_/ / /_/ / /  / /_   / __/ /  __/  __/ /_/ (__  ) 
#/___/_/ /_/ /_/ .___/\____/_/   \__/  /_/    \___/\___/\__,_/____/  
#             /_/   
###############################################################################################
Write-Host "Getting standings and stats for the past week"

if ($getSchedule)
{
	Try
	{
    #Get schedule of games if parameter is set
		$Response = Invoke-WebRequest -Method GET -URI "https://api.mysportsfeeds.com/v1.2/pull/nfl/$Season/full_game_schedule.csv" -Headers $Headers -OutFile $schedulefile
		
		Write-Host "Schedule Retrieved."
		Exit(0)
	}
	Catch
	{
		Write-Host "HTTP Request failed: $Error"
	}
}
else
{
	Try
	{
		  #Get team standings file
	    $Response = Invoke-WebRequest -Method GET -URI "https://api.mysportsfeeds.com/v1.2/pull/nfl/$Season/overall_team_standings.csv" -Headers $Headers -OutFile $standingsfile
	}
	Catch
	{
		Write-Host "HTTP Request failed: $Error"
	}
}
