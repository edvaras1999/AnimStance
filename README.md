# AnimStanceLE

Seletor de estilos de animacao (OAR/DAR via Themis) para Skyrim LE 1.9.32.
Cada estilo e um conjunto de animacoes que disputa a mesma condicao. O mod activa um
"efeito seletor" de cada vez, e as animacoes so tocam quando o seu seletor esta activo.

**Versao 0.2.0** - so punhos (unarmed): Padrao (MCO) / Unarmed Moveset / Brawler (For Honor).

## Como compilar (GitHub)
1. Envie esta pasta para o repositorio (Add file > Upload files, arrastando as pastas, incluindo `.github`).
2. Separador **Actions** > "Compilar AnimStanceLE" > **Run workflow** (ou faca um commit).
3. Quando terminar (visto verde), abra a execucao e descarregue o artefacto **AnimStanceLE** (zip).
4. Instale o zip no MO2 como um mod, **por baixo** do Unarmed Moveset e do Brawler.

Se a compilacao falhar, copie o texto vermelho do passo "Compilar ASL_MCM.psc".

## Conteudo
- `Source/Scripts/ASL_MCM.psc` - script do menu MCM e da tecla.
- `Stubs/` - copias minimas dos scripts do jogo e do SkyUI, so para compilar (nao vao no mod).
- `Data/AnimStanceLE.esp` - plugin (efeitos seletores + quest do MCM).
- `Data/meshes/...` - os `config.json` do OAR com a condicao do seletor (Unarmed Moveset = seletor 1, Brawler = seletor 2).
- `tools/package.py` - monta o zip final; `tools/make_esp.py` - gerador do plugin (referencia).

## Uso no jogo
MCM > AnimStance: escolher o estilo, a tecla de alternar, o aviso e o idioma (PT/EN).
A tecla so funciona com a mao direita vazia.
