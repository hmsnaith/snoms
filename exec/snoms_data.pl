#!/nerc/packages/perl/bin/perl 
# table of latest data from GPS_Map1.pl
# joc Cel_concat_2008_300 2008-11-03

use Time::Local;


 @daytab = (
        [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]);

@mnt = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

#$in_dir="/data/oed/seadata1/rapid/ascdata/Celebes/concat/"; #20071003
$in_dir="/noc/ote/autonomous/REMOTETEL/ascdata/Celebes/concat/Cel_concat_2009_080"; 
$out_dir="/data/ncs/www/snoms/content/";
	 $outfilename = "data.html";
	open OUTFILE,">$out_dir"."$outfilename" or die "Couldn't open $outfilename\n";

#	 $gpsfilename = "all_2007.gp2";
	 $ptufilename = ".ptu";
	 $vcofilename = ".vco";
	 $hulfilename = ".hul";
	 $fl1filename = ".fl1";
	 $at1filename = ".at1";
	 $at2filename = ".at2";
	 $at3filename = ".at3";
	 $ac1filename = ".ac1";
	 $ac2filename = ".ac2";
	 $ac3filename = ".ac3";
	 $ao1filename = ".ao1";
	 $ao2filename = ".ao2";
	 $ao3filename = ".ao3";
	 $co2filename = ".co2";
	 $gtdfilename = ".gtd";

	 
		print OUTFILE "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n";
		print OUTFILE "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n";
		print OUTFILE "<html xmlns=\"http://www.w3.org/1999/xhtml\"\n";
		print OUTFILE "  xmlns:v=\"urn:schemas-microsoft-com:vml\">\n";
		print OUTFILE "<head>\n";
		print OUTFILE "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"/>\n";
		print OUTFILE "<title>Celebes latest data</title>\n";
		print OUTFILE "</head>\n";
        print OUTFILE '  <body onload="load()" onunload="GUnload()">';
        print OUTFILE "    <center>\n";
	



	print OUTFILE " <br><b>Bridge top sensors</b><br>\n";

	print OUTFILE "<br>Updated at ";

		

	$infilename=$ptufilename;
	open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
	while (<IN>){
			($num1, $num2, $num3, $num4, $num5, $num6)=split/\s+/,$_,6;
			}
	close(IN);

		$j_day_d =$num2;
		$j_day_i = int($j_day_d);

		$tfrac = 86400*($j_day_d - $j_day_i);
		$hrs = int($tfrac/3600.0);
		$tfrac = 3600.0*$hrs;
		$mins = int(tfrac/60.0);
		$tfrac = 60.0*$mins;
		$dsecs = int($tfrac);
		$tfrac = $dsecs;
		$hsecs = int($tfrac*100.0);

#                sscanf( $num1,"%d", &year);
 #               sscanf( $num2,"%lf", &j_day_d);
                $j_day_i = int($j_day_d);

                $tfrac = 86400*($j_day_d - $j_day_i);
                $hrs = int($tfrac/3600.0);
                $tfrac = 3600.0*$hrs;
                $mins = int($tfrac/60.0);
                $tfrac = 60.0*$mins;
                $dsecs = int($tfrac);
                $tfrac = $dsecs;
                $hsecs = int($tfrac*100.0);

		$time=timegm(0,0,0,1,0,$num1);
		$time=$time+(($num2-1) *60*60*24);  # yearday goes from 0 to 364/5
		($sec,$min,$hour,$day,$mon,$year,$x1,$x2,$x3)=localtime($time);
		$year=$year+1900;
		$mon=$mon+1;

		printf("Year is %s, day is %s\n", $num1, $num2);
		printf("Year is %d, day is %d\n", $year, $j_day_i);
		printf("Day is %d, month is %d\n", $day, $mon);
		printf("Time is %2d:%2d:%2d\n", hrs, mins, dsecs);
		printf OUTFILE "%02d:%02dUTC On %02d %s %4d (Day %d)<br>\n", $hour, $min, $day, $mnt[$mon-1], $year, $j_day_i;





	printf OUTFILE "Air temperature %s °C<br>\n", $num4;
	printf OUTFILE "Air pressure %s mbar<br>\n", $num3;
	printf OUTFILE "Humidity %s %%<br>\n", $num5;
	
	$infilename=$vcofilename;
	open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
	while (<IN>){
			($num1, $num2, $num3, $num4, $num5)=split/\s+/,$_,5;
}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
	printf OUTFILE "Atmospheric CO2 concentration %s ppm<br>\n", $num3;
		}
		else
		{
			printf OUTFILE "Atmospheric CO2 concentration - no current data<br>\n";		
		}
	
	print OUTFILE " <br><b>Engine room sensors (not active when close to port)</b><br>\n";

	$infilename=$hulfilename;
	open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
	while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Hull temperature %s °C<br>\n", $num3;
		}
		else
		{
			printf OUTFILE "Hull temperature - no current data<br>\n";		
		}

	$infilename=$fl1filename;
	open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
	while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
			printf OUTFILE "Water flow %s litres/min<br>\n", $num3;
		}
		else
		{
			printf OUTFILE "Water flow - no current data<br>\n";		
		}

	if ($num3 == 0.0)
	{
		print OUTFILE "Aanderaa temperature sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa temperature sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa temperature sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa conductivity sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa conductivity sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa conductivity sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa oxygen sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa oxygen sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "Aanderaa oxygen sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus CO2 sensor CO2 concentration <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus CO2 sensor optical cell temperature <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus CO2 sensor humidity <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus CO2 sensor temperature <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus CO2 sensor gas stream pressure <i>OFF-SHALLOW WATER</i><br>\n";
		print OUTFILE "ProOceanus GTD sensor dissolved gas pressure <i>OFF-SHALLOW WATER</i><br>\n";
	}
	else
	{
		$infilename=$at1filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa temperature sensor #1 %s &deg;C<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa temperature sensor #1 - no current data<br>\n";
		}

		$infilename=$at2filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa temperature sensor #2 %s &deg;C<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa temperature sensor #2- no current data<br>\n";
		}

