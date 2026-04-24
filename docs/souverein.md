# Hoe jij nu souverein bent

- [] Introductie
- [] Wat is een netwerk
- [] Jouw data prive en souverein
- [] Voorbeelden van wat je met deze vaardigheden kan draaien
- [] De volgende stap: een server


Je kent nu de [basis van containers](./container.md), maar welke rol speelt dit precies in jouw digitale souvereiniteit? Hiermee bedoelen we je digitale onafhankelijkheid van andere partijen. Denk hierbij aan bedrijven zoals Google, Microsoft en Apple. Om dit te begrijpen kijken we naar een aantal elementen.

## Netwerken (Het intercom systeem)
We houden voor dit hoofdstuk de gelijkenis van een school aan. Elke container zit in zijn eigen lokaal met de deur dicht. Dat is veilig. Maar de docent (applicatie) moet wel cijfers kunnen opvragen bij de administratie (database). Docker legt hiervoor automatisch een intercomsysteem aan. In plaats van een ingewikkeld telefoonnummer, hoeft de web-container alleen maar te roepen naar 'db' om de database te bereiken.

Wanneer je meerdere containers samen opzet in een docker compose zoals [hier benoemd](./container.md#stap-7-meerdere-containers-combineren-met-docker-compose) zullen je containers in hetzelfde netwerk komen. Simpel gezegd, ze zullen toegang hebben tot elkaars intercom luidsprekers, omdat ze in dezelfde zones zitten.

