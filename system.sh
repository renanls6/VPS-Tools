#!/bin/bash
set -e  # If any command fails, the script stops

echo "🚀 Starting the rl-swarm environment setup..."

# 1. Create venv if it doesn't exist
if [ ! -d ".venv" ]; then
  echo "⚙️  Creating virtual environment .venv..."
  python3 -m venv .venv
fi

# 2. Activate the venv
echo "⚙️  Activating virtual environment..."
source .venv/bin/activate

# 3. Update pip
echo "⬆️  Updating pip..."
pip install --upgrade pip

# 4. Uninstall wrong torch (if it exists)
echo "🧹 Cleaning up old torch installations..."
pip uninstall -y torch torchvision torchaudio || true

# 5. Install the correct PyTorch (CUDA 12.1), torchvision, torchaudio
echo "📦 Installing torch 2.2.2 + CUDA 12.1..."
pip install torch==2.2.2+cu121 torchvision==0.17.2+cu121 torchaudio==2.2.2+cu121 --extra-index-url https://download.pytorch.org/whl/cu121

# 6. Fix NumPy version
echo "🔧 Installing NumPy 1.26.4..."
pip install numpy==1.26.4

# 7. Install other necessary packages
echo "📦 Installing additional packages..."
pip install hivemind transformers trl

# 8. Final check
echo "✅ Verifying PyTorch and CUDA installation..."
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"

echo "🏁 Setup complete! Environment ready to use with rl-swarm."
