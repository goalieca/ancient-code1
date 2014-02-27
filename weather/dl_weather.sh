#!/bin/bash
for MONTH in {1..12}; do

    #roll over into new year
    if [ $MONTH == 1 ]; then
        YEAR=2011
    else
        YEAR=2010
    fi

    #fetch file from server and give it sane filename
    wget "http://climate.weatheroffice.gc.ca/climateData/bulkdata_e.html?timeframe=1&amp;Prov=XX&amp;StationID=889&amp;Year=$YEAR&amp;Month=$MONTH&amp;Day=1&amp;format=csv&amp;type=hly" -O "$YEAR-$MONTH.csv"

done
