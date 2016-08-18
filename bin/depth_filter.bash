#!/bin/bash -e
# usage : ./bin/depth_filter.bash 3 droid
XML_FILE=android-m-targets-all.gexf
OUTPUT_GEXF=tmp/new.gexf

if [ -z "$1" ];then
    DEPTH=2
else
    DEPTH="$1"
fi

if [ -z "$2" ];then
    ROOT_NODE=droid
else
    ROOT_NODE="$2"
fi

# use ag to replace grep
QUERY_COMMAND=grep
if type ag > /dev/null;then
    QUERY_COMMAND="ag --nonumbers -Q "
fi

mkdir -p tmp
echo "" > tmp/nodes
echo "" > tmp/edges

query_nodes=( ${ROOT_NODE} )
for k in $(seq 1 ${DEPTH});do
    next_query_nodes=()
    for j in ${query_nodes[@]};do
        target_node=$(${QUERY_COMMAND} 'label="'"${j}"'"' ${XML_FILE})
        echo "${target_node}" >> tmp/nodes
        node_id=$(echo "${target_node}" | sed 's/.*id="\(.*\)" label=.*/\1/g')
        edge_nodes=$(${QUERY_COMMAND} 'target="'"${node_id}"'"' ${XML_FILE} || true)
        if [ -n "${edge_nodes}" ];then
            echo "${edge_nodes}" >> tmp/edges
            children_ids=$( echo "${edge_nodes}" | sed 's/.*source="\(.*\)" target=.*/\1/g' )
            ids=( ${children_ids} )
            children_name=()
            for i in ${ids[@]};do
                temp_node=$(${QUERY_COMMAND} 'id="'"${i}"'"' ${XML_FILE})
                node_name=$(echo "${temp_node}" | sed 's/.*id=".*" label="\(.*\)".*/\1/g')
                children_name+=( ${node_name} )
            done
            next_query_nodes+=( ${children_name[@]} )
        fi
    done
    query_nodes=( ${next_query_nodes[@]} )
done

for j in ${query_nodes[@]};do
    target_node=$(${QUERY_COMMAND} 'label="'"${j}"'"' ${XML_FILE})
    echo "${target_node}" >> tmp/nodes
done

head -8 ${XML_FILE} > ${OUTPUT_GEXF}
echo "    <nodes>" >> ${OUTPUT_GEXF}
cat tmp/nodes >> ${OUTPUT_GEXF}
echo "    </nodes>" >> ${OUTPUT_GEXF}
echo "    <edges>" >> ${OUTPUT_GEXF}
cat tmp/edges >> ${OUTPUT_GEXF}
echo "    </edges>" >> ${OUTPUT_GEXF}
tail -2 ${XML_FILE} >> ${OUTPUT_GEXF}

echo "find the result in tmp dir"
