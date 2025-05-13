# ZH gyakorlás

## Hozd létre a skeleton könyvtárat és abban a config.txt fájlt:
mkdir -p skeleton
skeleton/config.txt

## Futatthatóvá tétel:
chmod +x fájlnév.sh

## Gyakorlás
```bash
=== Konstansok ===
USER_PREFIX="user"
USER_START=1
USER_END=20
SKELETON_DIR="skeleton"
CONFIG_FILE="config.txt"

=== Hibaellenőrzés a paraméterekre ===
if [ $# -ne 1 ]; then
    echo "Hiba: A program pontosan egy paramétert vár. Használat: $0 kioszt"
    exit 1
fi

if [ "$1" != "kioszt" ]; then
    echo "Hiba: Ismeretlen művelet: '$1'. Csak a 'kioszt' művelet támogatott."
    exit 1
fi

=== Kérje be a kezdő és befejező sorszámokat ===
read -p "Add meg a kezdő felhasználó sorszámát (AA): " AA
read -p "Add meg a befejező felhasználó sorszámát (BB): " BB

=== Ellenőrzés: számok-e, és a tartományon belül vannak-e ===
if ! [[ "$AA" =~ ^[0-9]+$ ]] || ! [[ "$BB" =~ ^[0-9]+$ ]]; then
    echo "Hiba: AA és BB csak pozitív egész számok lehetnek."
    exit 1
fi

if [ "$AA" -lt $USER_START ] || [ "$BB" -gt $USER_END ] || [ "$AA" -gt "$BB" ]; then
    echo "Hiba: AA és BB értékei $USER_START és $USER_END közé kell essenek, és AA ≤ BB."
    exit 1
fi

 === Ellenőrzés: létezik-e a skeleton/config.txt ===
if [ ! -f "$SKELETON_DIR/$CONFIG_FILE" ]; then
    echo "Hiba: A '$SKELETON_DIR/$CONFIG_FILE' fájl nem található."
    exit 1
fi

=== Könyvtárak létrehozása, ha nem léteznek ===
for i in $(seq -f "%02g" $USER_START $USER_END); do
    dir="${USER_PREFIX}${i}"
    if [ ! -d "$dir" ]; then
        mkdir "$dir"
    fi
done

=== Kiosztás ===
for i in $(seq -f "%02g" $AA $BB); do
    user_dir="${USER_PREFIX}${i}"
    cp "$SKELETON_DIR/$CONFIG_FILE" "$user_dir/"
    echo "Kiosztva: $CONFIG_FILE → $user_dir/"
done

echo "A konfigurációs fájl kiosztása sikeresen megtörtént."
```

### A program kezeljen még egy műveletet torol néven. A program a kioszt művelethez hasonlóan bekér az intervallum elejét végét és kiosztott fájlt, fájlokat törli. A program minden felhasználónál írja ki, hogy fájlokat törlőt.
```bash
# === TOROL művelet ===
elif [ "$1" == "torol" ]; then
    for i in $(seq -f "%02g" $AA $BB); do
        user_dir="${USER_PREFIX}${i}"
        file_path="$user_dir/$CONFIG_FILE"
        if [ -f "$file_path" ]; then
            rm "$file_path"
            echo "Törölve: $file_path"
        else
            echo "Nincs mit törölni: $file_path nem létezik"
        fi
    done
    echo "A konfigurációs fájl(ok) törlése befejeződött."
fi
```

### A program ne csak a config.txt fájllal foglalkozzon hanem a skeleton könyvtárban lévő egyéb fájlokkal is. A müködésének nem kell rekurzívnak lennie. Ennek a feladtrésznek a teszteléséhez a skeleton könyvtárban ell kell helyezni még néhány teszt fájlt. Ezek neve tartalma tetszőleges
```bash
# === Konstansok ===
USER_PREFIX="user"
USER_START=1
USER_END=20
SKELETON_DIR="skeleton"

# === Hibaellenőrzés a paraméterekre ===
if [ $# -ne 1 ]; then
    echo "Hiba: A program pontosan egy paramétert vár. Használat: $0 [kioszt|torol]"
    exit 1
fi

if [ "$1" != "kioszt" ] && [ "$1" != "torol" ]; then
    echo "Hiba: Ismeretlen művelet: '$1'. Csak a 'kioszt' vagy 'torol' támogatott."
    exit 1
fi

# === Kérje be a kezdő és befejező sorszámokat ===
read -p "Add meg a kezdő felhasználó sorszámát (AA): " AA
read -p "Add meg a befejező felhasználó sorszámát (BB): " BB

# === Ellenőrzés: számok-e, és a tartományon belül vannak-e ===
if ! [[ "$AA" =~ ^[0-9]+$ ]] || ! [[ "$BB" =~ ^[0-9]+$ ]]; then
    echo "Hiba: AA és BB csak pozitív egész számok lehetnek."
    exit 1
fi

if [ "$AA" -lt $USER_START ] || [ "$BB" -gt $USER_END ] || [ "$AA" -gt "$BB" ]; then
    echo "Hiba: AA és BB értékei $USER_START és $USER_END közé kell essenek, és AA ≤ BB."
    exit 1
fi

# === Ellenőrzés: létezik-e a skeleton könyvtár, és vannak-e benne fájlok ===
if [ ! -d "$SKELETON_DIR" ]; then
    echo "Hiba: A '$SKELETON_DIR' könyvtár nem létezik."
    exit 1
fi

FILES=("$SKELETON_DIR"/*)
if [ ${#FILES[@]} -eq 0 ]; then
    echo "Hiba: A '$SKELETON_DIR' könyvtár üres, nincs mit kiosztani/törölni."
    exit 1
fi

# === Könyvtárak létrehozása, ha nem léteznek ===
for i in $(seq -f "%02g" $USER_START $USER_END); do
    dir="${USER_PREFIX}${i}"
    if [ ! -d "$dir" ]; then
        mkdir "$dir"
    fi
done

# === Műveletek ===
if [ "$1" == "kioszt" ]; then
    for i in $(seq -f "%02g" $AA $BB); do
        user_dir="${USER_PREFIX}${i}"
        for file in "$SKELETON_DIR"/*; do
            if [ -f "$file" ]; then
                cp "$file" "$user_dir/"
                echo "Kiosztva: $(basename "$file") → $user_dir/"
            fi
        done
    done
    echo "Fájlok kiosztása sikeresen megtörtént."

elif [ "$1" == "torol" ]; then
    for i in $(seq -f "%02g" $AA $BB); do
        user_dir="${USER_PREFIX}${i}"
        for file in "$SKELETON_DIR"/*; do
            if [ -f "$file" ]; then
                target_file="$user_dir/$(basename "$file")"
                if [ -f "$target_file" ]; then
                    rm "$target_file"
                    echo "Törölve: $target_file"
                else
                    echo "Nincs mit törölni: $target_file nem létezik"
                fi
            fi
        done
    done
    echo "Fájl(ok) törlése befejeződött."
fi
```

