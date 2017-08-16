function [var] = snoms_limits(param,v)

var = v;

switch param
  case 'co2'
    var (var>700) = NaN;
    var (var<200) = NaN;
  case 'Salinity'
    var (var>40) = NaN;
    var (var<25) = NaN;
  case 'Atmospheric CO_2 concentration (ppm)'
  var (var>700) = NaN;
  var (var<200) = NaN;
  case 'CO_2 concentration (ppm)'
  var (var>700) = NaN;
  var (var<200) = NaN;
end
