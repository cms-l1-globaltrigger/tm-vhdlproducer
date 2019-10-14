from setuptools import setup

long_description = open('README.md').read()

setup(
    name="tm-vhdlproducer",
    version='2.7.0',
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
            'templates/vhdl/signals/*.j2',
        ]
    },
    install_requires=[
        'Jinja2',
        'tm-table>=0.7.3',
        'tm-grammar>=0.7.3',
        'tm-eventsetup>=0.7.3',
        'tm-reporter>=2.7.0'
    ],
    entry_points={
        'console_scripts': [
            'tm-vhdlproducer = tmVhdlProducer.__main__:main',
        ],
    },
    test_suite='tests',
    license="GPLv3",
    keywords="",
    platforms="any",
    classifiers=[
        "Topic :: Software Development",
        "Topic :: Utilities",
    ]
)
