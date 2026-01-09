# services/summarizer.py

from config import MAX_INPUT_LENGTH


def generate_summary(
    text: str,
    tokenizer,
    model,
    max_len: int = 150,
    style: str = "新闻摘要"
) -> str:

    prompt = f"风格：{style}\n{text}"

    inputs = tokenizer(
        prompt,
        return_tensors="pt",
        truncation=True,
        max_length=MAX_INPUT_LENGTH
    )

    summary_ids = model.generate(
        inputs["input_ids"],
        max_length=max_len + 20,
        min_length=int(max_len * 0.85),
        num_beams=5,
        length_penalty=1.0,
        early_stopping=False,
        eos_token_id=tokenizer.eos_token_id,
        pad_token_id=tokenizer.pad_token_id
    )

    summary = tokenizer.decode(
        summary_ids[0],
        skip_special_tokens=True
    )

    # 清理异常符号
    summary = summary.replace("？", "").strip()

    return summary
