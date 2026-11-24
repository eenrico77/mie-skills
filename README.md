# mie-skills

Le mie skill per Claude Code, in un unico posto versionato, così non vanno
ricaricate a mano a ogni sessione cloud (che è effimera).

Setup **ibrido**: le skill personalizzate vivono nel repo (vendored); quelle
pubbliche vengono prese fresche dagli autori a ogni installazione.

## Installazione (un comando)

```bash
git clone https://github.com/<TUO-USER>/mie-skills.git
cd mie-skills
./setup.sh            # scope utente: ~/.claude/skills (consigliato)
```

Poi avvia una nuova sessione Claude Code.

Varianti:
- `./setup.sh .` → scope progetto (`./.claude/skills`)
- `SKIP_EXTERNAL=1 ./setup.sh` → installa solo le vendored (offline / senza rete)

Aggiornare: `git pull` (per le vendored) e ri-lancia `./setup.sh` (ripesca le esterne fresche).

## Cosa c'è dentro

### Vendored — nel repo, collegate via symlink

| Skill | Cosa fa | Provenienza | Note |
|-------|---------|-------------|------|
| `markitdown` | Converte file/documenti (PDF, DOCX, PPTX, XLSX, immagini OCR, audio, YouTube…) in Markdown | Microsoft markitdown, SKILL.md di K-Dense Inc. | **Versione ripulita**: rimossi upsell a k-dense.ai e generazione forzata di diagrammi. Richiede il tool `markitdown` (`pip install 'markitdown[all]'`). |
| `campaign-launcher-oss` | Orchestratore campagne multi-canale (Meta Ads + email outreach) | `tekliner/improvado-agentic-frameworks-and-skills` | Esegue azioni reali (spende budget, invia email). Richiede credenziali + sblocco rete. Vedi sotto. |

Sono vendored perché non hanno una fonte pubblica riproducibile: `markitdown` è
una versione modificata, `campaign-launcher-oss` non è un pacchetto della CLI `skills`.

### Esterne — prese fresche dagli autori a ogni `setup.sh`

| Skill | Cosa fa | Fonte |
|-------|---------|-------|
| `grill-me` | Alias manuale (`/grill-me`) → richiama `grilling` | `mattpocock/skills` |
| `grilling` | Ti interroga a fondo per stress-testare un piano/decisione | `mattpocock/skills` |
| `find-skills` | Scopre e installa altre skill dall'ecosistema (skills.sh) | `vercel-labs/skills` |

Queste **non** sono nel repo: `setup.sh` le installa via `npx skills add`, così
restano sempre aggiornate. Serve rete al momento dell'installazione (usa
`SKIP_EXTERNAL=1` per saltarle).

## Note operative

### markitdown
Il tool va installato nell'ambiente (`pip install 'markitdown[all]'`). L'OCR su
scansioni richiede `tesseract`. Le descrizioni AI delle immagini richiedono una
API key e accesso di rete al provider — non servono per la conversione testuale.

### campaign-launcher-oss
Fa partire campagne vere. Prima di usarlo serve:
- **Rete**: sbloccare gli host dei canali usati (es. `graph.facebook.com`,
  `api.lemlist.com`).
- **Credenziali**: token Meta + ID account/pagina/pixel; API key del provider email.
- Config in `campaign-launcher.yaml` nella root del progetto
  (vedi `skills/campaign-launcher-oss/config/config.example.yaml`).

Come **launcher** gira meglio su una macchina stabile, non in un container cloud
effimero (le credenziali che spendono soldi/mandano email non dovrebbero vivere
su ambienti usa-e-getta).

## Aggiungere una skill

- **Personalizzata/senza fonte pubblica** → mettila in `skills/<nome>/`, committa, ri-lancia `./setup.sh`.
- **Pubblica (CLI skills)** → aggiungi la riga `npx skills add …` in `setup.sh` nella sezione esterne.
