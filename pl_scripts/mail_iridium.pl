#!/nerc/packages/perl/bin/perl 

# perl program to read a directory of filenames and create an email for each 


use File::stat;
use Time::Local;
use Time::localtime;
use Net::FTP;


$transmitter="buoy5";    # amended 31/3/2006
#$list_dir="/data/oed/seadata1/rapid";
$file_dir0="/data/oed/seadata1/rapid/ascdata/".$transmitter."/";
$mailprog='/usr/lib/sendmail';
$from_address="Iridium_System\@noc.soton.ac.uk";
#$to_address="mred\@noc.soton.ac.uk,joc\@noc.soton.ac.uk,jjmh\@noc.soton.ac.uk";
#$to_address="joc\@noc.soton.ac.uk,scu\@sea.noc.soton.ac.uk";
#$to_address="joc\@noc.soton.ac.uk,mred\@noc.soton.ac.uk,scu\@sea.noc.soton.ac.uk";
$to_address="joc\@noc.soton.ac.uk,mred\@noc.soton.ac.uk";
print "$to_address\n";


open (DATE, "< /noc/users/mred/iridium/last_access.dat");
$last_run=<DATE>;
$loop_time=$last_run;
close(DATE);

$tm=localtime($last_run);
print "Last Run $last_run ----";
printf("%04d-%02d-%02d %02d:%02d:%02d \n", $tm->year+1900, $tm->mon+1, $tm->mday,
$tm->hour, $tm->min, $tm->sec);
$ddd=sprintf("%03u",$tm->yday+1);
$yyyy=$tm->year+1900;

$now = localtime();
$now2 = timelocal($now->sec,$now->min,$now->hour,$now->mday,$now->mon,$now->year,);
$nowyyyy=$now->year+1900;
$nowddd=sprintf("%03u",$now->yday+1);
$no_loops=int( ($now-$tm) / 86400);

while (($yyyy < $nowyyyy) or (($yyyy == $nowyyyy) &($ddd <= $nowddd )))
{
$file_dir=$file_dir0.$yyyy."/Day".$ddd;
print("FILE_DIR $file_dir \n");
  if (opendir(DIRHANDLE, $file_dir))
   {

while ( defined($filename = readdir(DIRHANDLE) ) ) 
	{
	$inode = stat("$file_dir/$filename");
	$mtime = $inode->mtime;
	if (($mtime > $last_run ) and (substr($filename,0,1) ne "."))
		{
		print "filename $filename \n";
		$tm=localtime($mtime);
		print " $filename  $mtime  ";
		printf("%04d-%02d-%02d %02d:%02d:%02d \n", $tm->year+1900, $tm->mon+1, $tm->mday,
		$tm->hour, $tm->min, $tm->sec);

		open(DATA, "$file_dir/$filename");
		$file_contents="";
		while (<DATA>)
			{$file_contents.=$_;
			}
	
	
	
			

open( MAIL, "|$mailprog $to_address") or die "Can't open sendmail \n";
print MAIL <<"EOF";
Reply-to: $from_address
From: $from_address
To: $to_address
Subject: Iridium_data $filename

$file_contents


EOF
close(MAIL);

#copy to ftp server
# buoy5 PAP 2007 so not to bodc
if ($transmitter == 'buoy5')
	{}
else
	{
	$in_file=$file_dir."/".$filename;
	$to_ftp="/noc/itg/pubread/bodc/rapid/".$transmitter."/".$filename;
	`cp  $in_file $to_ftp`;
	`chmod 755 $to_ftp`;
	}
#unlink("$file_dir/$filename") or die "Cannot delete $filename : $!\n";
		}

	}
closedir(DIRHANDLE);	
  }
  else
  {
  print("     Couldn't open $file_dir : $!\n");
  }
# look at next day
$loop_time=$loop_time + 86400;
$tm=localtime($loop_time);
$ddd=sprintf("%03u",$tm->yday+1);
$yyyy=$tm->year+1900;
print ("LOOP $yyyy  $ddd NOW $nowyyyy $nowddd \n");
}

open (DATE, "> /noc/users/mred/iridium/last_access.dat");
# to pick up next time any received during this run
$now2=$now2-300;
print DATE "$now2";
close(DATE);

	
	
