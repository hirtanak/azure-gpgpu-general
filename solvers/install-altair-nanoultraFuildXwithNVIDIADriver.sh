#!/bin/bash
set -x

SHARE_HOME=$1
LICIP=$2
HOST=`hostname`
DOWN=$3
USER=$4
SHARE_DATA="/home/${USER}"
echo $USER,$SHARE_HOME,$LICIP,$HOST,$DOWN,$SHARE_DATA

# install driver
yum install -y dkms gcc kernel-devel kernel-headers
yum install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
mkdir -p /home/$USER/nvidia
cd  /home/$USER/nvidia
#wget https://hirostpublicshare.blob.core.windows.net/solvers/NVIDIA-Linux-x86_64-390.87.run
#chmod +x  /home/$USER/nvidia/NVIDIA-Linux-x86_64-390.87.run
wget https://hirostpublicshare.blob.core.windows.net/solvers/NVIDIA-Linux-x86_64-410.78.run
chown -R $USER:$USER /home/$USER/nvidia
chmod +x  /home/$USER/nvidia/NVIDIA-Linux-x86_64-410.78.run
sh /home/$USER/nvidia/NVIDIA-Linux-x86_64-410.78.run -a -s
nvidia-smi >> /home/$USER/nvidia/nvidia-smi.log

# create directory
mkdir -p $SHARE_DATA/scratch/altair
mkdir -p $SHARE_DATA/scratch/altair/ultraFuildX

wget -q https://hirostpublicshare.blob.core.windows.net/solvers/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP.tar.gz -O $SHARE_DATA/scratch/altair/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP.tar.gz
wget -q https://hirostpublicshare.blob.core.windows.net/solvers/ultraFluidX.v2018.0.1.2.linux64.bin -O $SHARE_DATA/scratch/altair/ultraFuildX/ultraFluidX.v2018.0.1.2.linux64.bin
wget -q https://hirostpublicshare.blob.core.windows.net/solvers/altair_licensing_14.0.2.linux_x64.bin -O $SHARE_DATA/scratch/altair/altair_licensing_14.0.2.linux_x64.bin
wget -q https://hirostpublicshare.blob.core.windows.net/solvers/$DOWN.tar.gz -O $SHARE_DATA/altair/$DOWN.tar.gz
#chown -R $USER:$USER /home/$USER/altair
chown -R $USER:$USER $SHARE_DATA/scratch/altair

cd $SHARE_DATA/scratch/altair/
tar -zxvf $SHARE_DATA/scratch/altair/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP.tar.gz -C $SHARE_DATA/scratch/altair
chown -R $USER:$USER /home/$USER/scratch/altair/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP

cd $SHARE_DATA/scratch/altair/ultraFuildX
chown -R $USER:$USER $SHARE_DATA/scratch/altair/ultraFuildX/ultraFluidX.v2018.0.1.2.linux64.bin
chmod +x $SHARE_DATAscratch//altair/ultraFuildX/ultraFluidX.v2018.0.1.2.linux64.bin
sh $SHARE_DATA/scratch/altair/ultraFuildX/ultraFluidX.v2018.0.1.2.linux64.bin
chown -R $USER:$USER $SHARE_DATA/scratch/altair/ultraFuildX

chmod 755 $SHARE_DATA/scratch/altair/altair_licensing_14.0.2.linux_x64.bin

#ompi setting configuration
#nanoFuildX
echo "btl=tcp,self,sm" >> /home/$USER/scratch/altair/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP/libs/openmpi/2.1.2-ibverbs/etc/openmpi-mca-params.conf
echo "btl_tcp_if_include=docker0,lo,eth0" >> /home/$USER/scratch/altair/20180806_nanoFluidX_SA_2018.0.0.10_beta_SP/libs/openmpi/2.1.2-ibverbs/etc/openmpi-mca-params.conf

#ultraFuildX
echo "btl=tcp,self,sm" >> /home/$USER/scratch/altair/ultraFuildX/mpi/linux64/openmpi/etc/openmpi-mca-params.conf
echo "btl_tcp_if_include=docker0,lo,eth0" >> /home/$USER/scratch/altair/ultraFuildX/mpi/linux64/openmpi/etc/openmpi-mca-params.conf

