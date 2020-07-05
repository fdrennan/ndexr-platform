# Installation

```
python setup.py install
```

```
python3 -m pip install --upgrade setuptools wheel
```

```
python3 setup.py sdist bdist_wheel
```

```
python3 -m pip install --upgrade twine
```

```
twine upload --repository-url https://test.pypi.org/legacy/ dist/*
```
```
pip install ndexr_redditor
```

```
python3 -m twine upload dist/*
```

# Usage

Initialization is not required for using methods in ndexr_numdata
```
from ndexr_numdata import calculate
calculate.calculate_cube(3)
```
