#!/bin/sh
# POSIX script: list N largest files up to max size
# Use: ./files-script.sh <num_files> <max_size>
# Example: ./files-script.sh 10 1G

if [ $# -ne 2 ]; then
    echo "Use: $0 <num_files> <max_size>"
    echo "Example: $0 10 1G"
    exit 1
fi

NUM="$1"
MAXSIZE="$2"

# Convertir MAXSIZE a bytes (soporte K, M, G)
case "$MAXSIZE" in
    *K|*k) LIMIT=$(expr $(echo "$MAXSIZE" | tr -d Kk) \* 1024) ;;
    *M|*m) LIMIT=$(expr $(echo "$MAXSIZE" | tr -d Mm) \* 1024 \* 1024) ;;
    *G|*g) LIMIT=$(expr $(echo "$MAXSIZE" | tr -d Gg) \* 1024 \* 1024 \* 1024) ;;
    *) LIMIT=$MAXSIZE ;;
esac

TMPFILE="/tmp/files_$$"

find . -type f -exec sh -c '
  for f do
    size=$(wc -c < "$f" 2>/dev/null)
    echo "$size $f"
  done
' sh {} + 2>/dev/null | awk -v limit="$LIMIT" '$1 <= limit {print}' \
| sort -nr | head -n "$NUM" > "$TMPFILE"

echo "Top $NUM files (<= $MAXSIZE):"
awk '{printf "Size: %s bytes\tFile: %s\n", $1, $2}' "$TMPFILE"

rm -f "$TMPFILE"
