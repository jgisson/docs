# Python Notes

## What is Python

Python is a high-level, interpreted programming language known for its simplicity, readability, and versatility. Created by Guido van Rossum and first released in 1991, it emphasizes code readability with its notable use of significant indentation.

### Key Characteristics
- **Easy to learn**: Clear syntax that reads like English
- **Interpreted**: No compilation needed, run code directly
- **Dynamically typed**: No need to declare variable types
- **Cross-platform**: Works on Windows, macOS, Linux
- **Extensive ecosystem**: Huge library of packages via PyPI

---

## When to Use Python

### Use Cases

| Domain | Examples | Popular Libraries |
|--------|----------|-------------------|
| **Data Science & Analytics** | Data analysis, visualization, statistical modeling | pandas, numpy, matplotlib, seaborn |
| **Machine Learning & AI** | Model training, deep learning, NLP | scikit-learn, TensorFlow, PyTorch, transformers |
| **Web Development** | APIs, web applications, microservices | Django, Flask, FastAPI |
| **Automation & Scripting** | Task automation, file processing, system admin | os, shutil, subprocess, paramiko |
| **DevOps & Cloud** | Infrastructure as code, CI/CD, cloud automation | boto3, ansible, terraform (with Python) |
| **Scientific Computing** | Research, simulations, numerical analysis | scipy, sympy, jupyter |
| **Web Scraping** | Data extraction from websites | BeautifulSoup, Scrapy, Selenium |

### When Python Excels
- Rapid prototyping and development
- Data manipulation and analysis
- Building REST APIs and microservices
- Scripting and automation tasks
- Machine learning projects

### When to Consider Alternatives
- Performance-critical applications (consider Rust, Go, C++)
- Mobile app development (consider Swift, Kotlin)
- Frontend web development (consider JavaScript/TypeScript)

### Performance Note
Python prioritizes developer productivity over raw execution speed, typically running 10-100x slower than compiled languages like **C** and noticeably slower than JIT-compiled languages like **Java**. While similar in performance to **TypeScript/Node.js** for simple scripts, it can lag behind in heavy computational tasks due to its Global Interpreter Lock (GIL), making C extensions or async patterns essential for high-performance needs.

---

## Python Tools

> **Recommended**: Use [UV](uv%20notes.md) for managing Python installations, virtual environments, and packages. It's 10-100x faster than traditional tools.

---

## Deprecated Content

> ⚠️ **DEPRECATED**: The following sections use traditional Python tools. Consider using [UV](uv%20notes.md) instead for a faster and more modern workflow.

<details>
<summary>Legacy Installation Methods (Click to expand)</summary>

### Installation (Legacy)

#### Ubuntu: Default Version
* Update: `sudo apt update && sudo apt upgrade`
* Install: `sudo apt install python3`
* Install Python tools: `sudo apt install python3.11-dev python3.11-venv`

#### Ubuntu: Install Specific Version
* Add Python repo: `sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt update`
* Install a version: `sudo apt install python3.11`
* Set as default: 
  - `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 110`
  - `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100`
  - `sudo update-alternatives --config python3`
* Install Python tools: `sudo apt install python3.11-dev python3.11-venv`
* Fix "ModuleNotFoundError: No module named 'apt_pkg' error":
  - `cd /usr/lib/python3/dist-packages`
  - `sudo cp apt_pkg.cpython-***-linux-gnu.so apt_pkg.so`
  - ex: `sudo cp apt_pkg.cpython-310-x86_64-linux-gnu.so apt_pkg.so`

### Commands (Legacy)
* Check version: `python3 --version`
* Create virtual environment: 
  - Create: `python3 -m venv $ENV_NAME`
  - Activate: `source $ENV_NAME/bin/activate`
  - Deactivate: `deactivate`

</details>

---

## Resources
- [Official Python Documentation](https://docs.python.org/)
- [PyPI - Python Package Index](https://pypi.org/)
- [Real Python Tutorials](https://realpython.com/)
