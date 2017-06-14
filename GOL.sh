#!/bin/bash
w=`tput cols`
h=`tput lines`

function paint()
{
	#clear
	p=`echo -n -e "\033[H"
	for((i=0;i<h;i++))
		do
		for((j=0;j<w;j++))
			do
				if [ ${world[i*w+j]} -eq 1 ]
				then
					echo -n -e "\033[07m  \033[m"
				else
					echo -n -e "  "
				fi
			done
		echo -n -e "\033[E"
		done`
	echo "$p"
}

function evolve()
{
	declare -a new
	for((i=0;i<h;i++))
		do
		for((j=0;j<w;j++))
			do
				n=0
				for((i1=i-1;i1<=i+1;i1++))
					do
					for((j1=j-1;j1<=j+1;j1++))
						do
							a=$((($i1+$h)%$h))
							b=$((($j1+$w)%$w))
							if [ ${world[a*w+b]} -eq 1 ]
							then
								n=$(($n+1))
							fi
						done
					done
				if [ ${world[i*w+j]} -eq 1 ]
				then
					n=$(($n-1))
				fi
				if (( n == 3 || ( n == 2 && ${world[i*w+j]} == 1 ) ))
				then
					new[i*w+j]=1
				else
					new[i*w+j]=0
				fi
			done
		done
		for((i=0;i<h;i++))
		do
		for((j=0;j<w;j++))
			do
				world[i*w+j]=${new[i*w+j]}
			done
		done
}
function GOL()
{
	declare -a world
	max=32767
	for((i=0;i<h;i++))
		do
		for((j=0;j<w;j++))
			do
				r=$RANDOM
				k=$(($max/10))
				if [ $r -lt $k ]
					then
						world[(i*w)+j]=1
					else
						world[(i*w)+j]=0
				fi
			done
		done
	while true
		do
			paint
			evolve
			sleep .000005
		done
}

clear
tput civis
GOL
