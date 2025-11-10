#!/bin/bash
set -e

echo "========================================="
echo " Setting up NLP Laboratory Environment "
echo "========================================="

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
  echo "[0/7] Creating virtual environment..."
  python3 -m venv .venv || python -m venv .venv
fi

# Activate virtual environment
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
elif [ -f ".venv/Scripts/activate" ]; then
    source .venv/Scripts/activate
else
    echo "Could not find virtual environment activation script!"
    exit 1
fi
echo "Virtual environment activated."

# Upgrade pip and install requirements
echo "[1/7] Installing Python dependencies from requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt

# Install Transformers, Datasets, Torch
echo "[1b/7] Installing Transformers, Datasets, PyTorch..."
pip install --quiet transformers datasets torch

# Install spaCy model
echo "[2/7] Installing spaCy English model (en_core_web_sm)..."
pip install --quiet https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.7.1/en_core_web_sm-3.7.1.tar.gz

# Download NLTK corpora
echo "[3/7] Downloading NLTK corpora (stopwords, punkt, wordnet)..."
python - <<'PYTHON_CODE'
import nltk
import time

def download_with_retry(pkg, retries=5, delay=10):
    for i in range(retries):
        try:
            nltk.download(pkg)
            print(f"Downloaded {pkg}")
            return
        except Exception as e:
            if "429" in str(e):
                print(f"Too many requests for {pkg}, retrying in {delay}s ({i+1}/{retries})...")
                time.sleep(delay)
            else:
                print(f"Failed to download {pkg}: {e}")
                return
    print(f"Skipped {pkg} after {retries} retries.")

for pkg in ["stopwords", "punkt", "wordnet"]:
    download_with_retry(pkg)
PYTHON_CODE

# Test spaCy, NLTK, and PyTorch
echo "[4/7] Testing spaCy, NLTK, and PyTorch installation..."
python - <<'PYTHON_TEST'
import nltk
import spacy
import torch

nltk.data.find("corpora/wordnet")
nltk.data.find("tokenizers/punkt")

nlp = spacy.load("en_core_web_sm")
doc = nlp("This is a test sentence.")
print("SpaCy lemmas:", [token.lemma_ for token in doc])

print("PyTorch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
PYTHON_TEST

# Final confirmation
echo "[5/7] Environment setup complete!"
echo "All dependencies installed and verified."

# Instructions to start Jupyter
echo "[6/7] To start Jupyter Notebook:"
if [ -f ".venv/bin/activate" ]; then
    echo "source .venv/bin/activate && jupyter notebook"
else
    echo ".venv\\Scripts\\activate && jupyter notebook"
fi