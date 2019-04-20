#!/bin/bash

PORTS_FILE="$1"

if [[ ! ${PORTS_FILE} ]]; then
    PORTS_FILE="ports.csv"
fi

if [[ ! -f ${PORTS_FILE} ]]; then
    DEMO_PORTS="10; Internet - google.net; www.google.net; 80; 443"
fi

function func_doit ()
{
    INPUT_LINE=$*
    COUNT_CLOSED=0

    RULE_NR=$(echo ${INPUT_LINE} | cut -d ";" -f 1)
    INPUT_LINE=$(echo ${INPUT_LINE} | sed "s/^${RULE_NR};//g")
    
    RULE_DESCRIPTION=$(echo ${INPUT_LINE} | cut -d ";" -f 1)
    INPUT_LINE=$(echo ${INPUT_LINE} | sed "s/^${RULE_DESCRIPTION};//g")

    RULE_DESTINATION=$(echo ${INPUT_LINE} | cut -d ";" -f 1)
    INPUT_LINE=$(echo ${INPUT_LINE} | sed "s/^${RULE_DESTINATION};//g")

    RULE_IP=$(dig +short ${RULE_DESTINATION} | tail -1)

    echo -en "#${RULE_NR} - ${RULE_DESCRIPTION}\n\n"
    echo -en "\tDestination: ${RULE_DESTINATION}\n"

    if [[ ${#RULE_IP} == "0" ]];then
        echo -en "\t\tCan not resolve IP for ${RULE_DESTINATION}\n"
        return
    fi

    

    echo ${INPUT_LINE} | tr ';' '\n' | while read -r PORT; do
        echo -en "\t\tPort\t${PORT}..."
        
        PCHECK=$(cat </dev/null > /dev/tcp/${RULE_IP}/${PORT} & WPID=$!; sleep 1 && kill ${WPID} >/dev/null 2>&1)
        if [[ $? != 1 ]];then
            PCHECK="closed"
            COUNT_CLOSED=$(( ${COUNT_CLOSED} + 1 ))
        else
            PCHECK="open"
        fi
        echo ${PCHECK}
    done 
}


echo -e "\nAwesomenes Portchecker 3001"
echo -e "---------------------------\n"

if [[ -f ${PORTS_FILE} ]];then
    while read -r INPUT_LINE; do
        func_doit ${INPUT_LINE}
    done <${PORTS_FILE}
else
    func_doit ${DEMO_PORTS}
fi

echo -en "\n    Guru-Meter: Not implemented\n"
