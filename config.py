from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

DATA_DIR = BASE_DIR / "data"
DATA_RAW = DATA_DIR / "raw"
DATA_PROCESSED = DATA_DIR / "processed"

MODELS_DIR = BASE_DIR / "models"
OUTPUTS_DIR = BASE_DIR / "outputs"

for path in [DATA_RAW, DATA_PROCESSED, MODELS_DIR, OUTPUTS_DIR]:
    path.mkdir(parents=True, exist_ok=True)
