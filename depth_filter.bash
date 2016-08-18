#!/bin/bash
XML_FILE=android-m-targets-all.gexf

if [ -z "$1" ];then
    NUM=5
else
    NUM="$1"
fi

query_nodes=( droid )
for k in $(seq 1 ${NUM});do
    next_query_nodes=()
    for j in ${query_nodes[@]};do
        target_node=$(grep 'label="'"${j}"'"' ${XML_FILE})
        echo ${target_node}
        node_id=$(echo "${target_node}" | sed 's/.*id="\(.*\)" label=.*/\1/g')
        edge_nodes=$(grep 'target="'"${node_id}"'"' ${XML_FILE})
        echo ${edge_nodes}
        children_ids=$( echo "${edge_nodes}" | sed 's/.*source="\(.*\)" target=.*/\1/g' )
        ids=( ${children_ids} )
        children_name=()
        for i in ${ids[@]};do
            temp_node=$(grep 'id="'"${i}"'"' ${XML_FILE})
            node_name=$(echo "${temp_node}" | sed 's/.*id=".*" label="\(.*\)".*/\1/g')
            children_name+=( ${node_name} )
        done

        next_query_nodes+=( ${children_name[@]} )
    done
    query_nodes=( ${next_query_nodes[@]} )
done

for j in ${query_nodes[@]};do
    target_node=$(grep 'label="'"${j}"'"' ${XML_FILE})
    echo ${target_node}
done
