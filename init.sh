#!/usr/bin/env bash
#
# init.sh
#
# Inicializa y verifica el Harness antes de comenzar una sesión.
#
# Si algún elemento crítico del Harness falta, la sesión no debe comenzar.
#

set -u

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
fail() { printf "${RED}[FAIL]${NC}  %s\n" "$1"; }

EXIT_CODE=0

echo "────────────────────────────────────────────"
echo " Harness Initialization"
echo "────────────────────────────────────────────"
echo

###########################################################
# 1. Verificar archivos críticos del Harness
###########################################################

echo "── 1. Verificando Harness ─────────────────"

REQUIRED_FILES=(
    "AGENTS.md"
    "README.md"

    "docs/workflow.md"
    "docs/specs.md"
    "docs/meta.md"
    "docs/progress.md"
    "docs/architecture.md"
    "docs/conventions.md"
    "docs/verification.md"

    "agents/leader.md"
    "agents/spec_author.md"
    "agents/implementer.md"
    "agents/reviewer.md"
)

FAILED_CHECKS=()

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        fail "Falta $file"
        EXIT_CODE=1
        FAILED_CHECKS+=("Falta $file")
    else
        ok "$file"
    fi
done

echo

###########################################################
# 2. Inicializar estructura auxiliar
###########################################################

echo "── 2. Inicializando estructura ────────────"

mkdir -p specs
mkdir -p progress

ok "specs/"
ok "progress/"

CURRENT_FILE="progress/current.md"

# Plantilla definida en docs/progress.md — si la modificas ahí, actualiza también este heredoc.
if [[ ! -f "$CURRENT_FILE" ]]; then
cat > "$CURRENT_FILE" <<'EOF'
# Sesión actual

> Estado vivo de la sesión.
> Se actualiza durante toda la ejecución.
> Al finalizar el Work Item su resumen se mueve a `history.md`
> y este archivo vuelve a su estado inicial.

- **Work Item:** _ninguno_
- **Tipo:** _—_
- **Estado:** _—_
- **Inicio:** _—_
- **Agente activo:** _—_

## Plan

_—_

## Bitácora

_—_

## Próximo paso

_—_
EOF

    ok "progress/current.md creado"
else
    ok "progress/current.md"
fi

HISTORY_FILE="progress/history.md"

# Plantilla definida en docs/progress.md — si la modificas ahí, actualiza también este heredoc.
if [[ ! -f "$HISTORY_FILE" ]]; then
cat > "$HISTORY_FILE" <<'EOF'
# Bitácora histórica (append-only)

> Registro histórico de todas las sesiones completadas.
> Nunca modifiques entradas anteriores.
> Siempre añade nuevas entradas al final.

---
EOF

    ok "progress/history.md creado"
else
    ok "progress/history.md"
fi

echo

###########################################################
# 3. Validar invariantes del Harness
###########################################################

echo "── 3. Validando invariantes ───────────────"

# 3.1 — Sesión activa en progress/current.md
#
# progress/current.md es el único archivo que representa la sesión activa.
# Por diseño (AGENTS.md §9: "trabaja sobre un único Work Item por sesión"),
# la regla de docs/workflow.md ("solo un Work Item en in_progress") queda
# garantizada por esta misma estructura: basta con leer este único archivo,
# no es necesario escanear specs/*/meta.json.
if grep -q "_ninguno_" "$CURRENT_FILE"; then
    ok "No existe ninguna sesión activa."
else
    warn "Existe una sesión registrada en progress/current.md."
    warn "Revisa si debe continuarse antes de iniciar un nuevo Work Item."
fi

echo

###########################################################
# 4. Verificación del proyecto
###########################################################

echo "── 4. Verificando proyecto ───────────────"

echo "[INFO] Personaliza esta sección según tu proyecto."
echo "[INFO] Los comandos deben coincidir con docs/verification.md."

# Usa run_check para que cualquier fallo se propague correctamente a $EXIT_CODE.
# El Reviewer exige que init.sh finalice sin errores antes de aprobar un Work Item,
# así que un comando de verificación que falle DEBE marcar el harness como fallido.
run_check() {
    local desc="$1"; shift
    if "$@" > /dev/null 2>&1; then
        ok "$desc"
    else
        fail "$desc"
        EXIT_CODE=1
        FAILED_CHECKS+=("$desc")
    fi
}

#
# Ejemplos (descomenta y adapta a tu stack):
#
# run_check "Lint"  npm run lint
# run_check "Tests" npm test
# run_check "Build" npm run build
#
# run_check "Tests" pytest
#
# run_check "Tests" cargo test
#

echo

###########################################################
# 5. Resumen
###########################################################

echo "── 5. Resumen ─────────────────────────────"

if [[ $EXIT_CODE -eq 0 ]]; then
    ok "Harness listo para trabajar."
else
    fail "El Harness contiene errores:"
    for issue in "${FAILED_CHECKS[@]}"; do
        fail "  - $issue"
    done
fi

exit $EXIT_CODE