from distutils.core import setup
from tmVhdlProducer import __version__ as version

long_description = open('README.md').read()

setup(
    name="tm-vhdlproducer",
    version=version,
    url="https://github.com/cms-l1-globaltrigger/tm-vhdlproducer",
    author="Bernhard Arnold",
    author_email="bernhard.arnold@cern.ch",
    description="Generate VHDL implementation from XML trigger menu.",
    long_description=long_description,
    packages=["tmVhdlProducer"],
    scripts=["scripts/tm-vhdlproducer"],
    package_data={'tmVhdlProducer': [
        'config/*.json',
        'templates/vhdl/*.vhd',
        'templates/vhdl/menu.json',
        'templates/vhdl/instances/*.j2',
        'templates/vhdl/signals/*.j2',
    ]},
    license="GPLv3",
    keywords="",
    platforms="any",
    classifiers=[
        "Topic :: Software Development",
        "Topic :: Utilities",
    ]
)
