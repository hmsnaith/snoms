#!/usr/bin/perl
# table of latest data from GPS_Map1.pl
# joc Cel_concat_2008_300 2008-11-03
# mred 25-Jan-2011  vco file not being created so have removed references to stop erroring
# hms 2 Sep 2016 MV SHenking changes

do "snoms_setup.pl";

$outfilename = "data.inc";
open OUTFILE,">$out_dir"."$outfilename" or die "Couldn't open $outfilename\n";

#		print OUTFILE "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n";
#		print OUTFILE "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n";
#		print OUTFILE "<html xmlns=\"http://www.w3.org/1999/xhtml\"\n";
#		print OUTFILE "  xmlns:v=\"urn:schemas-microsoft-com:vml\">\n";
#		print OUTFILE "<head>\n";
#		print OUTFILE "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"/>\n";
#		print OUTFILE "<title>Celebes latest data</title>\n";
#		print OUTFILE "</head>\n";
#   print OUTFILE '  <body onload="load()" onunload="GUnload()">';
#   print OUTFILE "    <center>\n";

print OUTFILE "Latest data point received in Southampton from each of the SNOMS measuring devices<br />";

print OUTFILE "<br>Updated at ";

#ptu (Vaisala atmospheric temp, press & humidity)

$infilename=$ptufilename;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $in_dir"."$infilename\n";
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

#   sscanf( $num1,"%d", &year);
#   sscanf( $num2,"%lf", &j_day_d);
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
($sec,$min,$hour,$day,$mon,$year,$x1,$x2,$dls)=gmtime($time);
$year=$year+1900;
$mon=$mon+1;

printf("Year is %s, day is %s\n", $num1, $num2);
printf("Year is %d, day is %d\n", $year, $j_day_i);
printf("Day is %d, month is %d\n", $day, $mon);
printf("Time is %2d:%2d:%2d\n", hrs, mins, dsecs);
printf OUTFILE "%02d:%02d UTC On %02d %s %4d (Day %d)<br>\n", $hour, $min, $day, $mnt[$mon-1], $year, $j_day_i;

print OUTFILE " <br><b>Bridge top sensors</b><br>\n";

printf OUTFILE "Air temperature %s &deg;C<br>\n", $num4;
printf OUTFILE "Air pressure %s mbar<br>\n", $num3;
printf OUTFILE "Humidity %s %%<br>\n", $num5;

# VCO (Atmospheric CO2 concentration) - try VCA (Sensor A)
#	$infilename=$vcofilename;
$infilename=$vcafilename;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $in_dir"."$infilename\n";
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

# HUL (Hull temp) 0 don't have! Use HL1 & HL2 instead
#	$infilename=$hulfilename;
$infilename=$hl1filename;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  printf OUTFILE "Hull temperature (sensor 1) %s &deg;C<br>\n", $num3;
}
else
{
  printf OUTFILE "Hull temperature (sensor 1) - no current data<br>\n";
}
$infilename=$hl2filename;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  printf OUTFILE "Hull temperature (sensor 2) %s &deg;C<br>\n", $num3;
}
else
{
  printf OUTFILE "Hull temperature (sensor 2) - no current data<br>\n";
}

# FL1 (Flow Meter)
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
$data_fl1=$num3;

#	if ($num3 == 0.0)
#	{
# mred 27-Jan-2011 removed as reporting this error message when no sensor
#		print OUTFILE "Aanderaa temperature sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa temperature sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa temperature sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa conductivity sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa conductivity sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa conductivity sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa oxygen sensor #1 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa oxygen sensor #2 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "Aanderaa oxygen sensor #3 <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus CO2 sensor CO2 concentration <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus CO2 sensor optical cell temperature <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus CO2 sensor humidity <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus CO2 sensor temperature <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus CO2 sensor gas stream pressure <i>OFF-SHALLOW WATER</i><br>\n";
#		print OUTFILE "ProOceanus GTD sensor dissolved gas pressure <i>OFF-SHALLOW WATER</i><br>\n";
#	}
#	else
#	{

