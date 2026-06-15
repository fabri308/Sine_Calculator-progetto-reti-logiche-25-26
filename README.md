# Fixed-Point Sine Calculator

**Progetto di Reti Logiche**
**Autore:** Fabrizio Giacona
**Target:** Xilinx Artix-7 (`xc7a35tcpg236-1`) &nbsp;|&nbsp; **Strumento:** AMD Vivado 2025.2

---

## Descrizione

Modulo hardware in VHDL per il calcolo della funzione seno di un angolo espresso in gradi interi (0-359°). Il risultato è prodotto in formato fixed-point Q2.8 con segno (complemento a 2, 10 bit totali). Il calcolo si basa su una look-up table limitata al primo quadrante (0-90°) con interpolazione lineare per gli angoli non direttamente tabulati, e sull'uso delle identità trigonometriche per estendere il risultato agli altri tre quadranti.

## Interfaccia

| Segnale  | Direzione | Larghezza | Descrizione                                  |
|----------|-----------|-----------|----------------------------------------------|
| `CLK`    | in        | 1 bit     | Clock di sistema                             |
| `RESET`  | in        | 1 bit     | Reset sincrono, attivo alto                  |
| `ANGLE`  | in        | 9 bit     | Angolo in gradi, binario naturale (0-359)    |
| `RESULT` | out       | 10 bit    | sin(ANGLE) in formato Q2.8, complemento a 2 |

**Formato Q2.8:** 1 bit di segno, 1 bit di parte intera, 8 bit di parte frazionaria.
Esempio: `0_0_00100011` = +0.13671875.

**Latenza pipeline:** 2 cicli di clock. Il fronte N+1 cattura `ANGLE` nel registro di ingresso; la catena combinatoria si assesta; il fronte N+2 cattura il risultato nel registro di uscita.

## Architettura

Il sistema è interamente strutturale. Nessun operatore aritmetico è inferenziato dal sintetizzatore: ogni somma, sottrazione e moltiplicazione è realizzata istanziando esplicitamente componenti `FULL_ADDER` e `ADD_SUB_N`. I registri sono presenti esclusivamente sugli ingressi e le uscite primarie del top-level; tutti i moduli interni sono puramente combinatori.

### Gerarchia dei componenti

```
SINE_FUNCTION  (top-level)
├── PPREGISTER_N        (registro ingresso su ANGLE)
├── QUADRANT_NORMALIZER (riduzione al I quadrante)
│   └── ADD_SUB_N
│       └── FULL_ADDER
├── UPPER_LOWER_ANGLE   (estrazione bit LOWER_ANGLE e DELTA)
├── INTERPOLATOR        (interpolazione lineare strutturale)
│   ├── LUT  (x2, lookup simultaneo di sin_lower e sin_upper)
│   └── ADD_SUB_N  (più istanze per prodotto parziale e shift)
│       └── FULL_ADDER
├── SIGN_CORRECTOR      (negazione condizionale in complemento a 2)
│   └── ADD_SUB_N
│       └── FULL_ADDER
└── PPREGISTER_N        (registro uscita su RESULT)
```

### Descrizione dei moduli

**`FULL_ADDER`** — Full adder a 1 bit. Blocco atomico da cui derivano tutti gli operatori aritmetici del progetto.

**`ADD_SUB_N`** — Sommatore/sottrattore ripple-carry generico a N bit. Il pin `S` seleziona la modalità (0 = somma, 1 = sottrazione) e funge contemporaneamente da carry-in per la negazione XOR degli operandi. Generic `N` di tipo `positive`.

**`PPREGISTER_N`** — Registro parallelo-parallelo generico a N bit con reset sincrono. Unico componente del progetto che utilizza `CLK`; istanziato solo al confine di ingresso (`ANGLE`) e di uscita (`RESULT`) del top-level.

**`QUADRANT_NORMALIZER`** — Riduce l'angolo di ingresso (0-359°) all'intervallo 0-90°. Determina il quadrante confrontando `ANGLE` con le soglie 90, 180, 270 mediante sottrazioni con `ADD_SUB_N`: il carry-out `COUT=1` indica che l'angolo supera la soglia (confronto unsigned corretto). L'operando di sottrazione è selezionato tramite `with...select` sul codice di quadrante. Produce inoltre il flag `NEGATIVE` per il modulo a valle.

