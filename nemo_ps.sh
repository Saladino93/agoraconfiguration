#!/bin/bash
#SBATCH --qos=regular
#SBATCH --time=01:30:00
#SBATCH --nodes=4
#SBATCH --job-name=nemo
#SBATCH --constraint=cpu
#SBATCH --account=mp107b
#SBATCH --output=/pscratch/sd/o/omard/slurmouts/slurm-%J.out

export DISABLE_MPI=false

module load cray-python
module load PrgEnv-intel
module load python
conda activate act


map_root_dir="/pscratch/sd/o/omard/FGSIMS_OUT/agora/"

#mask="/pscratch/sd/o/omard/FGSIMS_OUT/agora/prep_map/survey_mask.fits"
mask="/pscratch/sd/o/omard/dr5_masking/AdvACTSurveyMask_v7_S18.fits"
noise_tag="wnoise-wdr6dn"

for f in allfgs
do
    for freq in 090 0150
do
    nemo_run="nemo_${f}_ps_${freq}"
    map_dir="${map_root_dir}/prep_map/cmb_orig"
    config="${nemo_run}.yml"
    #cmd="srun --cpu-bind=cores -u -l -n 128 -c 8 nemo $config -M"
    #echo $cmd
    #logfile="/pscratch/sd/o/omard/slurmouts/$config.log"
    #echo $cmd > $logfile
    #$cmd > $logfile

    logfile="/pscratch/sd/o/omard/slurmouts/$config.log"
    #also run nemomodel
    beam="${map_dir}/beam_${freq}.txt"
    cmd="srun -u -l -n 128 -c 8 nemoModel "/pscratch/sd/o/omard/FGSIMS_OUT/agora/${nemo_run}/${nemo_run}_optimalCatalog.fits" $mask $beam "/pscratch/sd/o/omard/FGSIMS_OUT/agora/${nemo_run}/nemomodel_${freq}_snr4.fits" --freq $freq -M -n"
    echo $cmd
    echo $cmd > $logfile
    $cmd > $logfile

done
done
