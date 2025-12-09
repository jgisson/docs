# UV Notes

## What is UV

UV is an extremely fast Python package installer and resolver, written in Rust. It's developed by [Astral](https://astral.sh/), the same team behind the Ruff linter.

### Key Features
- **Speed**: 10-100x faster than pip and pip-tools
- **Drop-in replacement**: Compatible with pip, pip-tools, and virtualenv
- **All-in-one tool**: Manages packages, virtual environments, Python versions, and projects
- **Cross-platform**: Works on macOS, Linux, and Windows
- **No Python required**: UV can bootstrap Python installations

---

## Installation

### Using curl (Recommended)
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Using Homebrew (macOS)
```bash
brew install uv
```

### Using pip
```bash
pip install uv
```

### Using pipx
```bash
pipx install uv
```

### Verify installation
```bash
uv --version
```

---

## Main Usage

### Virtual Environment Management

#### Create a virtual environment
```bash
uv venv                    # Creates .venv in current directory
uv venv myenv              # Creates myenv directory
uv venv --python 3.12      # Use specific Python version
```

#### Activate the environment
```bash
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows
```

---

### Package Management (pip interface)

UV provides a pip-compatible interface for package management:

#### Install packages
```bash
uv pip install requests              # Install a package
uv pip install requests==2.31.0      # Install specific version
uv pip install -r requirements.txt   # Install from requirements file
uv pip install -e .                  # Install current project in editable mode
```

#### Uninstall packages
```bash
uv pip uninstall requests
```

#### List installed packages
```bash
uv pip list
uv pip freeze
```

#### Compile requirements (like pip-compile)
```bash
uv pip compile requirements.in -o requirements.txt
uv pip compile pyproject.toml -o requirements.txt
```

#### Sync environment with requirements
```bash
uv pip sync requirements.txt
```

---

### Project Management

UV can manage Python projects with `pyproject.toml`:

#### Initialize a new project
```bash
uv init                    # Initialize in current directory
uv init myproject          # Create new project directory
uv init --lib              # Initialize as a library
uv init --app              # Initialize as an application
```

#### Add dependencies
```bash
uv add requests                    # Add a dependency
uv add requests==2.31.0            # Add specific version
uv add "requests>=2.31"            # Add with version constraint
uv add --dev pytest                # Add as dev dependency
uv add --group test pytest         # Add to specific group
```

#### Remove dependencies
```bash
uv remove requests
uv remove --dev pytest
```

#### Lock dependencies
```bash
uv lock                    # Generate/update uv.lock file
uv lock --upgrade          # Upgrade all dependencies
uv lock --upgrade-package requests  # Upgrade specific package
```

#### Sync environment with lockfile
```bash
uv sync                    # Install all dependencies from lockfile
uv sync --frozen           # Sync without updating lockfile
uv sync --no-dev           # Skip dev dependencies
```

---

### Python Version Management

UV can install and manage multiple Python versions:

#### List available Python versions
```bash
uv python list
```

#### Install a Python version
```bash
uv python install 3.12           # Install Python 3.12
uv python install 3.11 3.12      # Install multiple versions
```

#### Pin Python version for project
```bash
uv python pin 3.12
```

#### Find installed Python
```bash
uv python find
```

---

### Running Scripts and Commands

#### Run a script in the project environment
```bash
uv run python script.py
uv run pytest
uv run flask run
```

#### Run with inline dependencies (no project needed)
```bash
uv run --with requests python -c "import requests; print(requests.__version__)"
```

#### Run a script with embedded dependencies
```python
# /// script
# dependencies = ["requests", "rich"]
# ///
import requests
from rich import print
# ... your script
```
Then run with:
```bash
uv run script.py
```

---

### Tool Management

UV can run and install Python CLI tools:

#### Run a tool without installing
```bash
uvx ruff check .           # Run ruff without installing
uvx black .                # Run black without installing
uvx --from httpie http GET https://example.com
```

#### Install a tool globally
```bash
uv tool install ruff
uv tool install black
```

#### List installed tools
```bash
uv tool list
```

#### Update tools
```bash
uv tool upgrade ruff
uv tool upgrade --all
```

---

## Useful Tips

### Environment Variables
- `UV_CACHE_DIR`: Set custom cache directory
- `UV_NO_CACHE`: Disable caching
- `UV_PYTHON`: Specify Python interpreter
- `UV_INDEX_URL`: Set package index URL

### Cache Management
```bash
uv cache clean             # Clear the cache
uv cache dir               # Show cache directory
```

### Configuration
UV reads configuration from `pyproject.toml` under `[tool.uv]`:
```toml
[tool.uv]
dev-dependencies = ["pytest", "ruff"]
python = "3.12"
```

---

## Resources
- [Official Documentation](https://docs.astral.sh/uv/)
- [GitHub Repository](https://github.com/astral-sh/uv)
- [Astral Blog](https://astral.sh/blog)