Használata: ./felhasznalok.sh kioszt    ./felhasznalok.sh torol

### A program kezeljen még egy műveletet ures néven. Ennek választása esetén a program ellenőrizze hogy a kiválasztott felhasználói könyvtárak üresek-e

```bash
# === Művelet: URES ===
elif [ "$1" == "ures" ]; then
    for i in $(seq -f "%02g" $AA $BB); do
        user_dir="${USER_PREFIX}${i}"
        if [ ! -d "$user_dir" ]; then
            echo "$user_dir nem létezik."
        elif [ -z "$(ls -A "$user_dir")" ]; then
            echo "$user_dir üres."
        else
            echo "$user_dir nem üres."
        fi
    done
fi
```

### A program kezeljen még egy műveletet extra néven. Ennek a választása esetén a program ellenőrizze , hogy a kiválasztott felhasználói könyvtárakban van-e olyan fájl ami a skeletonban nem szerepel. A program írja ki az extra fájlok nevét

```bash
# === Művelet: EXTRA ===
elif [ "$1" == "extra" ]; then
    if [ ! -d "$SKELETON_DIR" ]; then
        echo "Hiba: A skeleton könyvtár nem található."
        exit 1
    fi

    # Skeleton fájlnevek listába
    declare -A skeleton_files
    for file in "$SKELETON_DIR"/*; do
        [ -f "$file" ] && skeleton_files["$(basename "$file")"]=1
    done

    for i in $(seq -f "%02g" $AA $BB); do
        user_dir="${USER_PREFIX}${i}"
        if [ ! -d "$user_dir" ]; then
            echo "$user_dir nem létezik."
            continue
        fi

        extra_found=0
        for user_file in "$user_dir"/*; do
            if [ -f "$user_file" ]; then
                base_name=$(basename "$user_file")
                if [[ -z "${skeleton_files[$base_name]}" ]]; then
                    if [ $extra_found -eq 0 ]; then
                        echo "Extra fájlok $user_dir könyvtárban:"
                        extra_found=1
                    fi
                    echo "  - $base_name"
                fi
            fi
        done

        if [ $extra_found -eq 0 ]; then
            echo "Nincsenek extra fájlok a $user_dir könyvtárban."
        fi
    done
fi
```

### A program kezeljen műveleteken kívül további tetszőlegesen sok paramétert is. Ezek felhasználók könyvtárai. Ebben az esetben ezekkel dolgozzon és ne kérje be az intervallum első és utolsó elemét.

```bash
# === Felhasználói könyvtárak listájának előkészítése ===
user_dirs=()

if [ $# -eq 0 ]; then
    # Kérje be AA és BB-t ha nem adtunk meg felhasználókat
    read -p "Add meg a kezdő felhasználó sorszámát (AA): " AA
    read -p "Add meg a befejező felhasználó sorszámát (BB): " BB

    if ! [[ "$AA" =~ ^[0-9]+$ ]] || ! [[ "$BB" =~ ^[0-9]+$ ]]; then
        echo "Hiba: AA és BB csak pozitív egész számok lehetnek."
        exit 1
    fi

    if [ "$AA" -lt $USER_START ] || [ "$BB" -gt $USER_END ] || [ "$AA" -gt "$BB" ]; then
        echo "Hiba: AA és BB értékei $USER_START és $USER_END közé kell essenek, és AA ≤ BB."
        exit 1
    fi

    for i in $(seq -f "%02g" $AA $BB); do
        user_dirs+=("${USER_PREFIX}${i}")
    done
else
    # A felhasználói könyvtárakat a parancssor adja meg
    user_dirs=("$@")
fi
```
