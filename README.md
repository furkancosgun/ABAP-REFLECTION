# ABAP Reflection 

The **ABAP Reflection** (`ZCL_REFLECTION`) is a utility class that provides methods for performing dynamic operations on ABAP structures. It allows users to interact with the components (fields) of a structure at runtime, including retrieving field values, setting field values, checking if fields exist, and obtaining the data types of fields. This package uses dynamic techniques to operate on structures without needing to know the exact structure or field names at compile time.

## Features

- **Get Field Value**: Retrieve the value of a field from a given structure.
- **Get Field Type**: Determine the data type of a field in a structure.
- **Set Field Value**: Modify the value of a field within a structure.
- **Check Field Existence**: Verify if a specific field exists within a structure.
- **Get All Fields**: Retrieve a list of all fields in a structure.

## Methods

### `GET_FIELD`

- **Description**: Retrieves the value of a specific field from a structure.
- **Parameters**:
  - `IS_DATA` (type: ANY): The structure containing the field.
  - `IV_FIELD` (type: CLIKE): The name of the field to retrieve.
- **Returns**:
  - `EV_VALUE` (type: ANY): The value of the specified field.
- **Exceptions**:
  - `ZCX_REFLECTION_MSG`: If the provided data is not a structure or the field is not found in the structure.

### `GET_FIELD_KIND`

- **Description**: Retrieves the data type (kind) of a specific field in a structure.
- **Parameters**:
  - `IS_DATA` (type: ANY): The structure containing the field.
  - `IV_FIELD` (type: CLIKE): The name of the field.
- **Returns**:
  - `RV_KIND` (type: ABAP_TYPEKIND): The data type of the specified field.
- **Exceptions**:
  - `ZCX_REFLECTION_MSG`: If the field is not found or the data is not a valid structure.

### `SET_FIELD`

- **Description**: Sets a new value for a specific field in a structure.
- **Parameters**:
  - `IV_FIELD` (type: CLIKE): The name of the field to set.
  - `IV_VALUE` (type: ANY): The new value to assign to the field.
  - `CS_DATA` (type: ANY): The structure where the field will be updated.
- **Exceptions**:
  - `ZCX_REFLECTION_MSG`: If the field does not exist or the data is not a valid structure.

### `HAS_FIELD`

- **Description**: Checks if a specific field exists in a structure.
- **Parameters**:
  - `IS_DATA` (type: ANY): The structure to check.
  - `IV_FIELD` (type: CLIKE): The name of the field to check.
- **Returns**:
  - `RV_HAS_FIELD` (type: ABAP_BOOL): `TRUE` if the field exists, otherwise `FALSE`.
- **Exceptions**:
  - `ZCX_REFLECTION_MSG`: If the data is not a valid structure.

### `GET_FIELDS`

- **Description**: Retrieves all the fields of a structure.
- **Parameters**:
  - `IS_DATA` (type: ANY): The structure to retrieve fields from.
- **Returns**:
  - `RT_FIELDS` (type: ABAP_COMPONENT_TAB): A table of components (fields) in the structure.
- **Exceptions**:
  - `ZCX_REFLECTION_MSG`: If the data is not a valid structure.

## Error Handling

The class uses the custom exception class `ZCX_REFLECTION_MSG` to handle errors. Common error messages include:

- "Provided object is not a structure."
- "Field '<FIELD_NAME>' not found in structure."

## Usage Example

```abap
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
             field2 TYPE i,
           END OF ty_test.

    DATA: ls_data  TYPE ty_test,
          lv_value TYPE string.

    ls_data-field1 = 'Test'.
    ls_data-field2 = 10.

    TRY.
        " Get field value
        zcl_reflection=>get_field( EXPORTING is_data = ls_data iv_field = 'field1' IMPORTING ev_value = lv_value ).
        WRITE: / 'Field Value: ', lv_value."Test

        " Set field value
        zcl_reflection=>set_field( EXPORTING iv_field = 'field1' iv_value = 'Updated Value' CHANGING cs_data = ls_data ).
        WRITE: / 'Updated Field Value: ', ls_data-field1."Updated Value
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        WRITE: / 'Error: ', lx_error->get_text( ).
    ENDTRY.
```

## Supported Types

This class supports **ABAP structures** (types `typekind_struct1` and `typekind_struct2`). It ensures that the operations are only performed on valid structures, and raises errors if any of the fields or operations are invalid.

## License

This project is licensed under the [MIT License](LICENSE).

## Contribution

If you have any suggestions or improvements for this project, feel free to fork and submit a pull request! 
