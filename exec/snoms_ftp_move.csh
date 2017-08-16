#!/bin/csh
# Copy most recent version of the merged SNOMS data to the ftp site
set merged_dir = "/noc/ote/remotetel/ascdata/SNOMS/merged/"
set ftp_dir = "/noc/itg/pubread/ferrybox/celebes/"
cd $merged

set daty=`date +%Y`
set datj=`date +%j`
set dath=`date +%H`
if ($dath < = 12) then
 @ datj = $datj - 1
endif
echo $daty
echo $datj
if ($datj < 10) then
    set datj0=00$datj
endif
if (($datj > 9) & ($datj < 100))then
    set datj0=0$datj
endif
echo $datj
cp PCel_$daty$datj0*.mrg $ftp_dir

cd $ftp_dir
chmod 755 *
set dysec=86400
set numb=7
#echo $numb
set dlim=`expr $dysec \* $numb`
echo $dlim
foreach fil (./*)
 set nowt=`date +%s`
# echo $nowt
 set tmod = `date +%s -r $fil`
# echo $tmod
 set age = `expr $nowt - $tmod`
# echo $age
 if ($age > $dlim) then
  echo $fil
  echo $age
  rm "$fil"
 endif
end
