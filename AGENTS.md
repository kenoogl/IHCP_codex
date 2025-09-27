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

## Julia Migration Playbook
1. **Repository Layout for Julia**  
   Create `julia/Project.toml` with dependencies (`LinearAlgebra`, `SparseArrays`, `NPZ`, `IterativeSolvers`, optionally `PyCall`). Split Julia code into modules: `IHCP.jl` (entry), `poly_utils.jl`, `grid_setup.jl`, `dhcp.jl`, `adjoint.jl`, `cgm.jl`. Use `include` + `module` to keep namespaces tidy.

2. **Conversion Order & Granularity**  
   Migrate in dependency order: (a) scalar helpers (`polyval`), (b) thermal-property calculators, (c) grid/coeff builders, (d) DHCP solver, (e) adjoint solver, (f) CGM + line search, (g) sliding window & I/O. Avoid introducing parallelism during migration; stick with single-threaded loops for reproducibility.

3. **Reference Dataset & Sanity Harness**  
   Prepare a shrinked dataset (`5` timesteps × `20×20` pixels) in both NumPy (`.npz`) and Julia (`NPZ.jl`) readable forms. For each converted function, run side-by-side checks: `max(abs(diff))`, `mean(abs(diff))`, array min/max. Store Python reference outputs under `artifacts/python_baseline/` for traceability.

4. **Bridging During Transition**  
   While only part of the pipeline is native Julia, call remaining Python routines via `PyCall.jl` or reuse saved intermediate arrays. Provide Julia wrappers that forward to Python until the equivalent Julia function passes equality checks. Document the mix-and-match status in `docs/conversion_log.md`.

5. **Verification Workflow**  
   Tag each migration step with a Julia test script (`julia/test/test_stepN.jl`) comparing against Python references. Require tests to pass before moving to the next function. Capture numerical tolerances (e.g., `1e-10` for double precision) and log deviations.

6. **Post-conversion Tasks**  
   After all functions are native Julia, refactor for idiomatic style (broadcasting, `mul!`, `StaticArrays` where appropriate), reintroduce parallelism (`Threads.@threads`, `LoopVectorization`) only after verifying baseline parity. Update documentation and CI to run both Python and Julia tests.
