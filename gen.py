import json

with open('assets/exercises.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

json_str = json.dumps(d, ensure_ascii=False)
out = f"const String gymExercisesJson = r'''{json_str}''';\n"
with open('lib/data/gym_exercises_catalog.dart', 'w', encoding='utf-8') as f:
    f.write(out)
