import json
import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

result = {}
for surah in data:
    sid = surah['id']
    for verse in surah['verses']:
        vid = verse['id']
        translation = verse.get('translation') or verse.get('text', '')
        result[f"{sid}:{vid}"] = translation

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(result, f, ensure_ascii=False, separators=(',', ':'))

print(f"Converted {len(result)} verses from {input_file} to {output_file}")
