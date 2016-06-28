#/bin/bash
REV=$1

echo "[Escualo::RSpecServer] Fetching GIT revision"
echo -n $REV > version
