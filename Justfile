download-model:
  python3 671b.py

download-llama-cpp:
  git clone https://github.com/ggerganov/llama.cpp

build-llama-cpp-with-gguf-split:
  cmake llama.cpp -B llama.cpp/build \
    -DBUILD_SHARED_LIBS=OFF \
    -DLLAMA_CURL=ON \
    -DGGML_METAL=ON
  cmake --build llama.cpp/build \
    -j \
    --config Release \
    --clean-first \
    --target llama-cli llama-gguf-split llama-quantize

merge-gguf:
  ./llama.cpp/llama-gguf-split \
    --merge ./DeepSeek-R1-GGUF/DeepSeek-R1-UD-IQ1_S/DeepSeek-R1-UD-IQ1_S-00001-of-00003.gguf \
    DeepSeek-R1-UD-IQ1_S-merged.gguf

prepare-ollama:
  ollama create deepseek:671b -f Modelfile

download: download-llama-cpp download-model

build: build-llama-cpp-with-gguf-split merge-gguf prepare-ollama

run-ollama:
  ollama run deepseek:671b

run-llama-cpp PROMPT:
  ./llama.cpp/llama-cli \
    --model ./DeepSeek-R1-GGUF/DeepSeek-R1-UD-IQ1_S/DeepSeek-R1-UD-IQ1_S-00001-of-00003.gguf \
    --cache-type-k q4_0 \
    --threads 16 \
    --prio 2 \
    --temp 0.6 \
    --ctx-size 8192 \
    --seed 3407 \
    --n-gpu-layers 59 \
    -no-cnv \
    --prompt "{{PROMPT}}"