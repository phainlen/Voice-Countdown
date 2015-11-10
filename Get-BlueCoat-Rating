Function Get-BlueCoat-Rating([string] $site)
{
 $postParams = @{url=$site}
 $isbad = 0
#You can choose different useragent strings depending on the type of browser you would like to impersonate
 $result = Invoke-WebRequest -Uri "https://sitereview.bluecoat.com/rest/categorization" -Method POST -Body $postParams -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer) | ConvertFrom-Json
 
 $MaliciousCategories = ("Child Pornography","Malicious Outbound Data/Botnets","Malicious Sources/Malnets","Nudity","Peer-to-Peer (P2P)","Phishing","Uncategorized", `
                            "Piracy/Copyright concerns","Pornography","Potentially Unwanted Software","Proxy Avoidance","Suspicious","Scam/Questionable/Illegal","Spam")
    
 #   Your POST will return the following JSON data
 #url            : http://domain.com/
 #unrated        : False
 #curtrackingid  : 99999
 #locked         : False
 #multiple       : False
 #ratedate       : This page was rated by our WebPulse system
 #categorization : &lt;a href="javascript:showPopupWindow('catdesc.jsp?catnum=9')"&gt;Category 1&lt;/a&gt; and &lt;a href="javascript:showPopupWindow('catdesc.jsp?catnum=9')"&gt;Category 2&lt;/a&gt;
 #linkable       : False

 #Replace the categorization field html with blanks and delimiters
 #The format will be "catnum;rating;catnum;rating..."
 $categorization = $result.categorization -replace "&lt;a href=`"javascript:showPopupWindow\('catdesc\.jsp\?catnum=", "" -replace "'\)`"&gt;", ";" -replace " and ", ";" -replace "&lt;/a&gt;", ""

 #Create an array from the string
 $cat_array = $categorization.Split(";")

 $array_len = $cat_array.Count

 #loop through the array
 for ($i=0; $i -lt $array_len; $i++)
 {
     #We only want the odd numbered array fields
     #so we are checking whether the loop value is even or odd
  if (($i % 2) -eq 1)
  {
   #put all of the categories into an array (if there is more than one category)
   $categories = $categories + $cat_array[$i] + " "
  }
  
  #Based on the malicious categories tracked by BlueCoat (specified by the array above), we want to see if the category set to the current site is noted as malicious.
  foreach ($category in $MaliciousCategories)
  {
   if ($category -eq $cat_array[$i])
   {
    $isbad = 1
   }
  }
 }
 #return the category description and whether or not the site is noted as bad
 return $categories+","+$isbad
}
