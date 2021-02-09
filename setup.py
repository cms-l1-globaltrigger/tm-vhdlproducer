from setuptools import setup

long_description = open('README.md').read()

setup(
    name="tm-vhdlproducer",
    version='2.9.2',
    url="https://github.com/cms-l1-globaltrigger/tm-vhdlproducer",
    author="Bernhard Arnold",
    author_email="bernhard.arnold@cern.ch",
    description="Generate VHDL implementation from XML trigger menu.",
    long_description=long_description,
    packages=["tmVhdlProducer"],
    package_data={
        'tmVhdlProducer': [
            'config/*.json',
            'templates/vhdl/*.vhd',
            'templates/vhdl/menu.json',
            'templates/vhdl/instances/*.j2',
            'templates/vhdl/signals/*.j2'
        ]
    },
    install_requires=[
        'Jinja2',
        'tm-python @ git+https://github.com/cms-l1-globaltrigger/tm-python@0.8.1',
        'tm-reporter @ git+https://github.com/cms-l1-globaltrigger/tm-reporter@2.8.1'
    ],
    entry_points={
        'console_scripts': [
            'tm-vhdlproducer = tmVhdlProducer.__main__:main'
        ],
    },
    test_suite='tests',
    license="GPLv3",
    keywords="",
    platforms="any",
    classifiers=[
        "Topic :: Software Development",
        "Topic :: Utilities"
    ]
)
