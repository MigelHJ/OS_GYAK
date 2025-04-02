# Ellenőrizzük, hogy megadtak-e legalább egy stringet és három fájlnevet
if [ "$#" -lt 4 ]; then
    echo "Hiba: Legalább egy szöveget és három fájlnevet kell megadni."
    exit 1
fi

# Az első paraméter a keresett szöveg
search_string="$1"
shift  # Az első paramétert levesszük, a maradék a fájlnevek listája

# Ellenőrizzük a fájlokat
valid_files=()
for file in "$@"; do
    if [ ! -e "$file" ]; then
        echo "Figyelmeztetés: A fájl '$file' nem létezik."
    elif [ ! -f "$file" ]; then
        echo "Figyelmeztetés: '$file' nem egy normál fájl."
    elif [ ! -r "$file" ]; then
        echo "Figyelmeztetés: A fájl '$file' nem olvasható."
    else
        valid_files+=("$file")
    fi
done

# Ha nincs egyetlen érvényes fájl sem, kilépünk
if [ "${#valid_files[@]}" -eq 0 ]; then
    echo "Hiba: Nincs feldolgozható fájl."
    exit 1
fi

# Összesítő változók
matching_lines_total=0
at_least_twice_total=0
exactly_twice_total=0
only_twice_total=0

# Fájlok feldolgozása
for file in "${valid_files[@]}"; do
    # Számláljuk a teljes egyezéseket
    matching_lines=$(grep -c "^$search_string$" "$file" || echo 0)
    echo "A(z) '$file' fájlban $matching_lines sor egyezik pontosan."
    matching_lines_total=$((matching_lines_total + matching_lines))
    
    # Kétszer vagy többször tartalmazó sorok száma
    at_least_twice=$(grep -E "(^| )$search_string( |$)" "$file" | awk '{n=0; for(i=1;i<=NF;i++) if($i=="'"$search_string"'") n++; if(n>=2) print}' | wc -l)
    echo "A(z) '$file' fájlban $at_least_twice sor tartalmazza legalább kétszer a keresett szöveget."
    at_least_twice_total=$((at_least_twice_total + at_least_twice))
    
    # Pontosan kétszer tartalmazó sorok száma
    exactly_twice=$(grep -E "(^| )$search_string( |$)" "$file" | awk '{n=0; for(i=1;i<=NF;i++) if($i=="'"$search_string"'") n++; if(n==2) print}' | wc -l)
    echo "A(z) '$file' fájlban $exactly_twice sor tartalmazza pontosan kétszer a keresett szöveget."
    exactly_twice_total=$((exactly_twice_total + exactly_twice))
    
    # Pontosan kétszer és csak ezt tartalmazó sorok száma
    only_twice=$(grep -E "^$search_string $search_string$" "$file" | wc -l)
    echo "A(z) '$file' fájlban $only_twice sor tartalmazza pontosan kétszer a keresett szöveget és mást nem."
    only_twice_total=$((only_twice_total + only_twice))

done

# Összesítés kiírása
echo "\nÖsszesítés:"
echo "Összes egyező sor: $matching_lines_total"
echo "Összes sor, amelyben legalább kétszer szerepel a keresett szöveg: $at_least_twice_total"
echo "Összes sor, amely pontosan kétszer tartalmazza a keresett szöveget: $exactly_twice_total"
echo "Összes sor, amely csak kétszer tartalmazza a keresett szöveget: $only_twice_total"
