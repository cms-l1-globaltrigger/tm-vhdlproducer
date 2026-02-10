from schema import Schema, And, Optional

SCHEMA_VERSION: int = 3

resource_schema: dict = {
    "processors": And(int, lambda n: n >= 0),
    "sliceLUTs": And(int, lambda n: n >= 0),
    "brams": And(int, lambda n: n >= 0),
}

correlation_schema: dict = {
    str: {
        str: resource_schema,
    },
}

mapping_schema: dict = {
    "instances": {str: str},
    "objects": {str: str},
    "cuts": {str: str},
}

object_cuts_schema: dict = {
    str: {
        str: {
            **resource_schema,
            Optional("data"): {
                str: resource_schema,
            },
        },
    },
}

instances_schema: list[dict] = [{
    "type": str,
    "objects": [{
        "types": [str],
        **resource_schema,
        Optional("cuts"): [{
            "type": str,
            **resource_schema,
        }],
    }],
}]

config_schema: Schema = Schema({
    "version": SCHEMA_VERSION,
    "resources": {
        "mapping": mapping_schema,
        "floor": resource_schema,
        "ceiling": resource_schema,
        "frame": resource_schema,
        "fdl": {
            "floor": resource_schema,
            "algo_slice": resource_schema,
        },
        "calc_deta_integer": {str: {str: resource_schema}},
        "calc_dphi_integer": {str: {str: resource_schema}},
        "calc_cut_deta": correlation_schema,
        "calc_cut_dphi": {str: {str: resource_schema}},
        "calc_cut_dr": {str: {str: resource_schema}},
        "calc_cut_mass": {str: {str: resource_schema}},
        "calc_cut_massdr": {str: {str: resource_schema}},
        "calc_ml_inst": {str: {str: resource_schema}},
        "object_cuts": object_cuts_schema,
        "instances": instances_schema,
    },
})
