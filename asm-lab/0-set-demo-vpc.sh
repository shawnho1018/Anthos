#!/bin/bash
source ./utility.sh
# create vpc
create_vpc "asm-c1" "10.10.1.0/24" "10.10.2.0/24" "10.10.0.0/16"
create_vpc "asm-c2" "10.11.1.0/24" "10.11.2.0/24" "10.11.0.0/16"
