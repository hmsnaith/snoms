#!/usr/bin/perl 
# GPS_Map.cpp : Defines the entry point for the console application.
# 2 graphs and table of latest data
# mred 28Mar2008 amend for new file name (still needs to be generalised)
# mred reduced number of points cetered on Livorno
# note seems to plot left to right
# joc Cel_concat_2008_300 2008-11-03
# hms Sep 2016 - adapted for MV Shenking latest SNOMS deployment

do "./snoms_setup.pl";

        $gps_infile=$in_dir.$gpsfilename;
	printf("Opening file: %s\r\n", $gps_infile);
        #print "\n".">$in_dir"."$infilename"."\n";
	open GPS,"<$gps_infile" or die "Couldn't open $gps_infile\n";
	open OUTFILE,">$out_dir"."$outfilename" or die "Couldn't open $outfilename\n";

	$counter = 0;
		print OUTFILE "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=$key\"\n";
		print OUTFILE "  type=\"text/javascript\"></script>\n";
		print OUTFILE "<script type=\"text/javascript\">\n";

		print OUTFILE "function load() {\n";
		print OUTFILE "  if (GBrowserIsCompatible()) {\n";
		print OUTFILE "    var map = new GMap2(document.getElementById(\"map\"));\n";
		print OUTFILE "    var map2 = new GMap2(document.getElementById(\"map2\"));\n";

#		print OUTFILE "    map2.addControl(new GLargeMapControl());\n";
#		print OUTFILE "    map2.addControl(new GMapTypeControl());\n";
#		print OUTFILE "    map2.setCenter(new GLatLng(1.244092, 103.649071), 4);\n";  # Singapore
		print OUTFILE "    map2.setCenter(new GLatLng(43.55, -10.316), 4);\n";	# Livorno
#		print OUTFILE "    map.setCenter(new GLatLng(0.0, 360.0), 1);\n";
		print OUTFILE "    map.setCenter(new GLatLng(1.244092, 103.649071), 1);\n";
		print OUTFILE "    map.setMapType(G_HYBRID_MAP);\n";
		print OUTFILE "    map2.setMapType(G_HYBRID_MAP);\n";
		print OUTFILE "    var polyline = new GPolyline([\n";

		$five = 0;
		$twelve = 0;
		print "Created header.  Processing...\r\n";
		while (<GPS>)
		{

			$five++;
			($num1, $num2, $num3, $num4, $num5, $num6)=split/\s+/,$_,6;
			$ground_speed = $num5;
				if ($five == 6)
				{

					if ($ground_speed > 0.0)
					{
						$twelve++;
						if ($twelve == 12)
						{
							if ($first)
							{
								$first = 0;}
							else
								{
								print OUTFILE ",";
							printf OUTFILE "new GLatLng(%s, %s)\n", $num3, $num4;
							$twelve = 0;
							}
						}
						$lng = $num3;
						$lat = $num4;
						for ($i=749;$i>0;$i--)
						{
							$lastmonth[$i][0] = $lastmonth[$i-1][0];
							$lastmonth[$i][1] = $lastmonth[$i-1][1];
						}
						$lastmonth[0][0] = $lng;
						$lastmonth[0][1] = $lat;
						$point_cnt++;
						if ($point_cnt > 749)
							{$point_cnt = 749;}
					}
					$five = 0;
				}
		}

		print OUTFILE "], \"#FF0000\", 5);\n";
  		print OUTFILE "map.addOverlay(polyline);\n";
		print OUTFILE "    var polyline2 = new GPolyline([\n";
		printf OUTFILE "new GLatLng(%f, %f)\n", $lastmonth[$i][0], $lastmonth[$i][1];

		for ($i=1;$i<$point_cnt;$i++)
		{
							if ( ($in_pirate_box < 1)  && ($second_line < 1)  &&  ((($lastmonth[$i][1]>$pirate_box_long_min) && ($lastmonth[$i][1]<$pirate_box_long_max)) &&  (($lastmonth[$i][0]>$pirate_box_lat_min) && ($lastmonth[$i][0]<$pirate_box_lat_max)) ) ) 
	                {$in_pirate_box=1;  # in box
	                 
	                 print OUTFILE "], \"#FF0000\", 5);\n";
									 print OUTFILE "map2.addOverlay(polyline2);\n";
	                }
							if ( ($in_pirate_box > 0) && ($second_line < 1) && ((($lastmonth[$i][1]<$pirate_box_long_min) || ($lastmonth[$i][1]<$pirate_box_long_max)) and (($lastmonth[$i][0]<$pirate_box_lat_min) || ($lastmonth[$i][0]>$pirate_box_lat_max)) ) ) 
	                {  # left box
                   print OUTFILE "    var polyline3 = new GPolyline([\n";
                   $in_pirate_box = 0;
                   $second_line=1;
	                }
							if ($in_pirate_box eq 0) 
							   {
							   print OUTFILE ",";
							   printf OUTFILE "new GLatLng(%s, %s)\n", $lastmonth[$i][0], $lastmonth[$i][1];
							   }

#		printf OUTFILE ",new GLatLng(%f, %f)\n", $lastmonth[$i][0], $lastmonth[$i][1]; 
		}
		
		
		if ($second_line > 0)
		   {		print OUTFILE "], \"#FF0000\", 5);\n";
						print OUTFILE "map2.addOverlay(polyline3);\n";
		   }
		 else
		 	 {		print OUTFILE "], \"#FF0000\", 5);\n";
						print OUTFILE "map2.addOverlay(polyline2);\n";
		   }

