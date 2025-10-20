#!/bin/bash

#srun --gres=gpu:4 --job-name=apptainer --partition=rtx4090 --nodelist=aisys-gpu01 --time 14-00:00:00 --pty bash
#srun --gres=gpu:4 --job-name=apptainer --partition=a6000 --time 14-00:00:00 --pty bash
#srun --gres=gpu:1 --job-name=apptainer --partition=a6000 --time 14-00:00:00 --pty bash
#srun --gres=gpu:2 --job-name=apptainer --partition=a6000 --nodelist=aisys-cluster07 --time 14-00:00:00 --pty bash
#srun --gres=gpu:4 --job-name=apptainer --partition=a6000 --time 14-00:00:00 --pty bash
#srun --gres=gpu:2 --job-name=apptainer --partition=a6000 --time 14-00:00:00 --pty bash
#srun --gres=gpu:2 --job-name=apptainer --partition=dist_ddr5 --time 14-00:00:00 --pty bash
srun --gres=gpu:4 --job-name=apptainer --partition=a6000 --nodelist=aisys-102-cluster05 --time 14-00:00:00 --pty bash
#srun --gres=gpu:4 --job-name=apptainer --partition=a6000 --time 14-00:00:00 --pty bash
