"""Functions for validating menu integrity."""

import tmEventSetup
from tmEventSetup import esTriggerMenu, esCut

__all__ = ["validate_menu"]


def validate_eta_range(cut: esCut) -> None:
    minimum = cut.getMinimumValue()
    maximum = cut.getMaximumValue()
    if minimum > maximum:
        name = cut.getName()
        raise ValueError(f"cut {name!r}: invalid ETA range: [{minimum:f}, {maximum:f}]")


def validate_index_range(cut: esCut) -> None:
    minimum = cut.getMinimumValue()
    maximum = cut.getMaximumValue()
    if minimum > maximum:
        name = cut.getName()
        raise ValueError(f"cut {name!r}: invalid INDEX range: [{minimum:d}, {maximum:d}]")


def validate_menu(menu: esTriggerMenu) -> None:
    for cond in menu.getConditionMapPtr().values():
        for obj in cond.getObjects():
            for cut in obj.getCuts():
                cut_type = cut.getCutType()
                if cut_type == tmEventSetup.Eta:
                    validate_eta_range(cut)
                elif cut_type == tmEventSetup.Index:
                    validate_index_range(cut)