**`LUT`** — Look-up table a 14 ingressi contenente i valori Q2.8 di sin(x) per x ∈ {0°, 8°, 16°, …, 88°, 89°, 90°}. I valori sono ottenuti come `round(sin(x) × 256)`. Implementata con costrutto `case` in un singolo processo combinatorio. Le due uscite `SIN_LOWER` e `SIN_UPPER` sono prodotte da due istanze distinte per consentire il lookup simultaneo nell'interpolatore.

**`UPPER_LOWER_ANGLE`** — Estrae dal valore normalizzato i due campi: `LOWER_ANGLE` (i 7 bit più significativi, multiplo di 8 più vicino per difetto) e `DELTA` (i 3 bit meno significativi, resto della divisione per 8). Realizzato tramite slice sui bit di ingresso.

**`INTERPOLATOR`** — Calcola `sin_lower + (delta × (sin_upper - sin_lower)) >> 3` in aritmetica strutturale. Il prodotto parziale `delta × DIFF` (Q5.8) viene calcolato prima dello shift aritmetico di 3 posizioni per evitare perdita di precisione; lo shift riporta il risultato in Q2.8. Utilizza due istanze di `LUT` per leggere simultaneamente `sin_lower` e `sin_upper`.

**`SIGN_CORRECTOR`** — Applica la negazione in complemento a 2 quando `NEGATIVE='1'` (II e III quadrante). Realizzato con `ADD_SUB_N` con operando A=0 e pin S=NEGATIVE.

### Algoritmo

1. Il registro di ingresso (`PPREGISTER_N`) cattura `ANGLE` sul fronte di salita del clock.
2. `QUADRANT_NORMALIZER` calcola l'angolo nel I quadrante e il flag `NEGATIVE`.
3. `UPPER_LOWER_ANGLE` estrae `LOWER_ANGLE` e `DELTA`.
4. `INTERPOLATOR` calcola il seno interpolato in Q2.8.
5. `SIGN_CORRECTOR` applica il segno.
6. Il registro di uscita (`PPREGISTER_N`) cattura `RESULT` sul fronte successivo.

## Vincoli progettuali

Secondo le indicazioni del laboratorio:

- Nessuna inferenziazione di operatori aritmetici o relazionali (eccezione: uguaglianza). Tutti gli operatori sono progettati esplicitamente.
- Registri esclusivamente sui segnali di ingresso e uscita primari; nessun registro interno.
- Massimo riuso del codice mediante i costrutti `generic` e `generate`.
- La simulazione finale deve essere eseguita sul modello Post Place & Route.
- Il periodo di clock deve essere stimato dai risultati di sintesi e verificato stimolando il critical path nel testbench.

## Verifica e simulazione

Il testbench copre le seguenti categorie di ingresso:

- Angoli direttamente tabulati nella LUT (multipli di 8°, 89°, 90°).
- Angoli che richiedono interpolazione lineare (e.g., 1°, 40°, 45°).
- Angoli di confine tra quadranti (90°, 180°, 270°, 359°).
- Angoli a segno negativo (II e III quadrante: 91°-269°).
- Fronte di reset: verifica del corretto azzeramento dei registri.

Il file di riferimento `sine_reference.txt` (360 valori Q2.8 generati via Python) è usato nel testbench per il confronto automatico delle uscite. La latenza di 2 cicli è tenuta in conto nell'allineamento degli stimoli con i risultati attesi.

La simulazione finale valida è esclusivamente quella Post Place & Routec, ome da requisito del corso.

## Timing

Il critical path attraversa `QUADRANT_NORMALIZER` e `INTERPOLATOR`.

| Parametro             | Valore                     |
|-----------------------|----------------------------|
| Target device         | xc7a35tcpg236-1 (Artix-7)  |
| Clock period (target) | 5 ns (200MHz)              |
| Pipeline depth        | 2 cicli di clock           |

## Struttura del repository

```
src/
├── FULL_ADDER.vhd
├── ADD_SUB_N.vhd
├── PPREGISTER_N.vhd
├── QUADRANT_NORMALIZER.vhd
├── LUT.vhd
├── UPPER_LOWER_ANGLE.vhd
├── INTERPOLATOR.vhd
├── SIGN_CORRECTOR.vhd
└── SINE_FUNCTION.vhd
tb/
├── SINE_FUNCTION_TB.vhd
└── sine_reference.txt
constraints/
└── timing.xdc
```
