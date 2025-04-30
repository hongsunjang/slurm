#!/bin/bash

# 현재 GPU 요청 job만 필터링하여 NODELIST 및 GRES 열만 추출
squeue --noheader --format="%R %b" | grep gpu: > /tmp/slurm_gpu_tmp.txt

# 결과 딕셔너리 만들기
declare -A gpu_count

# 한 줄씩 읽어서 합산
while read -r line; do
    node=$(echo "$line" | awk '{print $1}')
    gres=$(echo "$line" | awk '{print $2}')

    # Pending 상태 제외 (예: (Resources), (Priority))
    if [[ "$node" == \(*\) ]]; then
        continue
    fi

    # gpu 개수 추출
    gpu_num=$(echo "$gres" | grep -oP 'gpu:\K[0-9]+')
    if [ -z "$gpu_num" ]; then
        gpu_num=1
    fi

    # 누적
    gpu_count["$node"]=$((gpu_count["$node"] + gpu_num))
done < /tmp/slurm_gpu_tmp.txt

# 출력
echo "===== GPU 사용량 (SLURM 기준) ====="
for node in $(printf "%s\n" "${!gpu_count[@]}" | sort -V); do
    echo "$node: ${gpu_count[$node]} GPU(s)"
done

rm /tmp/slurm_gpu_tmp.txt

