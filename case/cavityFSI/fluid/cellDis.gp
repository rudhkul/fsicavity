# Gnuplot script file for plotting data from file "forceCoeffs.dat"
#set terminal png size 1000,600 enhanced
#
set key autotitle columnhead
set xtics 1
set ytics 0.005
set grid
set key right top
set key spacing 6
set key font 'cabin,14'
set xlabel "Time [s]"  font 'cabin,14'
set ylabel "cellDis"  font 'cabin,14'
plot "< sed s/[\\(\\)]//g postProcessing/probes/0/cellDisplacement" using 1:3 title 'cellDis' w l lw 3 axes x1y1
     
pause mouse
reread
