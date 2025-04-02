#!/bin/bash

# Ellenőrizzük, hogy van-e megadott fájl
if [ $# -eq 0 ]; then
    echo "Nem adtál meg fájlt!"
    exit 1
fi

# Bekérjük a keresett sztringet
echo "Adjon meg egy stringet: "
read szo

# Ellenőrizzük, hogy a bekért string nem üres-e
if [ -z "$szo" ]; then
    echo "A megadott string üres!"
    exit 1
fi

# Segédváltozók az összesítéshez
ossz=0
osszl2=0
osszp2=0
i=0

# Fájlok feldolgozása
for fn in "$@"; do
    # Hibakezelés
    if [ ! -f "$fn" ]; then
        echo "A fájl '$fn' nem létezik, vagy nem sima fájl!"
        continue
    fi
    if [ ! -r "$fn" ]; then
        echo "A fájl '$fn' nem olvasható!"
        continue
    fi

    echo "A(z) '$fn' vizsgálata:"

    # Sorok számlálása, amelyek tartalmazzák a keresett stringet
    a=$(grep -c "$szo" "$fn")
    echo "A keresett string előforduló sorainak száma: $a"
    ((ossz+=a))

    # Sorok számlálása, amelyekben legalább kétszer szerepel a string
    b=$(grep -E "$szo.*$szo" "$fn" | wc -l)
    echo "A keresett string legalább kétszeri előfordulása: $b"
    ((osszl2+=b))

    # Sorok számlálása, amelyekben pontosan kétszer szerepel a string
    lketszer=$(grep -E "$szo.*$szo" "$fn" | wc -l)
    lharomszor=$(grep -E "$szo.*$szo.*$szo" "$fn" | wc -l)
    c=$((lketszer - lharomszor))
    echo "A keresett string pontosan kétszeri előfordulása: $c"
    ((osszp2+=c))

    # Fájl teljes egyezés vizsgálata
    if [ "$(cat "$fn")" == "$szo" ]; then
        ((i+=1))
    fi
done

# Összesítések kiírása
echo "Összes előfordulás: $ossz"
echo "Összes sor, ahol legalább kétszer szerepel: $osszl2"
echo "Összes sor, ahol pontosan kétszer szerepel: $osszp2"
echo "Teljes egyező fájlok száma: $i"
