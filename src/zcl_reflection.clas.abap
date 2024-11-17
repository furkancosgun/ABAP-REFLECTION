"! <p class="shorttext synchronized" lang="en">ABAP Reflection Class</p>
CLASS zcl_reflection DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:
      class_constructor.
    CLASS-METHODS:
      get_field
        IMPORTING
          is_data         TYPE any
          iv_field        TYPE clike
        EXPORTING
          VALUE(ev_value) TYPE any
        RAISING
          zcx_reflection_msg.
    CLASS-METHODS:
      get_field_kind
        IMPORTING
          is_data        TYPE any
          iv_field       TYPE clike
        RETURNING
          VALUE(rv_kind) TYPE abap_typekind
        RAISING
          zcx_reflection_msg.
    CLASS-METHODS:
      set_field
        IMPORTING
          iv_field TYPE clike
          iv_value TYPE any
        CHANGING
          cs_data  TYPE any
        RAISING
          zcx_reflection_msg.
    CLASS-METHODS:
      has_field
        IMPORTING
          is_data             TYPE any
          iv_field            TYPE clike
        RETURNING
          VALUE(rv_has_field) TYPE abap_bool
        RAISING
          zcx_reflection_msg.
    CLASS-METHODS:
      get_fields
        IMPORTING
          is_data          TYPE any
        RETURNING
          VALUE(rt_fields) TYPE abap_component_tab
        RAISING
          zcx_reflection_msg.
  PRIVATE SECTION.
    CONSTANTS:BEGIN OF mc_messages,
                not_a_structure     TYPE string VALUE 'Provided object is not a structure.',
                not_found_in_struct TYPE string VALUE 'Field ''&1'' not found in structure.',
              END OF mc_messages.

    TYPES:abap_typekind_t TYPE HASHED TABLE OF abap_typekind WITH UNIQUE KEY table_line.

    CLASS-DATA:mt_supported_types TYPE abap_typekind_t.

    CLASS-METHODS:
      get_type_kind
        IMPORTING
          data           TYPE any
        RETURNING
          VALUE(rv_kind) TYPE abap_typekind.

    CLASS-METHODS:
      is_supported_type
        IMPORTING
          data                TYPE any
          types               TYPE abap_typekind_t
        RETURNING
          VALUE(rv_supported) TYPE abap_bool.

    CLASS-METHODS:
      raise
        IMPORTING
          message TYPE clike
          p1      TYPE clike OPTIONAL
          p2      TYPE clike OPTIONAL
          p3      TYPE clike OPTIONAL
          p4      TYPE clike OPTIONAL
        RAISING
          zcx_reflection_msg.
ENDCLASS.



CLASS ZCL_REFLECTION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:class_constructor.
    mt_supported_types = VALUE #(
        ( cl_abap_typedescr=>typekind_struct1 )
        ( cl_abap_typedescr=>typekind_struct2 )
    ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>GET_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ANY
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [<---] EV_VALUE                       TYPE        ANY
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:get_field.
    FIELD-SYMBOLS:
      <fs_field> TYPE any.

    IF NOT is_supported_type( data = is_data types = mt_supported_types ).
      raise( mc_messages-not_a_structure ).
    ENDIF.

    ASSIGN COMPONENT iv_field OF STRUCTURE is_data TO <fs_field>.
    IF <fs_field> IS NOT ASSIGNED.
      raise( message = mc_messages-not_found_in_struct p1 = iv_field ).
    ENDIF.

    CHECK ev_value IS REQUESTED.

    ev_value = <fs_field>.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>GET_FIELDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ANY
* | [<-()] RT_FIELDS                      TYPE        ABAP_COMPONENT_TAB
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:get_fields.
    DATA:lo_structdescr TYPE REF TO cl_abap_structdescr.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( p_data = is_data ).

    rt_fields = lo_structdescr->get_components( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>GET_FIELD_KIND
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ANY
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [<-()] RV_KIND                        TYPE        ABAP_TYPEKIND
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:get_field_kind.
    FIELD-SYMBOLS:
      <fs_field> TYPE any.

    IF NOT is_supported_type( data = is_data types = mt_supported_types ).
      raise( mc_messages-not_a_structure ).
    ENDIF.

    ASSIGN COMPONENT iv_field OF STRUCTURE is_data TO <fs_field>.
    IF <fs_field> IS NOT ASSIGNED.
      raise( message = mc_messages-not_found_in_struct p1 = iv_field ).
    ENDIF.

    rv_kind = get_type_kind( <fs_field> ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_REFLECTION=>GET_TYPE_KIND
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        ANY
* | [<-()] RV_KIND                        TYPE        ABAP_TYPEKIND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:get_type_kind.
    DESCRIBE FIELD data TYPE rv_kind.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>HAS_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ANY
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [<-()] RV_HAS_FIELD                   TYPE        ABAP_BOOL
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:has_field.
    FIELD-SYMBOLS:
      <fs_field> TYPE any.

    IF NOT is_supported_type( data = is_data types = mt_supported_types ).
      raise( mc_messages-not_a_structure ).
    ENDIF.

    ASSIGN COMPONENT iv_field OF STRUCTURE is_data TO <fs_field>.
    rv_has_field = xsdbool( sy-subrc EQ 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_REFLECTION=>IS_SUPPORTED_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        ANY
* | [--->] TYPES                          TYPE        ABAP_TYPEKIND_T
* | [<-()] RV_SUPPORTED                   TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:is_supported_type.
    READ TABLE types WITH KEY table_line = get_type_kind( data ) TRANSPORTING NO FIELDS.
    rv_supported = boolc( sy-subrc EQ 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_REFLECTION=>RAISE
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        CLIKE
* | [--->] P1                             TYPE        CLIKE(optional)
* | [--->] P2                             TYPE        CLIKE(optional)
* | [--->] P3                             TYPE        CLIKE(optional)
* | [--->] P4                             TYPE        CLIKE(optional)
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:raise.
    RAISE EXCEPTION TYPE zcx_reflection_msg
      EXPORTING
        message = message
        p1      = p1
        p2      = p2
        p3      = p3
        p4      = p4.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_REFLECTION=>SET_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [--->] IV_VALUE                       TYPE        ANY
* | [<-->] CS_DATA                        TYPE        ANY
* | [!CX!] ZCX_REFLECTION_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD:set_field.
    FIELD-SYMBOLS:
      <fs_field> TYPE any.

    IF NOT is_supported_type( data = cs_data types = mt_supported_types ).
      raise( mc_messages-not_a_structure ).
    ENDIF.

    ASSIGN COMPONENT iv_field OF STRUCTURE cs_data TO <fs_field>.
    IF <fs_field> IS NOT ASSIGNED.
      raise( message = mc_messages-not_found_in_struct p1 = iv_field ).
    ENDIF.

    <fs_field> = iv_value.
  ENDMETHOD.
ENDCLASS.