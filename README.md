# AI Harness

Un arnés de desarrollo para proyectos asistidos por IA basado en **Spec Driven Development (SDD)** y **orquestación multiagente**.

Su objetivo no es generar código automáticamente, sino proporcionar una estructura donde distintos agentes colaboran de forma controlada, verificable y siempre bajo supervisión humana.

El repositorio actúa como la fuente de verdad del sistema: toda la planificación, implementación y revisión queda documentada dentro del propio proyecto.

---

# Primeros pasos

Para entender cómo se usa el harness en el día a día (aprobar planificaciones, continuar una sesión interrumpida, preguntas frecuentes), consulta **`docs/usage.md`**.

1. Copia los archivos del harness (`AGENTS.md`, `docs/`, `agents/`, `init.sh`) dentro de tu proyecto.
2. Ejecuta `bash init.sh` para verificar el harness e inicializar `specs/` y `progress/`.
3. Empieza a hablar con el agente describiendo lo que necesitas — actuará como Leader y coordinará el resto.

---

# Principios

Este harness se construye sobre cuatro principios fundamentales.

## 1. El repositorio es la memoria

Los agentes no dependen del historial del chat.

Toda la información relevante vive dentro del proyecto:

- documentación
- especificaciones
- progreso
- historial
- estados

Una conversación puede perderse.
El repositorio no.

---

## 2. Un agente, una responsabilidad

Cada agente posee un único objetivo.

| Agente | Responsabilidad |
|---------|-----------------|
| Leader | Comprender la solicitud, coordinar el workflow y delegar. |
| Spec Author | Transformar un Work Item en una planificación técnica. |
| Implementer | Implementar únicamente la planificación aprobada. |
| Reviewer | Validar que el trabajo cumple la planificación y las reglas del proyecto. |

Ningún agente sustituye el trabajo de otro.

---

## 3. Spec Driven Development

Todo trabajo sigue el mismo flujo base.

```
Usuario
      │
      ▼
 Leader
      │
      ▼
 meta.json
      │
      ▼
Spec Author
      │
      ▼
Planificación
      │
      ▼
Aprobación humana
      │
      ▼
Implementer
      │
      ▼
Reviewer
      │
      ▼
Finalización
```

El código nunca se implementa antes de existir una planificación aprobada.

> Este diagrama muestra la ruta principal. Las ramificaciones (rechazo en revisión, bloqueos) están documentadas en `docs/harness/workflow.md`.

> El tramo `Usuario → Leader → meta.json` representa una negociación explícita, no una conversión automática — ver `docs/usage.md` (para el usuario) o `agents/leader.md` (protocolo del agente).


---

## 4. El humano siempre mantiene el control

Ningún agente puede avanzar automáticamente entre etapas críticas.

Toda planificación debe ser aprobada explícitamente antes de comenzar la implementación.

La aprobación humana forma parte del workflow y nunca puede omitirse.

---

# Organización del repositorio
## Estructura

```text
.
├── AGENTS.md                     # Punto de entrada para los agentes
├── README.md                     # Descripción general del harness
├── init.sh                       # Inicialización y verificación del entorno
│
├── docs/
│   ├── usage.md                  # Guía de uso para humanos
│   ├── harness/                 # Documentación del arnés (no personalizar)
│   │   ├── workflow.md           # Reglas de verificación
│   │   ├── specs.md              # Spec Driven Development
│   │   ├── progress.md           # Sistema de progreso
│   │   └── meta.md               # Sistema de progreso
│   └── project/                 # Documentación del proyecto (personalizar)
│       ├── architecture.md       # Principios de arquitectura
│       ├── conventions.md        # Convenciones del proyecto
│       └── verification.md       # Reglas de verificación
│
├── specs/
│   └── <work-item>/
│       ├── meta.json             # Estado y metadatos del Work Item
│       ├── requirements.md       # Requirements (solo Features)
│       ├── design.md             # Diseño técnico (solo Features)
│       ├── tasks.md              # Plan de implementación (solo Features)
│       └── plan.md               # Plan simplificado (solo Tasks)
│
├── progress/
│   ├── current.md                # Estado de la sesión actual
│   ├── history.md                # Historial de sesiones
│   └── <work-item>/              # Documentos generados por los agentes
│       ├── impl.md               # Reporte del Implementer
│       ├── review.md             # Reporte del Reviewer
│       └── spec.md               # Bloqueo del Spec Author (solo si aplica)
│
├── agents/
│   ├── leader.md
│   ├── spec_author.md
│   ├── implementer.md
│   └── reviewer.md
│
├── src/                          # Código fuente del proyecto
├── tests/                        # Pruebas del proyecto
└── ...
```
---

# Work Items

El harness trabaja sobre **Work Items**. Existen dos tipos, **Feature** y **Task**, según el nivel de planificación que requiere el cambio.

Los criterios para elegir entre uno y otro, así como los estados y transiciones que sigue cada Work Item, están definidos en `docs/harness/workflow.md`.

---

# Documentación

La documentación está dividida en dos grupos según quién debe modificarla y desacoplada por responsabilidad.

## Documentación del harness (`docs/harness/`)

Define el funcionamiento del arnés. **No requiere personalización** al adaptarlo a un proyecto.

| Documento | Propósito |
|-----------|-----------|
| `workflow.md` | Flujo completo: tipos de Work Item, estados y transiciones. |
| `specs.md` | Cómo se construyen las especificaciones. |
| `progress.md` | Funcionamiento del sistema de progreso. |
| `meta.md` | Estructura y significado de `meta.json`. |

## Documentación del proyecto (`docs/project/`)

Describe las reglas de **tu repositorio**. **Debes personalizarla** al implementar el harness por primera vez.

| Documento | Propósito |
|-----------|-----------|
| `architecture.md` | Principios de arquitectura del proyecto. |
| `conventions.md` | Convenciones de desarrollo. |
| `verification.md` | Checkpoints y reglas de validación. |

También personaliza las secciones 2 y 3 de `AGENTS.md` (propósito y stack) y la Sección 4 de `init.sh` (comandos de verificación).

Los agentes cargan únicamente la documentación necesaria para su etapa.

---

# Sistema de progreso

El progreso del proyecto también vive dentro del repositorio.

```
progress/
```

contiene:

- sesión actual (`current.md`)
- historial (`history.md`)
- carpeta por Work Item (`<work-item>/`) con reportes de implementación, revisión y bloqueos

Esto permite:

- continuar sesiones interrumpidas
- mantener trazabilidad
- conservar un historial permanente del proyecto

---

# Filosofía del proyecto

Este repositorio no pretende construir un asistente autónomo.

Pretende construir un sistema donde:

- los agentes tienen responsabilidades claras;
- el contexto está distribuido;
- la documentación es la fuente de verdad;
- el humano conserva siempre el control del proceso.

La IA no reemplaza el proceso de desarrollo.

Lo sigue.