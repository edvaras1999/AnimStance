# AnimStanceLE

Seletor de estilos de animacao (OAR/DAR via Themis) para Skyrim LE 1.9.32.
Cada estilo e um conjunto de animacoes que disputa a mesma condicao. O mod activa um
"efeito seletor" de cada vez, e as animacoes so tocam quando o seu seletor esta activo.

**Versao 0.3.0** - so punhos (unarmed): Padrao (MCO) / Unarmed Moveset / Brawler (For Honor).
O menu de escolha sera o **KHA-OS** (plugin SKSE, estilo RunicWheel) - em desenvolvimento.
Ate la, o estilo escolhe-se pela consola (abaixo).

## Compilar (GitHub)
1. Envie esta pasta para o repositorio (incluindo `.github`).
2. Separador **Actions** > "Build AnimStanceLE" > **Run workflow** (ou faca um commit).
3. Com o visto verde, descarregue o artefacto **AnimStanceLE** (zip) e instale-o no MO2 como um mod,
   **por baixo** do Unarmed Moveset e do Brawler.

Nao ha compilacao de scripts: o plugin e gerado por `tools/make_esp.py` e o workflow so confirma que o
`Data/AnimStanceLE.esp` versionado e igual ao gerado, e empacota.

## Conteudo
- `Data/AnimStanceLE.esp` - plugin: 3 efeitos seletores (`xx000800`-`xx000802`) e 3 habilidades (`xx000810`-`xx000812`).
- `Data/meshes/...` - os `config.json` do OAR com a condicao do seletor (Unarmed Moveset = seletor 1, Brawler = seletor 2).
- `tools/make_esp.py` - gerador do plugin; `tools/package.py` - monta o zip final.
- `legacy/mcm/` - o MCM antigo (v0.2.0), guardado e fora do build.

## Uso no jogo (provisorio, por consola)
`xx` e o indice do AnimStanceLE.esp na ordem de carga (descubra com `help "AnimStance" 4`).
- Estilo 1 (Unarmed Moveset): `player.addspell xx000810`
- Estilo 2 (Brawler): `player.addspell xx000811`
- Voltar ao Padrao (MCO): `player.removespell` da habilidade activa. So uma de cada vez.
