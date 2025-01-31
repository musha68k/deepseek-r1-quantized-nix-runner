# DeepSeek R1 Quantized Nix Runner

Nix-based setup for running quantized versions of DeepSeek R1, based on [unsloth's implementation](https://unsloth.ai/blog/deepseekr1-dynamic).

## Prerequisites

- Nix package manager
- Minimum: 20GB RAM for CPU-only operation (will be slow)
- For optimal performance: 80GB+ combined VRAM + RAM
- GPU acceleration supported on:
  - CUDA-capable GPU (Linux)
  - Apple Silicon (macOS)

## Usage

1. `nix-shell`
2. `just build`
3. `just run-ollama` or `just "run-llama-cpp PROMPT"`

## Details

Check the original blog post for system requirements, quantization options (1.58-bit to 2.51-bit) and performance details.

Note: This is not an official DeepSeek implementation.
