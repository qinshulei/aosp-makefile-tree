#!/bin/bash -e
XML_FILE=android-m-targets-all.xml
if [ -z "$1" ];then
    QUERY="droid"
else
    QUERY="$1"
fi

target_node=$(grep 'label="'"${QUERY}"'"' ${XML_FILE})
node_id=$(echo "${target_node}" | sed 's/.*id="\(.*\)" label=.*/\1/g')
edge_nodes=$(grep 'source="'"${node_id}"'"' ${XML_FILE})
parent_ids=$( echo "${edge_nodes}" | sed 's/.*source=".*" target="\(.*\)".*/\1/g' )
ids=( ${parent_ids} )
parent_name=()
for i in ${ids[@]};do
    temp_node=$(grep 'id="'"${i}"'"' ${XML_FILE})
    node_name=$(echo "${temp_node}" | sed 's/.*id=".*" label="\(.*\)".*/\1/g')
    parent_name+=( ${node_name} )
done
# echo ${parent_name[@]}
for name in ${parent_name[@]};do
    echo ${name}
done
