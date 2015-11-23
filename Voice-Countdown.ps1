Param(
    [Int32]$Seconds = 320
)

Add-Type -AssemblyName PresentationCore 
$global:MediaPlayer = New-Object System.Windows.Media.MediaPlayer
$volumeobj = new-object -com wscript.shell 

$global:MediaPlayer.Volume = 1

Function Play-MP3([string] $sound)
{
	
    do {
        $global:MediaPlayer.Open($sound)
        $_songDuration = $global:MediaPlayer.NaturalDuration.TimeSpan.TotalMilliseconds
    }
    until ($_songDuration)

    $global:MediaPlayer.Play()
    Start-Sleep -Milliseconds $_songDuration
    $global:MediaPlayer.Stop()

}

Function Start-Countdown 
{   

    ForEach ($Count in (1..$Seconds))
    {   
		$SecondsLeft = $Seconds - $Count
		if ($SecondsLeft -eq 0){break}
		switch ($SecondsLeft) 
    	{
            300 {Play-MP3 -sound "C:\Voice-CountDown\5_minutes_remaining.mp3"} #5 minutes remaining
            240 {Play-MP3 -sound "C:\Voice-CountDown\4_minutes_remaining.mp3"} #4 minutes remaining
            180 {Play-MP3 -sound "C:\Voice-CountDown\3_minutes_remaining.mp3"} #3 minutes remaining
            120 {Play-MP3 -sound "C:\Voice-CountDown\2_minutes_remaining.mp3"} #2 minutes remaining
	        60 {Play-MP3 -sound "C:\Voice-CountDown\1_minute_remaining.mp3"} #1 minute remaining
	        30 {Play-MP3 -sound "C:\Voice-CountDown\30_seconds_remaining.mp3"} #30 seconds remaining
	        10 {Play-MP3 -sound "C:\Voice-CountDown\10_Second_Countdown.mp3"} #10 seconds remaining
    	}

        Start-Sleep -Seconds 1
    }
	
}

Start-Countdown -Seconds $Seconds

$global:MediaPlayer.Close()

#Mute the Sound
$volumeobj.SendKeys([char]173)
