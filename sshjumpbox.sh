#!/bin/bash

MACHINE=100
#xyzjumpbox200.xyz.safedata.net
DC=lvs
if [[ $1 =~ "xyz" ]]
then
    DC=xyz
elif [[ $1 =~ "abc" ]]
then
    DC=abc
elif [[ $1 =~ "def" ]]
then
    DC=def
fi

ssh -J username@${DC}jumpbox${MACHINE}.${DC}.safedata.net $1
