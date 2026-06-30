"""
Python script to check python packages specified in requirements are successfully installed
"""

import importlib.metadata as md
import importlib.util
from pathlib import Path

VERSION_SPECIFIERS = ("==", ">=", "<=", "~=", "!=", ">", "<")

installed_ok = True
requirements_path = Path("/requirements.txt")
for raw_line in requirements_path.read_text().splitlines():
    # Strip comments and whitespace
    line = raw_line.split("#", 1)[0].strip()
    if not line:
        continue

    # Strip URL/extras/version specifiers to get the bare distribution name
    name = line.split("@", 1)[0]
    for sep in VERSION_SPECIFIERS:
        name = name.split(sep, 1)[0]
    name = name.split("[", 1)[0].strip()

    # Prefer distribution metadata; fall back to import check for packages
    # whose distribution name differs from the importable module name.
    try:
        md.distribution(name)
    except md.PackageNotFoundError:
        if importlib.util.find_spec(name.replace("-", "_")) is None:
            print(name + " is not installed")
            installed_ok = False

print(
    "SUCCESS: All Packages Installed" if installed_ok else "FAILED: Missing Package(s)"
)
