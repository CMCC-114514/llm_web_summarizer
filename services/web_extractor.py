# services/web_extractor.py

import requests
from bs4 import BeautifulSoup
from readability import Document
from config import REQUEST_TIMEOUT


def extract_text_from_url(url: str) -> str:
    html = requests.get(url, timeout=REQUEST_TIMEOUT).text
    doc = Document(html)
    soup = BeautifulSoup(doc.summary(html_partial=True), "html.parser")

    paragraphs = [p.get_text() for p in soup.find_all("p")]
    return "\n".join(paragraphs)
