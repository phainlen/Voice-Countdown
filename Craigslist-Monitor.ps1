$search_item = "gold"  #Search Item
$min_price = "75"      #Minimum Price
$max_price = "200"     #Maxmimum Price
$items = $null
$text = $null
$today = Get-Date -Format d

#Query the Craiglist RSS feed and return the XML
[xml]$result_cl = invoke-webrequest -uri "http://yourcity.craigslist.org/search/sss?format=rss&amp;sort=rel&amp;query=$search_item&amp;min_price=$min_price&amp;max_price=$max_price" -Method Get -UserAgent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36"

#Put all of the results into a basket
$items = $result_cl.RDF.Item

#Grab each item in the basket and gather details about that item
foreach ($item in $items)
{
        #Put the item's date into an acceptable date format
 $date = Get-Date($item.date)

        #if the items date is Greater or equal to the current date/time
 if ($date -ge $today)
 {
  $text += "Title : "+$item.title.'#cdata-section'+"`n"
  $text += "Date  : "+$date+"`n"
  $text += "Descr : "+$item.description.'#cdata-section'+"`n"
  $text += "Link  : "+$item.link+"`n"
  $text += "=====================================================`n"
  
  Write-Host $text
  
 }
}

if ($text -ne $null)
{
    Send-MailMessage -From "user@mail.me" -To "yourself@mail.com" -Subject "New Craigslist Alert for: $search_item" -Body $text -SmtpServer "yoursmtpserver.hostingprovider.com"
}
