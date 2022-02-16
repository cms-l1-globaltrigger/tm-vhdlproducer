from setuptools import setup

long_description = open('README.md').read()

setup(
    name="tm-vhdlproducer",
    version='2.12.1',
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
            'templates/vhdl/instances/*.vhd',
            'templates/vhdl/instances/base/*.vhd',
            'templates/vhdl/signals/*.vhd'
        ]
    },
    install_requires=[
        'Jinja2==2.11.*',
        'tm-python @ git+https://github.com/cms-l1-globaltrigger/tm-python@0.10.0',
        'tm-reporter @ git+https://github.com/cms-l1-globaltrigger/tm-reporter@2.10.1'
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
