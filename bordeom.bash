#!/bin/bash
MSG[0]=" _______  _______  ______    _______  ______   _______  __   __ "
MSG[1]="|  _    ||       ||    _ |  |       ||      | |       ||  |_|  |"
MSG[2]="| |_|   ||   _   ||   | ||  |    ___||  _    ||   _   ||       |"
MSG[3]="|       ||  | |  ||   |_||_ |   |___ | | |   ||  | |  ||       |"
MSG[4]="|  _   | |  |_|  ||    __  ||    ___|| |_|   ||  |_|  ||       |"
MSG[5]="| |_|   ||       ||   |  | ||   |___ |       ||       || ||_|| |"
MSG[6]="|_______||_______||___|  |_||_______||______| |_______||_|   |_|"
trap reset && clear && exit SIGINT SIGTERM
tput civis
printf "\x1b[H\x1b[2J"
while (true); do
  printf "\x1b[$(jot -r 1 30 39)m"
  for ((x=0; x<${#MSG[0]}; x++)); do
    for ((y=0; y<=7; y++)); do
      printf "\x1b[%s;%sH%c" $(($y+1)) $(($x+1)) ${MSG[$y]:$x:1}
      sleep 0.001
    done
  done
done
# toifowei
