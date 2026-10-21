# DriveWorksXpress · Configurador de carcazas de filtros industriales

Configurador de producto guiado para carcazas de filtros industriales con DriveWorksXpress (SOLIDWORKS 2022), basado en la codificación de carcazas de la empresa (`ZAB020021084`).

**Empieza aquí:** [docs/arquitectura-carcazas.md](docs/arquitectura-carcazas.md)

| Archivo | Contenido |
|---|---|
| [docs/arquitectura-carcazas.md](docs/arquitectura-carcazas.md) | Cómo se lleva la codificación a DriveWorksXpress, supuestos y pasos |
| [docs/reglas-carcazas.md](docs/reglas-carcazas.md) | Formulario y todas las reglas listas para copiar (generado) |
| [macros/CrearMaestrosCarcaza.bas](macros/CrearMaestrosCarcaza.bas) | Macro que crea los modelos maestros `FC_*` |
| [scripts/generar_reglas.py](scripts/generar_reglas.py) | Fuente de datos; regenera reglas y tablas (`python scripts/generar_reglas.py`) |
| [datos/](datos) | Codificación y tablas de ingeniería (CSV) y presión máxima por schedule (Excel) |
| [docs/guia-configurador-filtros.md](docs/guia-configurador-filtros.md) | Guía general de DriveWorksXpress con un ejemplo de filtro de bolsa |
| [macros/CrearMaestrosFiltroBolsa.bas](macros/CrearMaestrosFiltroBolsa.bas), [docs/reglas-driveworksxpress.md](docs/reglas-driveworksxpress.md) | El ejemplo de filtro de bolsa (primera versión) |