unless ((($lastmonth[0][1]>$pirate_box_long_min) && ($lastmonth[0][1]<$pirate_box_long_max)) &&  (($lastmonth[0][0]>$pirate_box_lat_min) && ($lastmonth[0][0]<$pirate_box_lat_max)) ) 
		{printf OUTFILE "var point = new GLatLng(%f, %f);\n", $lastmonth[0][0], $lastmonth[0][1];
		print OUTFILE "map.addOverlay(new GMarker(point));\n";
		print OUTFILE "map2.addOverlay(new GMarker(point));\n";
		}
#		print OUTFILE "var point = new GLatLng(1.244092, 103.649071);\n"; # Singapore
#		print OUTFILE "map.addOverlay(new GMarker(point));\n";
#		print OUTFILE "map2.addOverlay(new GMarker(point));\n";
#		print OUTFILE "var point = new GLatLng(-6.104342, 106.890900);\n"; # Jakarta
#		print OUTFILE "map.addOverlay(new GMarker(point));\n";
#		print OUTFILE "map.addOverlay(new GMarker(point));\n";
		printf OUTFILE "map2.panTo(new GLatLng(%f, %f));\n", $lastmonth[0][0], $lastmonth[0][1];
		print OUTFILE "      }\n";
		print OUTFILE "    }\n";
		print OUTFILE "    </script>\n";
		print OUTFILE "</head>\n";
        print OUTFILE '  <body onload="load()" onunload="GUnload()">';
        print OUTFILE "    <center><div id=\"map\" style=\"width: 600px; height: 400px\"></div>\n";
		print OUTFILE " <br> <br><div id=\"map2\" style=\"width: 600px; height: 400px\"></div>\n";
		print OUTFILE "<br>Updated at ";
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
		#printf("Time is %2d:%2d:%2d\n", $hrs, $mins, $dsecs);
		printf("Time is %2d:%2d:%2d\n", $hour, $min, $dsecs);
		printf OUTFILE "%02d:%02dUTC On %02d %s %4d (Day %d)<br>\n", $hour, $min, $day, $mnt[$mon-1], $year, $j_day_i;
	
	

	close(GPS);




       chmod 0744, $out_dir.$outfilename;

	printf("Done.\n");
	
	
