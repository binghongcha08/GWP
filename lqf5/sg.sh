#!/bin/bash
MAX=20
SCRIPT=plx
DATA=q.dat
echo "clear" > ${SCRIPT}
echo "reset" >> ${SCRIPT}
#echo "set yr [-10:10]" >> ${SCRIPT}
echo "plot \\" >> ${SCRIPT}
for ((i=2;i<${MAX-1};i++))
do
echo "'${DATA}' u 1:$i w l not, \\"; done >> ${SCRIPT}
echo "'${DATA}' u 1:${MAX} w l not" >> ${SCRIPT}
echo "pause -1" >> ${SCRIPT}