#  removed mrp20090409
#		$infilename=$at3filename;
#		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
#		while (<IN>){
#			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
#	}
#	close(IN);
#		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
#		{
#		printf OUTFILE "Aanderaa temperature sensor #3 %s &deg;C<br>\n", $num3;
#		}
#		else
#		{
#		printf OUTFILE "Aanderaa temperature sensor #3 - no current data<br>\n";
#		}
#
		$infilename=$ac1filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa conductivity sensor #1 %s mS/cm<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa conductivity sensor #1 - no current data<br>\n";
		}

		$infilename=$ac2filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa conductivity sensor #2 %s mS/cm<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa conductivity sensor #2 - no current data<br>\n";
		}

		$infilename=$ac3filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa conductivity sensor #3 %s mS/cm<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa conductivity sensor #3 - no current data<br>\n";
		}

		$infilename=$ao1filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa oxygen sensor #1 %s µM<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa oxygen sensor #1 - no current data<br>\n";
		}

		$infilename=$ao2filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa oxygen sensor #2 %s µM<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa oxygen sensor #2 - no current data<br>\n";
		}

		$infilename=$ao3filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
			($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "Aanderaa oxygen sensor #3 %s µM<br>\n", $num3;
		}
		else
		{
		printf OUTFILE "Aanderaa oxygen sensor #3 - no current data<br>\n";
		}
		$infilename=$co2filename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
				($num1, $num2, $num3, $num4, $num5, $num6, $num7, $num8)=split/\s+/,$_,8;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "ProOceanus CO2 sensor CO2 concentration %s mol/mol<br>\n", $num3;
		printf OUTFILE "ProOceanus CO2 sensor optical cell temperature %s °C<br>\n", $num4;
		printf OUTFILE "ProOceanus CO2 sensor humidity %s</i><br>\n", $num5;
		printf OUTFILE "ProOceanus CO2 sensor temperature %s °C</i><br>\n", $num6;
		printf OUTFILE "ProOceanus CO2 sensor gas stream pressure %s mbar<br>\n", $num7;
		}
		else
		{
		printf OUTFILE "ProOceanus CO2 sensor CO2 concentration - no current data<br>\n";
		printf OUTFILE "ProOceanus CO2 sensor optical cell temperature - no current data<br>\n";
		printf OUTFILE "ProOceanus CO2 sensor humidity - no current data<br>\n";
		printf OUTFILE "ProOceanus CO2 sensor temperature - no current data<br>\n";
		printf OUTFILE "ProOceanus CO2 sensor gas stream pressure - no current data<br>\n";
		}
		
		$infilename=$gtdfilename;
		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";	
		while (<IN>){
				($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
	}
	close(IN);
		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
		{
		printf OUTFILE "ProOceanus GTD sensor dissolved gas pressure %s mbar</i><br>\n", $num3;
		}
		else
		{
		printf OUTFILE "ProOceanus GTD sensor dissolved gas pressure - no current data<br>\n";
		}
	}

	print OUTFILE "  </center></body>\n";
	print OUTFILE "</html>\n";
chmod 0744, $out_dir.$outfilename;

	printf("Done.\n");
	
	
