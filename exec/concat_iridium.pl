#!/nerc/packages/perl/bin/perl 

# perl program to read a directory of filenames and concatenate on extension
# new file each month


use File::stat;
use Time::Local;



$transmitter="Celebes";    # amended 19-Jun-2007
#$file_dir0="/data/oed/seadata1/rapid/ascdata/".$transmitter."/"; #20071003
$file_dir0="/noc/nmf/usl/REMOTETEL/ascdata/".$transmitter."/";
$file_dir_out="/noc/users/mred/celebes/data/";
$from_address="Iridium_System\@noc.soton.ac.uk";
#$to_address="joc\@noc.soton.ac.uk,mred\@noc.soton.ac.uk,scu\@sea.noc.soton.ac.uk";
#$to_address="joc\@noc.soton.ac.uk,mred\@noc.soton.ac.uk";
#print "$to_address\n";


open (DATE, "< /noc/users/mred/celebes/last_access.dat");
$last_run=<DATE>;
$loop_time=$last_run;
close(DATE);

@tm=gmtime($last_run);
print "Last Run $last_run ----";
printf("%04d-%02d-%02d %02d:%02d:%02d \n", @tm[5]+1900, @tm[4]+1, @tm[3], @tm[2], @tm[1], @tm[0] );
$ddd=sprintf("%03u",@tm[7]+1);
$yyyy=@tm[5]+1900;

@now=gmtime(time);
$nowmon = @now[4] + 1;
print "MONTH  $nowmon $now\n";



$nowunix = time();
@now = gmtime();
$nowyyyy=@now[5]+1900;
$nowddd=sprintf("%03u",@now[7]+1);
$no_loops=int( ($nowunix-$last_run) / 86400);

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
#		print "filename $filename \n";

#		@tm=time($mtime);
#		print " PRINT0 $filename  $mtime  ";
#		printf("%04d-%02d-%02d %02d:%02d:%02d \n", @tm[5]+1900,@tm[4]+1,@tm[3],@tm[2],@tm[1],@tm[0]);

		open(DATA, "$file_dir/$filename");
		$extension=substr($filename,-3);
		$file_contents="";
		<DATA>;
		if ( (substr($_,0,1)>=0) & (substr($_,0,1)<=9) )
			{$file_contents.=$_;}
		while (<DATA>)
			{
			$file_contents.=$_;
			chop($record=$_);
			
			}
		close(DATA);				
#add to end of file
	#	$a=$filedir0."concat/".$extension."_data_$nowmon";
		$a=$file_dir_out.$extension."_data_$nowmon";	
	#	print "FILENAME $filename0  $filename $iridname,$ext $extension \n";
		open(DATASAVE,     ">>$a.dat");
		print DATASAVE  "$file_contents";
		close(DATASAVE);	
		$extension="";
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
@tm=gmtime($loop_time);
$ddd=sprintf("%03u",@tm[7]+1);
$yyyy=@tm[5]+1900;
print ("LOOP $yyyy  $ddd NOW $nowyyyy $nowddd \n");
}

open (DATE, "> /noc/users/mred/celebes/last_access.dat");
# to pick up next time any received during this run
$nowunix=$nowunix-300;
print DATE "$nowunix";
close(DATE);

	
	
