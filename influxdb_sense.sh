#!/bin/bash
while read -r line; do

hz=$(echo "${line}" |jq .payload.hz)
mainsL=$(echo "${line}" |jq .payload.channels[] -c | head -1)
mainsR=$(echo "${line}" |jq .payload.channels[] -c | tail -1)
mainsT=$(echo "${line}" |jq .payload.w)
voltageL=$(echo "${line}" |jq .payload.voltage[] -c | head -1)
voltageR=$(echo "${line}" |jq .payload.voltage[] -c | tail -1)
voltageT=$(echo "${voltageL}" + "${voltageR}" | bc)

wattsAirConditioner=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Air Conditioner")'.w)
wattsAlwaysOn=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Always On")'.w)
wattsElectricBlanket=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Electric Blanket")'.w)
wattsElectricVehicle=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Electric Vehicle")'.w)
wattsFridge=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Fridge")'.w)
wattsFurnace=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Furnace")'.w)
wattsGarageDoor=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Garage Door")'.w)
wattsOther=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Other")'.w)
wattsWaterHeater=$(echo "${line}" |jq '.payload.devices[] | select(.name == "Water Heater")'.w)

if [ -z "$wattsFridge" ]
then
wattsFridge="0"
fi

if [ -z "$wattsGarageDoor" ]
then
wattsGarageDoor="0"
fi

if [ -z "$wattsWaterHeater" ]
then
wattsWaterHeater="0"
fi

if [ -z "$wattsElectricBlanket" ]
then
wattsElectricBlanket="0"
fi

if [ -z "$wattsElectricVehicle" ]
then
wattsElectricVehicle="0"
fi

if [ -z "$wattsFurnace" ]
then
wattsFurnace="0"
fi

if [ -z "$wattsAirConditioner" ]
then
wattsAirConditioner="0"
fi

curl -s -i -XPOST "http://app04.tylephony.com:8086/write?db=sense" --data-binary "mains,name=Hz hz=${hz}
mains,name=L watts=${mainsL}
mains,name=R watts=${mainsR}
mains,name=Total watts=${mainsT}
mains,name=L volts=${voltageL}
mains,name=R volts=${voltageR}
mains,name=Total volts=${voltageT}
devices,name=Air\ Conditioner watts=${wattsAirConditioner}
devices,name=Always\ On watts=${wattsAlwaysOn}
devices,name=Electric\ Blanket watts=${wattsElectricBlanket}
devices,name=Electric\ Vehicle watts=${wattsElectricVehicle}
devices,name=Fridge watts=${wattsFridge}
devices,name=Furnace watts=${wattsFurnace}
devices,name=Garage\ Door watts=${wattsGarageDoor}
devices,name=Other watts=${wattsOther}
devices,name=Water\ Heater watts=${wattsWaterHeater}"
done < /dev/stdin
