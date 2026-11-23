# Junta tudo num zip pronto para instalar no MO2 (plugin + scripts compilados + condicoes OAR).
import os, sys, zipfile
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
version = open(os.path.join(root, "VERSION"), encoding="utf-8").read().strip()
pex = os.path.join(root, "build", "Scripts", "ASL_MCM.pex")
if not os.path.exists(pex):
    sys.exit("ERRO: build/Scripts/ASL_MCM.pex nao existe (a compilacao falhou?)")
os.makedirs(os.path.join(root, "dist"), exist_ok=True)
out = os.path.join(root, "dist", "AnimStanceLE_v%s.zip" % version)
data = os.path.join(root, "Data")
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for folder, _, files in os.walk(data):
        for f in files:
            full = os.path.join(folder, f)
            z.write(full, os.path.relpath(full, data).replace(os.sep, "/"))
    z.write(pex, "Scripts/ASL_MCM.pex")
print("Criado:", out)
for n in zipfile.ZipFile(out).namelist():
    print(" ", n)
