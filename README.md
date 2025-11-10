# NLP Lab — Software Requirements Classification

A hands-on **NLP laboratory** for exploring and validating *Functional* and *Non-Functional* software requirements.  
This repository demonstrates a complete pipeline — from raw data exploration to BERT-based feature extraction and model training.

---

## Dataset ##

**Source:**  
[Software Requirements Classification Dataset (Mendeley Data)](https://data.mendeley.com/datasets/4ysx9fyzv4/1)

Contains labeled requirements categorized as:
- **FR** — Functional Requirements  
- **NFR** — Non-Functional Requirements

Download the dataset and place it in:

```
data/raw/FR_NFR_Dataset.xlsx
```


## Environment Setup ##

Run the setup script:

```bash
bash setup.sh
```

Or manually:

```bash
pip install -r requirements.txt
pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.7.1/en_core_web_sm-3.7.1.tar.gz
python -m nltk.downloader stopwords punkt wordnet
```

Then start Jupyter:

```bash
jupyter notebook
```


## Pipeline Overview ##

| Notebook | Purpose |
|-----------|----------|
| **01_exploratory_data_analysis.ipynb** | Exploratory analysis — visualize word frequencies, class balance, and requirement length distributions |
| **02_preprocessing.ipynb** | Text cleaning and normalization (lowercasing, tokenization, lemmatization, stopword removal) + train/test split |
| **03_feature_extraction.ipynb** | Generate feature representations: TF-IDF vectors and contextual BERT embeddings |
| **04_modeling.ipynb** | Train and evaluate classification models (Logistic Regression, SVM, MLP, and optional BERT fine-tuning) |
| **05_deployment_inference.ipynb** | Load trained models and perform inference on new requirements (single or batch predictions) |
| **06_classification_analysis.ipynb** | Semantic validation: detect ambiguity, inconsistency, and incompleteness using Sentence-BERT embeddings and visualizations |
| **07_validations.ipynb** | In-depth analysis of ambiguity, inconsistency, and incompleteness with linguistic and embedding-based heuristics |


### Example: Requirement Classification

```python
from joblib import load
import pickle

# Load model and vectorizer
model = load("models/log_reg_tfidf.pkl")
with open("models/tfidf_vectorizer.pkl", "rb") as f:
    tfidf_vectorizer = pickle.load(f)

# Predict example requirement
requirement = "The system shall provide secure authentication."
vector = tfidf_vectorizer.transform([requirement])
label = model.predict(vector)[0]

print(f"{requirement} -> {label}")
```

### Semantic Validation (Notebooks 07)

The semantic validation and quality analysis modules leverage **Sentence-BERT** and **linguistic heuristics** to assess requirement quality by:

- Detecting **ambiguity** — vague or subjective terms  
- Identifying **inconsistency** — contradictory or redundant statements  
- Spotting **incompleteness** — requirements with missing or underspecified context  

**Outputs:**
- Word clouds for requirement clusters  
- Cosine similarity heatmaps  
- Ambiguity / redundancy reports  
- Highlighted ambiguous phrases and incomplete requirement patterns  



### Next Steps

- Integrate rule-based linguistic ambiguity detection  
- Build a lightweight inference API (e.g., Streamlit)


*Developed for educational and research purposes — ideal for NLP experiments in software engineering.*