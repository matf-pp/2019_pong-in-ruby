# Pong in Ruby
## Projekat u okviru kursa Programske paradigme

![ruby](https://img.shields.io/badge/language-Ruby-%23ed314a.svg)
![OpenGL](https://img.shields.io/badge/library%20-OpenGL-red.svg)

![alt text](pong.png?raw=true "Ilustracija projekta - igra Pong")

## :pencil2: Opis projekta

Ideja projekta je implementacija jedne od najstarijih arkadnih igrica - Pong.
Igrica će biti napravljena za dva igrača, a programirana u  programskom jeziku Ruby, na uredjaju RaspberryPI3.
Implementacija GUI-ja je izvršena pomoću biblioteke OpenGl.
(https://www.opengl.org/)

## :video_game: Komande 

Za pomeranje bi bili korišćeni džojstici koji se povezuju na uredjaj preko USB-a (kao emulatori Serijskog porta) i oni predstavljaju ulazne podatke o pozicijama oba igraca. Svaki igrač bi mogao da se pomera gore-dole u rasponu visine prozora, sa ciljem da lopticu prebaci na protivnikovu stranu.
Ono što bi razlikovalo igricu od originalne bi bila i mogućnost pomeranja pravougaonika levo-desno u rasponu od jedne ivice do polovine ekrana kako ne bi mogli preći na starnu protivnika. 
Pobednik partije bi bio igrač koji prvi ostvari 3 poena. 

## Instalacija i pokretanje

Potrebno je pokrenuti ./install.sh skript sa sudo privilegijama koji ce instalirati sve sto je potrebno. Nakon toga, igrica se moze pokrenuti sa ruby pongOnRuby.rb
