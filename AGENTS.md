# Repository Guidelines

## Project Structure & Module Organization
All core code lives in `org/IHCP_CGM_Sliding_Window_Calculation_ver2.py`, which implements thermal-property fitting, forward/adjoint solvers, and the CGM loop. Supporting assets (`metal_thermal_properties.csv`, `T_measure_700um_1ms.npy`) currently sit beside the script; group additional data under `org/data/` and keep notebooks or experiments in `org/notebooks/` to avoid clutter.

## Build, Test, and Development Commands
- `python3 -m venv .venv && source .venv/bin/activate` — set up an isolated interpreter.
- `pip install numpy pandas scipy numba` — install the numerical stack required by the solvers.
- `python org/IHCP_CGM_Sliding_Window_Calculation_ver2.py` — run the end-to-end CGM workflow; add a `main()` entry point before committing longer routines.
- `pytest -q` — execute the test suite once fixtures exist; default to running without external data unless explicitly required.

## Coding Style & Naming Conventions
Follow PEP 8 with 4-space indentation and lowercase `snake_case` for functions, variables, and NumPy arrays (e.g., `thermal_properties_calculator`, `q_surface_window`). Keep lines ≤100 characters to preserve solver readability. Add short docstrings describing units and array shapes when introducing new numerical routines. Run `black` and `isort` locally prior to pushing.

## Testing Guidelines
Use `pytest` for unit and integration coverage. Organize tests under `tests/unit` for utilities and `tests/integration` for solver pipelines. Name tests `test_<component>_<behavior>` and seed RNGs where stochastic elements enter. When real datasets are required, slice small windows or provide fixtures that copy from `BASE_DIR` into temp dirs to keep runs fast.

## Commit & Pull Request Guidelines
Write commits in imperative mood (“Add CGM plateau check”) and keep them focused. Reference related experiments or notebooks in the body when relevant. Pull requests should summarize solver impact, list validation commands (e.g., `pytest -q`, sample CGM runs), attach key plots when behavior changes, and link issue IDs before requesting review.

## Environment & Data Handling
Resolve file paths relative to `Path(__file__).parent` to support tests and imports. Store large camera exports outside Git; commit only derived samples or metadata, and document access instructions in `org/data/README.md` when applicable.
