import json
import urllib.request
import os

BASES = [
    "https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/ar-tafsir-muyassar/{}.json",
    "https://raw.githubusercontent.com/spa5k/tafsir_api/main/tafsir/ar-tafsir-muyassar/{}.json",
]

def fetch_surah(n):
    for base in BASES:
        url = base.format(n)
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=30) as r:
                return json.loads(r.read().decode("utf-8"))
        except Exception as e:
            continue
    return None

result = {}
ok = 0
for n in range(1, 115):
    data = fetch_surah(n)
    if not data:
        print(f"[FAIL] surah {n}")
        continue
    if isinstance(data, dict) and "ayahs" in data:
        for a in data["ayahs"]:
            result[f"{n}:{a['ayah']}"] = a["text"]
    elif isinstance(data, list):
        for a in data:
            aid = a.get("ayah") or a.get("id")
            txt = a.get("text") or a.get("tafsir")
            if aid and txt:
                result[f"{n}:{aid}"] = txt
    elif isinstance(data, dict):
        for k, v in data.items():
            result[f"{n}:{k}"] = v if isinstance(v, str) else str(v)
    ok += 1
    print(f"[OK] surah {n}")

with open("ar_muyassar.json", "w", encoding="utf-8") as f:
    json.dump(result, f, ensure_ascii=False, separators=(",", ":"))

print(f"\n=== Done: {ok}/114 surahs, {len(result)} ayahs ===")
