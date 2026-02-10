# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Support `NETETMHF` objects (#64).
- Added Jinja filter `type_remap` to map `NETETMHF` to `HTM` in templates (#64).

### Changed

- Updated dependency support for utm v0.14 (#64).
- Migrated project configuration to `pyproject.toml`.
- Resolved Ruff linting issues.

### Removed

- Removed obsolete `requirements.txt` and `setup.cfg`.

## [2.24.0] - 2026-01-30

### Added

- TOPO model `HHbbWW_1mu_v5` resource configuration.
- AXO model `v6` resource configuration.

### Changed

- Renamed `changelog` to `CHANGELOG.md`.

### Fixed

- Markdown format in changelog.

## [2.23.2] - 2026-01-30

### Fixed

- typo preventing TOPO instantiations in `ml_calculations` template.

## [2.23.1] - 2026-01-30

### Fixed

- use `TOPO_SCORE_WIDTH` in `signal_ml_calculations` template.

## [2.23.0] - 2025-05-20

### Added

- resource calculation for ML (AXO and TOPO) calculation instances.
- fixed Invariant Mass conditions to one module (default = 3)

## [2.22.0] - 2025-05-16

### Added

- Instanciate only one AXO/TOPO calculation per module to reduce resources.
  Fixed AXO algos to module 1, TOPO algos to module 2 by default.
- Support for Pyton 3.13.

### Changed

- Replaced flake8/pylint by ruff (#58).

### Removed

- Dropped support for Python < 3.9.

## [2.21.1] - 2025-05-14

### Fixed

- checking module range for constraints.
- ascending algorithm sorting for logs.

## [2.21.0] - 2025-03-20

### Added

- AXO model `v5` to resource_default.json.

## [2.20.2] - 2024-11-04

### Fixed

- Added compatibility for Pyton 3.12 (#59).

## [2.20.1] - 2024-08-12

### Changed

- added "htmhf" in template signal_condition.vhd for "TOPO" (#56).

## [2.20.0] - 2024-07-04

### Added

- TOPO model `base_v1` and AXO model `v4` in resource_default.json.

### Changed

- template for AXO instances (added input "htmhf")

### Removed

- unused templates (anomaly_detection.vhd and topo_trigger.vhd).

## [2.19.0] - 2024-05-16

### Added

- support for HTMHF.
- support for comb function with more than 4 objects.

### Changed

- depending on tm-python 0.13.0 (#49).
- depending on tm-reporter 2.13.0 (#49).

## [2.18.1] - 2024-06-06

### Added

- validation of ETA and INDEX cut ranges (#53).

## [2.18.0] - 2024-03-22

### Added

- calculation of hash sum of source code (#48).

### Changed

- updated VHDL templates (#48).

## [2.17.1] - 2024-02-28

### Fixed

- incorrect CScore value (#46).

## [2.17.0] - 2024-02-20

### Changed

- ADT implementation and AXO (AXOL1TL) with models.
- merged `main` into `__main__` module.

### Added

- CICADA and TOPO with models implementation.
- config schema validation (#45).
- depending on tm-python 0.12.0 (#43).
- depending on tm-reporter 2.12.0

## [2.16.0] - 2023-10-10

### Changed

- replaced deprecated `setup.py` file with `setup.cfg` file (#41).

## [2.15.1] - 2023-10-05

### Changed

- changed value for "brams" in "floor" (resource_default.json)

## [2.15.0] - 2023-09-26

### Added

- default value (module = 0) for `zdc` constraints

## [2.14.2] - 2023-06-15

### Fixed

- condition constraint command line argument

## [2.14.1] - 2023-06-06

### Added

- type `zdc` to condition constraints

### Fixed

- broken condition constraints

## [2.14.0] - 2023-03-13

### Added

- support for MUS2, ZDC, ADT, muon index cut

### Changed

- depending on tm-python 0.11.2
- depending on tm-reporter 2.11.3

## [2.13.2] - 2022-12-14

### Added

- changed values for "floor" in resource_default.json (3 additional quads used for ZDC conversion in MP7)

### Changed

- resource_default.json

## [2.13.1] - 2022-11-16

### Changed

- bug fix in template ("muon_mass_3_obj_condition.vhd": missing generic parameters)

## [2.13.0] - 2022-08-25

### Added

- improved resource calculation

### Changed

- algodist.py and resource_default.json

## [2.12.1] - 2022-03-21

### Changed

- bug fix in templates ("calo_conditions_orm.vhd" and "esums_condition.vhd")
- updated comment in template ("ugt_constants.vhd")

## [2.12.0] - 2021-12-06

### Added

- support for displaced jets

### Changed

- depending on tm-python 0.10.0
- depending on tm-reporter 2.10.1

## [2.11.1] - 2021-10-12

### Changed

- refactored resource calculation

## [2.11.0] - 2021-06-11

### Changed

- mp7_ugt_legacy v1.15.0
- refactored VHDL instance templates
- updated module vhdlhelper
- migration to utm 0.9.1 #27

## [2.10.1] - 2021-05-12

### Changed

- depending on tm-python 0.8.2
- depending on tm-reporter 2.8.2

## [2.10.0] - 2021-01-08

### Changed

- templates for mp7_ugt_legacy v1.12.x
- refactored VHDL instance templates

## [2.9.4] - 2021-05-12

### Changed

- depending on tm-python 0.8.2
- depending on tm-reporter 2.8.2

## [2.9.3] - 2021-03-24

### Fixed

- templates for mp7_ugt_legacy v1.11.2:
- correlation_cuts_correlation.vhd
- muon_muon_correlation_condition.vhd

## [2.9.2] - 2021-02-09

### Added

- CI using github actions #21

## [2.9.1] - 2021-02-09

### Changed

- using f-strings #16

### Fixed

- fixed removing existing directories #19

## [2.9.0] - 2020-12-07

### Changed

- templates for mp7_ugt_legacy v1.11.x
- default values in module vhdlhelper

## [2.8.1] - 2020-08-26

### Changed

- module vhdlhelper
- templates

## [2.8.0] - 2020-07-20

### Changed

- depending on tm-python 0.8.0
- depending on tm-reporter 2.8.0

### Added

- unconstrained pt for muons
- impact parameter for muons
- invariant mass for three particles

## [2.7.5] - 2020-06-18

### Fixed

- supporting up to 5 eta windows

## [2.7.4] - 2020-01-15

### Fixed

- calo_calo_calo_correlation_orm_condition.vhd.j2

## [2.7.3] - 2020-01-08

### Changed

- depends on tm-python 0.7.4

## [2.7.2] - 2019-10-16
### Changed

- depends on meta package tm-python

## [2.7.1] - 2019-10-15

### Fixed

- calo_calo_calo_correlation_orm_condition.vhd.j2
- calo_conditions_orm.vhd.j2

## [2.7.0] - 2019-10-03

### Added

- depends on tm-reporter

### Changed

- migrated to Python3
- removed obsolete SVN/git revision tagging
- moved scripts to package modules
- updated setup.py
- renamed test to tests

### Removed

- scripts, setup.sh, copyright

## [2.6.1] - 2019-06-17

### Changed

- merged parallel branches 2.5.1 and 2.6.0

## [2.6.0] - 2019-06-17

### Changed

- VHDL templates for "five eta cuts"
- module vhdlhelper for "five eta cuts"

## [2.5.1] - 2019-01-30

### Added

- added MANIFEST.in
- added requirements.txt
- added setup.py

### Changed

- moved config/ into package tmVhdlProducer
- moved templates/ nto package tmVhdlProducer

## [2.5.0] - 2018-08-09

### Added

- functionality "Asymmetry" and "Centrality"
  (algodist, handles, vhdlhelper)
- template signal_condition.vhd.j2 (for "Centrality")

### Changed

- removed def signed (vhdlproducer)
- changed def murmurhash (vhdlproducer)
- template gtl_module_instances.vhd

## [2.4.1] - 2018-07-30

### Added

- evironment setup script

### Changed

- git repo compatibility

## [2.4.0] - 2018-04-24

### Removed

- removed tm-reporter (now a separate gitlab project)

## [2.3.0] - 2017-10-23

### Added

- added handles module.
- added cut and object template helper classes.

### Changed

- code refactoring.
- renamed stubs to handles (algodist).
- lookup dictionaries, replaced string type keys by enumerations.
- updated/renamed templates (using new template helpers).
- fixed VHDL templates for GTL version 1.5.0

### Removed

- obsolete templates.

## [2.2.1] - 2017-09-14

### Changed

- fixed VHDL templates for GTL version 1.4.1

## [2.2.0] - 2017-09-13

### Changed

- updated VHDL templates for GTL version 1.4.0

## [2.1.1] - 2017-07-06

### Changed

- fixed writing correct module distribution to generated doc.

## [2.1.0] - 2017-06-26

### Added

- new condition constraint option.

## [2.0.0] - 2017-06-13

### Added

- new resource config and calculation.
- integrated twiki/html reporter.
- new change log file.
- new `--sorting` option.

### Changed

- reorganized templates.

## [1.0.0] - 2016-07-16

### Changed

- adjusted `--dryrun` and `--ratio` options.

[unreleased]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.24.0...HEAD
[2.24.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.23.2...2.24.0
[2.23.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.23.1...2.23.2
[2.23.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.23.0...2.23.1
[2.23.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.22.0...2.23.0
[2.22.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.21.1...2.22.0
[2.21.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.21.0...2.21.1
[2.21.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.20.2...2.21.0
[2.20.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.20.1...2.20.2
[2.20.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.20.0...2.20.1
[2.20.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.19.0...2.20.0
[2.19.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.18.1...2.19.0
[2.18.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.18.0...2.18.1
[2.18.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.17.1...2.18.0
[2.17.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.17.0...2.17.1
[2.17.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.16.0...2.17.0
[2.16.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.15.1...2.16.0
[2.15.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.15.0...2.15.1
[2.15.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.14.2...2.15.0
[2.14.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.14.1...2.14.2
[2.14.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.14.0...2.14.1
[2.14.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.13.2...2.14.0
[2.13.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.13.1...2.13.2
[2.13.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.13.0...2.13.1
[2.13.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.12.1...2.13.0
[2.12.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.12.0...2.12.1
[2.12.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.11.1...2.12.0
[2.11.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.11.0...2.11.1
[2.11.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.10.1...2.11.0
[2.10.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.10.0...2.10.1
[2.10.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.9.4...2.10.0
[2.9.4]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.9.3...2.9.4
[2.9.3]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.9.2...2.9.3
[2.9.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.9.1...2.9.2
[2.9.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.9.0...2.9.1
[2.9.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.8.1...2.9.0
[2.8.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.8.0...2.8.1
[2.8.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.5...2.8.0
[2.7.5]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.4...2.7.5
[2.7.4]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.4...2.7.4
[2.7.3]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.2...2.7.3
[2.7.2]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.1...2.7.2
[2.7.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.7.0...2.7.1
[2.7.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.6.1...2.7.0
[2.6.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.6.0...2.6.1
[2.6.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.5.1...2.6.0
[2.5.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.5.0...2.5.1
[2.5.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.4.1...2.5.0
[2.4.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.4.0...2.4.1
[2.4.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.3.0...2.4.0
[2.3.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.2.1...2.3.0
[2.2.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.1.1...2.2.0
[2.1.1]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/cms-l1-globaltrigger/tm-vhdlproducer/releases/tag/1.0.0
