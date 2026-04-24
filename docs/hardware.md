# Minimale vereisten voor Docker Desktop

:contentReference[oaicite:0]{index=0} vereist een aantal hardware- en softwarevoorwaarden om correct te functioneren. Hieronder vind je de minimale vereisten per platform.

---

## Windows

### Minimale vereisten
- **Besturingssysteem:**
  - Windows 10 64-bit (Pro, Enterprise of Education)
  - Windows 11 64-bit
- **Processor:**
  - 64-bit CPU met SLAT-ondersteuning (Second Level Address Translation)
- **Virtualisatie:**
  - Intel VT-x of AMD-V ingeschakeld in BIOS/UEFI
  - Hyper-V of WSL 2 ondersteuning vereist
- **RAM:**
  - Minimaal 4 GB (8 GB aanbevolen)
- **Opslag:**
  - Minimaal 5 GB vrije schijfruimte (meer aanbevolen)

### Belangrijke opmerkingen
- WSL 2 is de aanbevolen backend op Windows 10/11
- Windows Home ondersteunt Docker Desktop via WSL 2 (niet via Hyper-V)

---

## macOS

### Minimale vereisten
- **Besturingssysteem:**
  - Moderne macOS-versie (bijv. macOS 12 Monterey of nieuwer)
- **Hardware:**
  - Intel Mac of Apple Silicon (M1/M2/M3)
- **RAM:**
  - Minimaal 4 GB (8 GB+ aanbevolen)
- **Opslag:**
  - Minimaal 5 GB vrije ruimte

### Belangrijke opmerkingen
- Draait via een ingebouwde lightweight VM (HyperKit of Apple Virtualization Framework)

---

## Linux

### Minimale vereisten
- **OS:**
  - 64-bit Linux distributie (bijv. Ubuntu, Debian, Fedora)
- **Virtualisatie:**
  - KVM ondersteuning vereist (hardware virtualisatie aan)
- **Systeem:**
  - systemd vereist
- **RAM:**
  - Minimaal 4 GB

---

## ⚙️ Algemene vereisten (alle platforms)

- 64-bit CPU (geen 32-bit ondersteuning)
- Hardware virtualisatie moet ingeschakeld zijn
- Moderne OS-versie (recent ondersteund)
- Administrator/root rechten voor installatie

---

## Praktisch advies

Hoewel de minimumvereiste 4 GB RAM is, is dit in de praktijk vaak onvoldoende voor development workloads.

**Aanbevolen configuratie:**
- 8 GB RAM (minimum bruikbaar)
- 16 GB RAM of meer (comfortabel voor meerdere containers)