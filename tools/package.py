# Junta tudo num zip pronto para instalar no MO2 (plugin + condicoes OAR).
import os, zipfile
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
version = open(os.path.join(root, "VERSION"), encoding="utf-8").read().strip()
data = os.path.join(root, "Data")
os.makedirs(os.path.join(root, "dist"), exist_ok=True)
out = os.path.join(root, "dist", "AnimStanceLE_v%s.zip" % version)
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for folder, dirs, files in os.walk(data):
        dirs.sort()
        for f in sorted(files):
            full = os.path.join(folder, f)
            z.write(full, os.path.relpath(full, data).replace(os.sep, "/"))
print("Criado:", out)
for n in zipfile.ZipFile(out).namelist():
    print(" ", n)