# AC1 - AC4 (Anderaa Conductivity sensors) - only output if valid
$infilename=$ac1filename;
$num1=0;
$num3=0;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $in_dir"."$infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  $pr_ac1=sprintf "Aanderaa conductivity sensor #1 %s mS/cm<br>\n", $num3;
}
else
{
  $pr_ac1=sprintf "Aanderaa conductivity sensor #1 - no current data<br>\n";
}
$data_ac1=$num3;

$infilename=$ac2filename;
$num1=0;
$num3=0;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  $pr_ac2=sprintf "Aanderaa conductivity sensor #2 %s mS/cm<br>\n", $num3;
}
else
{
  $pr_ac2=sprintf "Aanderaa conductivity sensor #2 - no current data<br>\n";
}
$data_ac2=$num3;

$infilename=$ac3filename;
$num1=0;
$num3=0;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
  if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  $pr_ac3=sprintf "Aanderaa conductivity sensor #3 %s mS/cm<br>\n", $num3;
}
else
{
  $pr_ac3=sprintf "Aanderaa conductivity sensor #3 - no current data<br>\n";
}
$data_ac3=$num3;

$infilename=$ac4filename;
$num1=0;
$num3=0;
open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
}
close(IN);
if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
{
  $pr_ac4=sprintf "Aanderaa conductivity sensor #4 %s mS/cm<br>\n", $num3;
}
else
{
  $pr_ac4=sprintf "Aanderaa conductivity sensor #4 - no current data<br>\n";
}
$data_ac4=$num3;

#######################  output conductivity lines
print OUTFILE $pr_ac1;
print OUTFILE $pr_ac2;
print OUTFILE $pr_ac3;
print OUTFILE $pr_ac4;

# Look for AT1 if flow meter working, and salinity > 25 for all sensors
if (($data_fl1 > 0) & (($data_ac1 >25) | ($data_ac2 >25) | ($data_ac3 >25)) )
{

#   Andaara temperature sensors
#   $infilename=$at1filename;
#   open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
#   while (<IN>)
#   {
#     ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
#   }
#   close(IN);
#   if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
#   {
#     printf OUTFILE "Aanderaa temperature sensor #1 %s &deg;C<br>\n", $num3;
#   }
#   else
#   {
#     printf OUTFILE "Aanderaa temperature sensor #1 - no current data<br>\n";
#   }
#
#   $infilename=$at2filename;
#   open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
#   while (<IN>){
#     ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
#   }
#   close(IN);
#   if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
#   {
#     printf OUTFILE "Aanderaa temperature sensor #2 %s &deg;C<br>\n", $num3;
#   }
#   else
#   {
#     printf OUTFILE "Aanderaa temperature sensor #2- no current data<br>\n";
#   }
#
#    removed mrp20090409  replaced 2009Sep01
#   $infilename=$at3filename;
#   open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
#   while (<IN>){
#     ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
#   }
#   close(IN);
#   if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
#   {
#     printf OUTFILE "Aanderaa temperature sensor #3 %s &deg;C<br>\n", $num3;
#   }
#   else
#   {
#     printf OUTFILE "Aanderaa temperature sensor #3 - no current data<br>\n";
#   }

  # Printing conductivity moved from here until we get temperature files!

  # Andaara oxygen sensors
  $infilename=$ao1filename;
  open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
  while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
  }
  close(IN);
  if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
  {
  printf OUTFILE "Aanderaa oxygen sensor #1 %s &mu;M<br>\n", $num3;
  }
  else
  {
  printf OUTFILE "Aanderaa oxygen sensor #1 - no current data<br>\n";
  }

  $infilename=$ao2filename;
  open IN,"<$in_dir"."$infilename";
  #or die "Couldn't open $infilename\n";
  while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
  }
  close(IN);
  if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
  {
  printf OUTFILE "Aanderaa oxygen sensor #2 %s &mu;M<br>\n", $num3;
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
  printf OUTFILE "Aanderaa oxygen sensor #3 %s &mu;M<br>\n", $num3;
  }
  else
  {
  printf OUTFILE "Aanderaa oxygen sensor #3 - no current data<br>\n";
  }

  $infilename=$ao4filename;
  open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
  while (<IN>){
  ($num1, $num2, $num3, $num4)=split/\s+/,$_,4;
  }
  close(IN);
  if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
  {
  printf OUTFILE "Aanderaa oxygen sensor #4 %s &mu;M<br>\n", $num3;
  }
  else
  {
  printf OUTFILE "Aanderaa oxygen sensor #4 - no current data<br>\n";
  }

  #CO2 Sensors
  #		$infilename=$co2filename;
  #		$infilename=$coafilename;
  ##### Need to change to match format spec #######
  #		open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
  #		while (<IN>){
  #				($num1, $num2, $num3, $num4, $num5, $num6, $num7, $num8)=split/\s+/,$_,8;
  #	}
  #	close(IN);
  #		if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
  #		{
  #		printf OUTFILE "ProOceanus CO2 sensor CO2 concentration %s mol/mol<br>\n", $num3;
  #		printf OUTFILE "ProOceanus CO2 sensor optical cell temperature %s &deg;C<br>\n", $num4;
  #		printf OUTFILE "ProOceanus CO2 sensor humidity %s</i><br>\n", $num5;
  #		printf OUTFILE "ProOceanus CO2 sensor temperature %s &deg;C</i><br>\n", $num6;
  #		printf OUTFILE "ProOceanus CO2 sensor gas stream pressure %s mbar<br>\n", $num7;
  #		}
  #		else
  #		{
  #		printf OUTFILE "ProOceanus CO2 sensor CO2 concentration - no current data<br>\n";
  #		printf OUTFILE "ProOceanus CO2 sensor optical cell temperature - no current data<br>\n";
  #		printf OUTFILE "ProOceanus CO2 sensor humidity - no current data<br>\n";
  #		printf OUTFILE "ProOceanus CO2 sensor temperature - no current data<br>\n";
  #		printf OUTFILE "ProOceanus CO2 sensor gas stream pressure - no current data<br>\n";
  #		}

