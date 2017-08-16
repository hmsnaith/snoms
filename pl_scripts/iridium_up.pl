#!/usr/bin/perl
# 
# take file arrived via NOCS iridium process and discriminate to project
# remove clear data, decompress and then handle
#  autoflux: files start 20IRD  data to be written to MySQL

use File::stat;
use Time::Local;
use Time::localtime;


while(<STDIN>)
{
($project_name,$file_dir,$file_id,$last_file)=split / /,$_,3;
opendir(DIRHANDLE, $file_dir) or die "Couldn't open $file_dir : $!";
	while ( defined($filename = readdir(DIRHANDLE) ) ) 
		{
		$inode = stat("$file_dir/$filename");
		$mtime = $inode->mtime;
		if ($mtime > $last_file)
			{
			open (FILE, "< $file_dir/$filename");
			$in_string0=<FILE>;
			$startoffile=substr($in_string0,0,5);
			if ($startoffile != $file_id) {exit;}
			$in_string=substr($in_string0,5,length($in_string0));
			@output=`tar -xvvf ??????????????
			
			
			
			}
		}
		






