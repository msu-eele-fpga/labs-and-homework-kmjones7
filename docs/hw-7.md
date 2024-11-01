# HW 7
## Overview
In this homework assignment, linux commands were used to sort, cut, and find various elements in files. 
## Deliverables

### Problem 1
command: ` wc -w lorem-ipsum.txt`  
output:  
![IMAGE](assets/hw-7/p1_hw7.png)

### Problem 2
command: `wc -m lorem-ipsum.txt`  
output:   
![IMAGE](assets/hw-7/p2_hw7.png)

### Problem 3
command: `wc -l lorem-ipsum.txt`  
output:  
![IMAGE](assets/hw-7/p3_hw7.png)

### Problem 4
command: `sort -h file-sizes.txt`  
output:    
![IMAGE](assets/hw-7/p4_hw7.png)

### Problem 5
command:  `sort -h -r file-sizes.txt`  
output:  
![IMAGE](assets/hw-7/p5_hw7.png)

### Problem 6
command: `cut -d ',' -f 3 log.csv`    
output:  
![IMAGE](assets/hw-7/p6_hw7.png)

### Problem 7
command: `cut -d ',' -f 2,3 log.csv`  
output:  
![IMAGE](assets/hw-7/p7_hw7.png)

### Problem 8
command: `cut -d ',' -f 1,4 log.csv`  
output:  
![IMAGE](assets/hw-7/p8_hw7.png)

### Problem 9
command: `head -n 3 gibberish.txt`  
output:  
![IMAGE](assets/hw-7/p9_hw7.png)

### Problem 10
command: `tail -n 2 gibberish.txt`  
output:  
![IMAGE](assets/hw-7/p10_hw7.png)

### Problem 11
command: `tail -n +2 log.csv`  
output:  
![IMAGE](assets/hw-7/p11_hw7.png)

### Problem 12
command: `grep and gibberish.txt`  
output:  
![IMAGE](assets/hw-7/p12_hw7.png)

### Problem 13
command: `grep we -n -w gibberish.txt`  
output:  
![IMAGE](assets/hw-7/p13_hw7.png)

### Problem 14
command: `grep -i -o -P 'to\s+\w+' gibberish.txt`  
output:  
![IMAGE](assets/hw-7/p14_hw7.png)

### Problem 15
command: `grep FPGAs -w -c fpgas.txt`  
output:  
![IMAGE](assets/hw-7/p15_hw7.png)

### Problem 16
command: `grep -e 'ot' -e 'ower' -e 'ile' fpgas.txt`  
output:  
![IMAGE](assets/hw-7/p16_hw7.png)

### Problem 17
command: `grep -r '^-' -c LED_Patterns/*.vhd`  
output:  
![IMAGE](assets/hw-7/p17_hw7.png)

### Problem 18
command: `ls > p18.txt`  
output:  
![IMAGE](assets/hw-7/p18_hw7.png)

### Problem 20
command: `find hdl -iname '*.vhd' | wc -l`  
output:  
![IMAGE](assets/hw-7/p20_hw7.png)

### Problem 21
command: `grep -roi '^--' hdl | wc -l`  
output:  
![IMAGE](assets/hw-7/p21_hw7.png)

### Problem 22
command: `grep FPGAs -n fpgas.txt | cut -d ':' -f 1`  
output:  
![IMAGE](assets/hw-7/p22_hw7.png)

### Problem 23
command: `du -h * | sort -h | tail -n 3`  
output:  
![IMAGE](assets/hw-7/p23_hw7.png)