#   $infilename=$cobfilename;
#   open IN,"<$in_dir"."$infilename" or die "Couldn't open $infilename\n";
#   while (<IN>){
#   ($num1, $num2, $num9, $num10, $num3, $num4, $num5, $num6, $num7, $num8)=split/\s+/,$_,10;
#   }
#   close(IN);
#   if ( ($num1 == $year) & (abs($num2-$j_day_i)<1) )
#   {
#   printf OUTFILE "ProOceanus CO2 sensor CO2 concentration %s mol/mol<br>\n", $num3;
#   printf OUTFILE "ProOceanus CO2 sensor optical cell temperature %s &deg;C<br>\n", $num4;
#   printf OUTFILE "ProOceanus CO2 sensor humidity %s</i><br>\n", $num5;
#   printf OUTFILE "ProOceanus CO2 sensor temperature %s &deg;C</i><br>\n", $num6;
#   printf OUTFILE "ProOceanus CO2 sensor gas stream pressure %s mbar<br>\n", $num7;
#   }
#   else
#   {
#   printf OUTFILE "ProOceanus CO2 sensor CO2 concentration - no current data<br>\n";
#   printf OUTFILE "ProOceanus CO2 sensor optical cell temperature - no current data<br>\n";
#   printf OUTFILE "ProOceanus CO2 sensor humidity - no current data<br>\n";
#   printf OUTFILE "ProOceanus CO2 sensor temperature - no current data<br>\n";
#   printf OUTFILE "ProOceanus CO2 sensor gas stream pressure - no current data<br>\n";
#   }

  # Pro-Oceanus Gas Tension sensor file
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
# End of 'in salt water and have flow' if
}

print OUTFILE "  </center></body>\n";
print OUTFILE "</html>\n";
chmod 0744, $out_dir.$outfilename;

printf("Done.\n");


