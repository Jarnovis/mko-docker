# Docker-container draaien met Docker Desktop

---

## Inleiding

Dit stappenplan helpt je om een Docker-container te starten met Docker Desktop. Een container is als een afgesloten doos waarin een programma draait, zonder dat het je computer beïnvloedt.

Vergelijk het met een *tijdelijk ingericht vaklokaal*: je richt het in, gebruikt het, en ruimt het daarna op zonder dat de rest van de school er iets van merkt.

Je leert hier hoe je een webserver (nginx) start, zodat je zelf een website kunt draaien op je eigen laptop.

---

## Wat heb je nodig?

- Een computer met [Docker Desktop](https://www.docker.com/products/docker-desktop) geïnstalleerd.
- Internetverbinding om een **image** (sjabloon) te downloaden.
- Een webbrowser (Chrome, Firefox, Edge).

![Windows icoon](images/container/container_windows_icoon.png) ![Mac icoon](images/container/container_macOS_icoon.png) ![Gratis downloaden](images/container/container_gratistedownloaden.png)

---

## Stap 1: Docker Desktop starten

Open Docker Desktop via het icoon op je bureaublad of in de taakbalk. Het icoon is een **walvis** (icoon).
Als de walvis beweegt, is Docker actief. Staat hij stil? Klik erop om Docker te starten.

> [!NOTE]
> Docker Desktop is de **gereedschapskist van de conciërge**. Zolang de kist open is, kun je aan de slag.

---

## Stap 2: Wat is een Image en wat is een Container?

**Image = "een werkblad"** 
Een Image (sjabloon) is een afgesloten werkblad dat je kan gebruiken om een container te maken.

> [!NOTE]
> Een Image is een gekopieerd werkblad dat nog niet is ingevuld. Het origineel ligt in de kast. Je kunt er zoveel kopieën van maken als je wilt, maar het origineel verandert nooit."

**Container = "een ingevuld werkblad"**
Een **Container** is een werkende versie van de Image. Het is als het ingevulde werkblad van een leerling. De leerling kan het werkblad invullen, gebruiken en weer weggooien. Als het werkblad kwijt is, druk je gewoon een nieuwe kopie af. Het origineel in de kast blijft altijd beschikbaar.

> "Schoolse vergelijking:
> Een leerling pakt een werkblad uit de kast, vult het in, en gebruikt het tijdens de les. Dat ingevulde werkblad is de Container. Als de les klaar is, gooit de leerling het werkblad weg. Morgen begint hij of zij weer met een schoon, nieuw werkblad."

> [!IMPORTANT]
> - Een **Image** (sjabloon) is een kant-en-klaar bestand met alles wat nodig is om een programma te draaien; je kunt er niets mee doen totdat je er een container van start.
> - Een **Container** is de werkende versie. Stop je hem, dan is de inhoud weg — tenzij je een **volume** gebruikt (zie Stap 8).

## Stap 3: Een Image downloaden via Docker Hub

Een Image haal je op via ![**Docker Hub**](https://hub.docker.com/): een online bibliotheek met duizenden kant-en-klare sjablonen voor programma's.

1. Klik in Docker Desktop op **Search** (bovenaan).
2. Typ `nginx` in de zoekbalk en druk op Enter.
3. Klik op **Pull** naast de nginx-image.
4. Wacht tot het downloaden klaar is.

Via de terminal:
```docker pull nginx```

> [!NOTE]
> Dit is zoals een methode bestellen in de schoolcatalogus. Je kiest het boek, het wordt bezorgd, en daarna kun je er zoveel lessen mee draaien als je wilt."

## Stap 4: Een container starten

Nu ga je de nginx-image gebruiken om een container te starten. Deze container wordt een webserver.

1. Ga in Docker Desktop naar het tabblad **Images**.
2. Zoek de nginx-image en klik op de **Play-knop**.
3. Vul het venster in:
    - Container name: `mijn-omgeving`
    - Host port: `8080`
4. Klik op **Run**.

Via de terminal:
```docker run -d -p 8080:80 nginx```

> "Schoolse vergelijking:
> Poort `8080` is de voordeur van het vaklokaal. Via die deur kom je binnen. Je kunt het poortnummer zien als het lokaalnummer op het rooster."

## Stap 5: Je webserver bekijken in de browser

1. Open een webbrowser.
2. Typ in de adresbalk `http://localhost:8080`.
3. Druk op Enter.

Je ziet nu de welkomstpagina van nginx. Je webserver draait in een Docker-container op je eigen laptop/pc en is niet verbonden met de internet.

> [!TIP]
> Controleer of Docker Desktop actief is (walvis beweegt), of je poort `8080` hebt ingevuld, en of je browser up-to-date is."

## Stap 6: De container stoppen en hergebruiken

1. Ga in Docker Desktop naar het tabblad **Containers**.
2. Zoek `mijn-omgeving`
3. Klik op de **Stop-knop** naast de container (vierkantje).

Wil je de container later weer starten? Klik op de **Play-knop** naast de container.

> [!NOTE]
> Een container stoppen is zoals het vaklokaal afsluiten na de les. De stoelen en het meubilair (de image) blijven staan, maar het werk op het bord wordt gewist. Morgen begin je met een nieuw werkblad."

## Stap 7: Meerdere containers combineren met Docker Compose

Wil je een volledige webomgeving draaien, met zowel een website als een database? Dan gebruik je **Docker Compose**: één tekstbestand dat beschrijft welke containers samen moeten draaien.

Maak een bestand aan met de naam `docker-compose.yml`.

```yaml
services:
    web:
        image: nginx
        ports:
            - "8080:80"
    db:
      image: mysql:8
      environment:
        MYSQL_ROOT_PASSWORD: les2026 
```

Start alles op met één commando:
```docker-compose up```

> "Schoolse vergelijking:
> Docker Compose is het lesrooster. Het rooster bepaalt welke docenten (containers) op welk moment in welk lokaal (poort) aanwezig zijn en hoe ze samenwerken. Jij schrijft het rooster één keer; Docker voert het uit."


## Stap 8: Gegevens bewaren met een volume

Een container is van nature **tijdelijk**: stop je hem, dan is de inhoud weg. Om gegevens te bewaren gebruik je een **volume**: een map op je eigen computer die gekoppeld is aan de container.

Voeg dit toe aan je Compose-bestand, onder de database service:

```yaml
volumes:
    - ./mijn-data:/var/lib/mysql
```

> [!NOTE]
> Zonder volume is je database als een schoolschrift dat je na elke les weggooit. Met een volume sla je het schrift op in een la, de container kan worden opgeruimd en het schrift ligt er nog."
>
> "Gebruik volumes altijd bij databases, leerlinggegevens en back-up systemen."

## Stap 9: Digitale toegankelijkheid WCAG

Sinds 28 juni 2025 geldt de European Accessibility Act (EAA). Digitale omgevingen in het onderwijs moeten voldoen aan de **WCAG 2.1 AA-normen**. Dit geldt ook voor tools die zelf host via Docker.

Door containers **zelf te beheren** ben je niet afhankelijk van externe platforms die jouw leerlinggegevens verwerken. Jij kiest de tools, jij controleert de data, en jij garandeert dat iedere leerling de omgeving kan gebruiken.

> [!NOTE]
> Digitale soevereiniteit is zoals een eigen schooltuin beheren in plaats van groenten kopen bij een supermarkt. Meer werk, maar je weet precies wat erin zit en wie er toegang toe heeft."

## Wat kan Docker wél en niet?

| Docker is geschikt voor                                | Docker is minder geschikt voor                       |
|--------------------------------------------------------|------------------------------------------------------|
| Gestandaardiseerde werkomgeving voor leerlingen        | Dagelijks gebruik door leerlingen zonder begeleiding |
| Zelf hosten van open-source tools (Nextcloud)          | Vervanging van schoolbrede IT infastructuur          |
| Veilig experimenteren zonder je systeem te beschadigen | Complexe netwerkomgevingen zonder IT begeleiding     |
| Back-up systemen en databases lokaal draaien           | Productieomgevingen zonder kennis van beveiliging    |
