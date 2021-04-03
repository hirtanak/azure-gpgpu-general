#!/bin/bash
# Example usage: ./full-pingpong.sh | grep -e ' 512 ' -e NODES -e usec

HOSTFILE=./hostfile
IMPIDIR=/opt/intel/impi/2018.4.274/bin64

echo "HOSTFILE: ${HOSTFILE}"
echo "IMPIDIR:  ${IMPIDIR}"

for NODE in `cat ${HOSTFILE}`; \
    do for NODE2 in `cat ${HOSTFILE}`; \
        do echo '##################################################' && \
            echo NODES: $NODE, $NODE2 && \
            echo '##################################################' && \
            ${IMPIDIR}/mpirun\
            -hosts $NODE,$NODE2 -ppn 1 -n 2 \
            -env I_MPI_FABRICS=dapl \
            ${IMPIDIR}/IMB-MPI1 pingpong | grep -e ' 512 ' -e NODES -e usec; \
        done; \
    done
