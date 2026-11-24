# mie-skills

Le mie skill per Claude Code, in un unico posto versionato, così non vanno
ricaricate a mano a ogni sessione cloud (che è effimera).

## Installazione (un comando)

```bash
git clone https://github.com/<TUO-USER>/mie-skills.git
cd mie-skills
./setup.sh            # scope utente: ~/.claude/skills (consigliato)
```

Poi avvia una nuova sessione Claude Code. Per lo scope progetto: `./setup.sh .`

Per aggiornare: `git pull` dentro la cartella. I symlink puntano già al repo,
quindi le modifiche sono immediate (basta ricaricare la sessione).

## Cosa c'è dentro

| Skill | Cosa fa | Provenienza | Note |
|-------|---------|-------------|------|
| `markitdown` | Converte file/documenti (PDF, DOCX, PPTX, XLSX, immagini OCR, audio, YouTube…) in Markdown | Microsoft markitdown, SKILL.md di K-Dense Inc. | **Versione ripulita**: rimossi l'upsell a k-dense.ai e la generazione forzata di diagrammi AI presenti nell'originale. Richiede il tool `markitdown` (`pip install 'markitdown[all]'`). |
| `campaign-launcher-oss` | Orchestratore campagne multi-canale (Meta Ads + email outreach) | `tekliner/improvado-agentic-frameworks-and-skills` | Esegue azioni reali (spende budget, invia email). Richiede credenziali e sblocco rete. Vedi sotto. |
| `grill-me` | Alias manuale (`/grill-me`) → richiama `grilling` | `mattpocock/skills` | `disable-model-invocation: true`, parte solo esplicito. |
| `grilling` | Ti interroga a fondo per stress-testare un piano/decisione (design tree, round di domande) | `mattpocock/skills` | Si attiva sulle frasi "grill…". |
| `find-skills` | Scopre e installa altre skill dall'ecosistema (skills.sh) con criteri di qualità | `vercel-labs/skills` | Non installerà nulla senza mostrartelo prima. |

## Note operative

### markitdown
Il tool va installato nell'ambiente (`pip install 'markitdown[all]'`). L'OCR su
scansioni richiede `tesseract`. Le descrizioni AI delle immagini richiedono una
API key e accesso di rete al provider — non servono per la conversione testuale.

### campaign-launcher-oss
Fa partire campagne vere. Prima di usarlo serve:
- **Rete**: sbloccare gli host dei canali usati (es. `graph.facebook.com`,
  `api.lemlist.com`). In cloud si fa dai settings dell'environment.
- **Credenziali**: token Meta + ID account/pagina/pixel; API key del provider email.
- Il file di config va in `campaign-launcher.yaml` nella root del progetto
  (vedi `skills/campaign-launcher-oss/config/config.example.yaml`).

Consiglio: come **launcher** gira meglio su una macchina stabile, non in un
container cloud effimero (le credenziali che spendono soldi/mandano email non
dovrebbero vivere su ambienti usa-e-getta).

## Aggiungere una skill nuova

1. Metti la cartella in `skills/<nome>/` (con un `SKILL.md`).
2. `git add . && git commit -m "add <nome>"`
3. Ri-lancia `./setup.sh` (o aspetta: se è già collegata, il symlink la prende).
