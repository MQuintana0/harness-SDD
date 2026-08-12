# Progress

> Este documento define cómo se documenta el progreso del trabajo dentro del proyecto.
>
> La carpeta `progress/` constituye el registro vivo del estado de desarrollo y permite que cualquier agente o persona pueda comprender qué ocurrió durante una sesión, retomarla si fue interrumpida y consultar el historial del proyecto.
>
> Ningún agente debe inventar nuevos formatos. Todos los archivos de `progress/` deben respetar las plantillas descritas en este documento.

---

# Estructura

```text
progress/
│
├── current.md
├── history.md
├── impl_<work-item>.md
├── review_<work-item>.md
└── spec_<work-item>.md (solo cuando existe un bloqueo)
```

---


# current.md

Representa el estado **actual** de la sesión.

> Esta plantilla también está embebida como heredoc en `init.sh` (Sección 2).
> Si la modificas aquí, actualiza también el script para mantenerlas sincronizadas.


Debe mantenerse actualizado durante toda la ejecución del Work Item.

No debe rellenarse únicamente al finalizar el trabajo.

Su propósito es permitir que una sesión pueda retomarse en cualquier momento.

Debe utilizar siempre la siguiente plantilla:

```md
# Sesión actual

> Estado vivo de la sesión.
> Se actualiza durante toda la ejecución.
> Al finalizar el Work Item su resumen se mueve a `history.md` y este archivo vuelve a su estado inicial.

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
```

---

# history.md

Es la bitácora histórica del proyecto.

> Esta plantilla también está embebida como heredoc en `init.sh` (Sección 2).
> Si la modificas aquí, actualiza también el script para mantenerlas sincronizadas.


Su contenido es **append-only**.

Nunca deben modificarse entradas anteriores.

Al finalizar correctamente un Work Item, el resumen de `current.md` debe añadirse al final de este archivo.

La plantilla base es:

```md
# Bitácora histórica (append-only)

> Registro histórico de todas las sesiones completadas.
> Nunca modifiques entradas anteriores.
> Siempre añade nuevas entradas al final.

---
```

Cada entrada debe resumir:

- fecha;
- Work Item;
- agente;
- trabajo realizado;
- archivos modificados;
- resultado de la verificación;
- estado final.

---

# impl_<work-item>.md

Documento generado por el **Implementer**.

Describe el trabajo realizado durante la implementación.

Su estructura puede adaptarse según la naturaleza del Work Item, pero siempre debe incluir como mínimo:

- resumen de la implementación;
- archivos modificados;
- cambios realizados;
- proceso de verificación;
- observaciones relevantes.

Este archivo constituye la evidencia principal para la revisión.

---

# review_<work-item>.md

Documento generado por el **Reviewer**.

Resume el resultado de la revisión realizada sobre el Work Item.

Debe incluir como mínimo:
- estado final (`done`, `changes_requested` o `blocked`);
- verificaciones realizadas;
- observaciones;
- acciones requeridas si la revisión fue rechazada.

---

# spec_<work-item>.md

Documento generado únicamente cuando el **Spec Author** no puede completar correctamente la planificación.

Debe explicar claramente:

- motivo del bloqueo;
- información faltante;
- decisiones que requieren intervención humana.

Si no existen bloqueos, este archivo no debe crearse.

---

# Responsabilidades

| Archivo | Responsable |
|----------|-------------|
| `current.md` | Implementer |
| `history.md` | Reviewer |
| `impl_<work-item>.md` | Implementer |
| `review_<work-item>.md` | Reviewer |
| `spec_<work-item>.md` | Spec Author |

---

# Reglas

- Mantén `current.md` actualizado durante toda la sesión.
- Nunca sobrescribas el historial.
- No elimines documentación existente.
- Utiliza siempre las plantillas definidas en este documento.
- Todo Work Item debe dejar evidencia suficiente para poder comprender qué ocurrió sin depender del historial del chat.