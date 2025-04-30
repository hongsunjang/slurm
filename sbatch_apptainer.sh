#!/bin/bash

#SBATCH --job-name=sif_pixart
#SBATCH --output=sif_pixart_%x_%j.out
#SBATCH --error=sif_pixart_%x_%j.err
#SBATCH --partition=a6000
#SBATCH --nodes=1
#SBATCH --gres=gpu:1               # Request 1 GPUs
#SBATCH --ntasks=4                 # Number of tasks
#SBATCH --cpus-per-task=8          # Number of CPU cores per task
#SBATCH --time=24:00:00            # Time limit

CONTAINER_PATH="/nfs/home/hsjang0918/sif/pytorch_base.sif"

# Check if running under SLURM
if [ -n "$SLURM_JOB_ID" ]; then
    echo "Running under SLURM, job ID: $SLURM_JOB_ID"
    
    # Use SLURM's CUDA_VISIBLE_DEVICES if available, or allocate GPUs dynamically
    if [ -z "$CUDA_VISIBLE_DEVICES" ]; then
        if [ -n "$SLURM_GPUS_ON_NODE" ]; then
            # Use SLURM_GPUS_ON_NODE as a fallback to determine GPUs
            export CUDA_VISIBLE_DEVICES=$(seq -s ',' 0 $((SLURM_GPUS_ON_NODE - 1)))
        else
            echo "No SLURM_GPU_ON_NODE or CUDA_VISIBLE_DEVICES. Defaulting to all GPUs."
            export CUDA_VISIBLE_DEVICES="0,1,2,3"  # Default to 4 GPUs
        fi
    fi
else
    echo "Running outside of SLURM."
    
    # Default GPU configuration
    export CUDA_VISIBLE_DEVICES="0"  # Default to 1 GPU
fi

# Print the GPUs being used
echo "Using GPUs: $CUDA_VISIBLE_DEVICES"

# Detect number of GPUs
export N_GPUS=$(echo $CUDA_VISIBLE_DEVICES | tr ',' '\n' | wc -l)
echo "Detected $N_GPUS GPUs"

# Check the node name and disable NCCL_P2P_DISABLE if on aisys-gpu00
if [ "$SLURMD_NODENAME" = "aisys-gpu00" ]; then
    echo "Running on aisys-gpu00, disabling NCCL_P2P"
    export NCCL_P2P_DISABLE=1  # Disable NCCL_P2P for aisys-gpu00
fi

# Activate Singularity or Apptainer environment
if command -v apptainer &> /dev/null; then
    echo "Using Apptainer."
else
    echo "Apptainer is not installed. Exiting."
    exit 1
fi

# Script parameters
SCRIPT="/nfs/home/hsjang0918/repo/MInference"

# pixart parameters
# PipeFusion (with warmup)
SYNC_MODE="corrected_async_gn"
WARMUP_STEP=2

# Run the training script
apptainer exec --nv $CONTAINER_PATH torchrun --nproc_per_node=$N_GPUS $GENERAL_TORCH_ARGS $SCRIPT 
