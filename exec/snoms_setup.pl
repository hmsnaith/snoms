#!/usr/bin/perl
# Setup basic variables for SNOMS processing used by all perl scripts
use Time::Local;

$in_pirate_box=0;
$pirate_box_long_min=41.5;
$pirate_box_long_max=55;
$pirate_box_lat_min=11;
$pirate_box_lat_max=16;
$second_line=0;


@daytab = (
        [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]);

@mnt = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

# test web
#$key="ABQIAAAA9XASsONKXxsr7K9e4E9eHRTVV49xmeqNOoV78Md-IGEPFprYghRPfNF3hl5X2Ym8ooH1uCgaycKuSw";
# live snoms
$key="ABQIAAAAoug3Lo_FfBFCqfRiO8km7BRYAxTYuf_yJ3Df3n4xJbPs4_zntxSNBoiKvxMu8JvEd0Z0Ma11jqoiRw";

$in_dir="/noc/ote/remotetel/ascdata/SNOMS/concat/";
#circumnav_name.txt doesn't exist for Shenking - so ignore reading this...
#open INCIRC,"<$in_dir"."circumnav_name.txt" or die "Couldn't open $infilename\n";

#chomp($a=<INCIRC>);
#print "aaaaa $a\n";
#($a1, $a2,$circ_year, $circ_day)=split/_/,$a,4;
#close(INCIRC);
# Instead - set date parameters manually
$circ_year="2016";
$circ_month="Aug";
$circ_day="26";

$in_dir.="all_SNOMS_".$circ_day.$circ_month.$circ_year;
print "$in_dir \n";

#$out_dir="/data/ncs/www/nocsweb/snoms/";
$out_dir="/noc/users/bodcnocs/nocsweb/snoms/";

 $gpsfilename = ".gp2";
 $ptufilename = ".ptu";
 $vcofilename = ".vco";
 $vcafilename = ".vca";
 $hulfilename = ".hul";
 $hl1filename = ".hl1";
 $hl2filename = ".hl2";
 $fl1filename = ".fl1";
 $at1filename = ".at1";
 $at2filename = ".at2";
 $at3filename = ".at3";
 $at4filename = ".at4";
 $ac1filename = ".ac1";
 $ac2filename = ".ac2";
 $ac3filename = ".ac3";
 $ac4filename = ".ac4";
 $ao1filename = ".ao1";
 $ao2filename = ".ao2";
 $ao3filename = ".ao3";
 $ao4filename = ".ao4";
 $co2filename = ".co2";
 $coafilename = ".coa";
 $cobfilename = ".cob";
 $gtdfilename = ".gtd";

 $outfilename = "position.inc";

for ($i=0;$i<750;$i++)
  {
	$lastmonth[$i][0] = 0.0;
	$lastmonth[$i][1] = 0.0;
  }



