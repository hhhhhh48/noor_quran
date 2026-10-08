import json
import urllib.request
import os

# كل لغة: قائمة بأسماء الملفات المحتملة في مصادر مختلفة
SOURCES = {
    "en": ["en-tafsir-ibn-kathir", "en-tafisr-ibn-kathir", "en-tafsir-maarif-ul-quran"],
    "fr": ["fr-tafsir-ibn-kathir", "fr-tafsir-muyassar"],
    "es": ["es-tafsir-ibn-kathir", "es-tafsir-muyassar"],
    "ru": ["ru-tafsir-ibn-kathir", "ru-tafsir-muyassar"],
    "tr": ["tr-tafsir-ibn-kathir", "tr-tafsir-diyanet"],
    "ur": ["ur-tafsir-ibn-kathir", "ur-tafsir-bayan-ul-quran"],
    "bn": ["bn-tafsir-ibn-kathir", "bn-tafsir-abu-bakr"],
    "id": ["id-tafsir-ibn-kathir", "id-tafsir-jalalayn"],
    "zh": ["zh-tafsir-ibn-kathir", "zh-tafsir-muyassar"],
    "sv": ["sv-tafsir-ibn-kathir"],
}

BASE_TEMPLATES = [
    "https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/{}/{}.json",
    "https://raw.githubusercontent.com/spa5k/tafsir_api/main/tafsir/{}/{}.json",
]

def try_fetch(name, n):
    for tpl in BASE_TEMPLATES:
        url = tpl.format(name, n)
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=20) as r:
                return json.loads(r.read().decode("utf-8"))
        except Exception:
            continue
    return None

def convert(data):
    result = {}
    if isinstance(data, dict) and "ayahs" in data:
        for a in data["ayahs"]:
            result[f"{sid}:{a['ayah']}"] = a["text"]
    elif isinstance(data, list):
        for a in data:
            aid = a.get("ayah") or a.get("id")
            txt = a.get("text") or a.get("tafsir")
            if aid and txt:
                result[f"{sid}:{aid}"] = txt
    elif isinstance(data, dict):
        for k, v in data.items():
            result[f"{sid}:{k}"] = v if isinstance(v, str) else str(v)
    return result

ok_langs = []
for lang, candidates in SOURCES.items():
    print(f"\n=== {lang.upper()} ===")
    name = None
    # اكتشف الاسم الصحيح
    for c in candidates:
        test = try_fetch(c, 1)
        if test:
            name = c
            print(f"  Found: {c}")
            break
    if not name:
        print(f"  [SKIP] No source found")
        continue
    
    all_verses = {}
    success = 0
    for sid in range(1, 115):
        data = try_fetch(name, sid)
        if not data:
            continue
        # استخدم sid الصحيح
        if isinstance(data, dict) and "ayahs" in data:
            for a in data["ayahs"]:
                all_verses[f"{sid}:{a['ayah']}"] = a["text"]
        elif isinstance(data, list):
            for a in data:
                aid = a.get("ayah") or a.get("id")
                txt = a.get("text") or a.get("tafsir")
                if aid and txt:
                    all_verses[f"{sid}:{aid}"] = txt
        success += 1
        if success % 20 == 0:
            print(f"  ...{success}/114")
    
    if all_verses:
        with open(f"{lang}.json", "w", encoding="utf-8") as f:
            json.dump(all_verses, f, ensure_ascii=False, separators=(",", ":"))
        print(f"  [OK] {len(all_verses)} ayahs -> {lang}.json")
        ok_langs.append(lang)
    else:
        print(f"  [FAIL] no data")

print(f"\n=== Summary: {len(ok_langs)} languages OK: {', '.join(ok_langs)} ===")
