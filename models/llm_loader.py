# models/llm_loader.py

import streamlit as st
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
from config import MODEL_NAME


@st.cache_resource
def load_llm():
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME)
    return tokenizer, model
