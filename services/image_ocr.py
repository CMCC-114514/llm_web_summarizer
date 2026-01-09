# services/image_ocr.py

import requests
from bs4 import BeautifulSoup
from PIL import Image
import pytesseract
import io


def extract_image_text(url: str) -> str:
    html = requests.get(url).text
    soup = BeautifulSoup(html, "html.parser")

    ocr_texts = []

    for img in soup.find_all("img"):
        src = img.get("src")
        if not src or not src.startswith("http"):
            continue

        try:
            img_data = requests.get(src, timeout=5).content
            image = Image.open(io.BytesIO(img_data))
            text = pytesseract.image_to_string(image)
            if text.strip():
                ocr_texts.append(text)
        except Exception:
            pass

    return "\n".join(ocr_texts)
