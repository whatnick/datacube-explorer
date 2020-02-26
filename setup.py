#!/usr/bin/env python3

from setuptools import find_packages, setup

tests_require = [
    "black",
    "boltons",
    "digitalearthau",
    "flake8",
    "isort[requirements]",
    "jsonschema > 3",
    "pytest",
    "pytest-benchmark",
    "pytest-cov",
    "requests-html",
]

extras_require = {
    "test": tests_require,
    # These are all optional but nice to have on a real deployment
    "deployment": [
        # Performance
        "ciso8601",
        "bottleneck",
        # The default run.sh and docs use gunicorn+meinheld
        "gunicorn",
        "setproctitle",
        "meinheld",
    ],
}

setup(
    name="dea-dashboard",
    use_scm_version=True,
    setup_requires=["setuptools_scm"],
    python_requires=">=3.6",
    url="https://github.com/opendatacube/datacube-explorer",
    author="Geoscience Australia",
    author_email="earth.observation@ga.gov.au",
    packages=find_packages(),
    install_requires=[
        "cachetools",
        "click",
        "dataclasses>=0.6;python_version<'3.7'",
        "datacube>=1.6",
        "fiona",
        "flask",
        "Flask-Caching",
        "flask_themes @ git+https://git@github.com/maxcountryman/flask-themes@master",
        "geoalchemy2",
        "geographiclib",
        "jinja2",
        "pyorbital",
        "pyproj",
        "python-dateutil",
        "python-rapidjson",
        "shapely",
        "simplekml",
        "sqlalchemy",
        "structlog",
    ],
    tests_require=tests_require,
    extras_require=extras_require,
    entry_points={"console_scripts": ["cubedash-gen = cubedash.generate:cli"]},
)
