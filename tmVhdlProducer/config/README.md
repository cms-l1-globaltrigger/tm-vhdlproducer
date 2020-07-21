Resource calculation
====================


Format
------

Base resource consumptions and hardware implementation mapping for resource
calculation is stored in JSON format.

Basic structure of the JSON file:

    {
      "resources": {
        "mapping": {
          "instances": {
            "<esConditionType>": "<condition>",
            ...
          },
          "objects": {
            "<esObjectType>": "<object>",
            ...
          },
          "cuts": {
            "<esCutType>": "<cut>",
          }
        },
        "floor": {
            "processors": <base>,
            "sliceLUTs": <base>
        },
        "ceiling": {
            "processors": <threshold>,
            "sliceLUTs": <threshold>
        },
        "instances": [
          ...
        ]
      }
    }

Key "mapping" is used to map condition types, object types and cut types from
event setup (pyton interface) to VHDL implementation specific condition types,
object types and cut types used in "instances".

Absolute limits per hardware module (board) are set by "floor" representing the
base resource consumption of the VHDL framework used to implement the trigger
menu and "ceiling" to set a maximum threshold for resource consumption. The
"ceiling" must not exceed 100.0 % (= 1.0) and is usually lower due to the fact
that routing fill fail even before all available chip resources are used.

Structure of a condition "instance" entry:

    {
      "type": "<condition>",
      "objects": [
        {
          "types": ["<object>", ... ],
          "processors": <consumption>,
          "sliceLUTs": <consumption>,
          "cuts": [
            {
              "type": "<cut>",
              "processors": <consumption>,
              "sliceLUTs": <consumption>
            }
            ...
          ]
        },
        ...
      ]
    }


Calculation
-----------

The values for "processors" and "sliceLUTs" have to be multiplied by a factor,
depending on condition type, objects and cuts.

After calculating the values for "objects" and "cuts" a sum of these has to be
made to get the resources for a certain condition.

### "MuonCondition" and "CaloCondition"

    "objects": factor = number_of_objects * number_of_requirements

    "cut tbpt": factor = number_of_objects * (number_of_objects - 1) * 0.5

### "CaloConditionOvRm"

    "objects": factor = number_of_objects * number_of_requirements

    "cut tbpt": factor = number_of_objects * (number_of_objects - 1) * 0.5

    "cuts OvRm": factor = number_of_objects * number_of_objects_ovrm


### "CorrelationCondition"

  a) same object type, same bx:

    "objects" and "cuts": factor = number_of_objects * (number_of_objects - 1) * 0.5

  b) others:

    "objects" and "cuts": factor = number_of_objects_1 * number_of_objects_2

### "CorrelationConditionOvRm"

  a) `["calo", "calo", "calo"]`:

    "objects" and "cuts": factor = number_of_objects * (number_of_objects - 1) * 0.5

    "cuts OvRm": factor = number_of_objects * number_of_objects_ovrm

  b) `["calo", "calo"]`:

    "objects", "cuts" and "cuts OvRm": factor = number_of_objects * number_of_objects_ovrm

### "InvariantMass3Condition"

  a) `["calo", "calo", "calo"]`:

  b) `["calo", "calo"]`:
