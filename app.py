# app.py

import streamlit as st
from models.llm_loader import load_llm
from services.web_extractor import extract_text_from_url
from services.image_ocr import extract_image_text
from services.summarizer import generate_summary
from config import DEFAULT_SUMMARY_LEN


st.set_page_config(page_title="LLM长网页摘要系统", layout="wide")
st.title("📄 基于大语言模型的长网页摘要与交互系统")

# ===== 加载模型 =====
tokenizer, model = load_llm()

# ===== UI =====
url = st.text_input("请输入网页 URL")
summary_len = st.slider("摘要长度", 50, 300, DEFAULT_SUMMARY_LEN)
style = st.selectbox("摘要风格", ["新闻摘要", "学术概述", "要点列表"])
use_image = st.checkbox("融合网页图片信息（OCR）")

if st.button("生成摘要") and url:
    with st.spinner("正在解析网页并生成摘要..."):
        text = extract_text_from_url(url)

        if use_image:
            image_text = extract_image_text(url)
            if image_text:
                text += "\n【图片信息】\n" + image_text

        summary = generate_summary(
            text=text,
            tokenizer=tokenizer,
            model=model,
            max_len=summary_len,
            style=style
        )

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("原文（节选）")
        st.text_area("", text[:3000], height=400)

    with col2:
        st.subheader("生成摘要")
        st.success(summary)
