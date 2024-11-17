CLASS ltcl_zcl_reflection DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS:
      get_field_valid FOR TESTING,           " Valid field retrieval test
      get_field_invalid_struct FOR TESTING,  " Invalid structure type test
      get_field_field_not_found FOR TESTING, " Field not found in structure test
      get_field_kind_valid FOR TESTING,      " Valid field kind retrieval test
      get_field_kind_invalid_struct FOR TESTING, " Invalid structure type for field kind test
      get_field_kind_field_not_found FOR TESTING, " Field kind not found in structure test
      set_field_valid FOR TESTING,           " Valid field set test
      set_field_invalid_structure FOR TESTING, " Invalid structure type for set field test
      set_field_field_not_found FOR TESTING, " Field not found when setting test
      has_field_valid FOR TESTING,           " Valid field existence check test
      has_field_invalid_structure FOR TESTING, " Invalid structure type for field existence check test
      has_field_field_not_found FOR TESTING. " Field not found in structure test
ENDCLASS.

CLASS ltcl_zcl_reflection IMPLEMENTATION.

  METHOD get_field_valid.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
             field2 TYPE i,
           END OF ty_test.

    DATA: ls_data   TYPE ty_test,
          lv_field  TYPE string,
          lv_result TYPE string.

    ls_data-field1 = 'Test'.
    ls_data-field2 = 10.

    lv_field = 'field1'.  " Valid field

    TRY.
        " Call get_field method
        zcl_reflection=>get_field( EXPORTING is_data = ls_data iv_field = lv_field IMPORTING ev_value = lv_result ).
        cl_abap_unit_assert=>assert_not_initial( lv_result ).
        cl_abap_unit_assert=>assert_equals( act = lv_result exp = 'Test' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_field_invalid_struct.
    TRY.
        " Invalid structure type
        zcl_reflection=>get_field( is_data = 'not a structure' iv_field = 'field1' ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Provided object is not a structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_field_field_not_found.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
           END OF ty_test.

    DATA: ls_data TYPE ty_test.

    ls_data-field1 = 'Test'.

    TRY.
        " Try to access a non-existing field
        zcl_reflection=>get_field( is_data = ls_data iv_field = 'field2' ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Field ''field2'' not found in structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_field_kind_valid.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
             field2 TYPE i,
           END OF ty_test.

    DATA: ls_data  TYPE ty_test,
          lv_field TYPE string,
          lv_kind  TYPE abap_typekind.

    ls_data-field1 = 'Test'.
    ls_data-field2 = 10.
    lv_field = 'field2'.  " Valid field

    TRY.
        " Call get_field_kind method
        lv_kind = zcl_reflection=>get_field_kind( is_data = ls_data iv_field = lv_field ).
        cl_abap_unit_assert=>assert_not_initial( lv_kind ).
        cl_abap_unit_assert=>assert_equals( act = lv_kind exp = cl_abap_typedescr=>typekind_int ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_field_kind_invalid_struct.
    TRY.
        " Invalid structure type for field kind
        DATA(lv_kind) = zcl_reflection=>get_field_kind( is_data = 'not a structure' iv_field = 'field1' ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Provided object is not a structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_field_kind_field_not_found.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
           END OF ty_test.

    DATA: ls_data TYPE ty_test.

    ls_data-field1 = 'Test'.

    TRY.
        " Try to get a non-existing field kind
        DATA(lv_kind) = zcl_reflection=>get_field_kind( is_data = ls_data iv_field = 'field2' ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Field ''field2'' not found in structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD set_field_valid.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
             field2 TYPE i,
           END OF ty_test.

    DATA: ls_data  TYPE ty_test,
          lv_field TYPE string,
          lv_value TYPE string.

    ls_data-field1 = 'Test'.
    ls_data-field2 = 10.

    lv_field = 'field1'.
    lv_value = 'Updated Value'.

    TRY.
        " Call set_field method
        zcl_reflection=>set_field( EXPORTING iv_field = lv_field iv_value = lv_value CHANGING cs_data = ls_data ).
        cl_abap_unit_assert=>assert_equals( act = ls_data-field1 exp = 'Updated Value' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD set_field_invalid_structure.
    TRY.
        " Invalid structure type for set field
        DATA:ls_data TYPE string.
        zcl_reflection=>set_field( EXPORTING iv_field = 'field1' iv_value = 'Test' CHANGING cs_data = ls_data ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Provided object is not a structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD set_field_field_not_found.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
           END OF ty_test.

    DATA: ls_data TYPE ty_test.

    ls_data-field1 = 'Test'.

    TRY.
        " Try to set a non-existing field
        zcl_reflection=>set_field( EXPORTING iv_field = 'field2' iv_value = 'Updated' CHANGING cs_data = ls_data ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Field ''field2'' not found in structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD has_field_valid.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
             field2 TYPE i,
           END OF ty_test.

    DATA: ls_data  TYPE ty_test,
          lv_field TYPE string.

    ls_data-field1 = 'Test'.
    ls_data-field2 = 10.

    lv_field = 'field2'.

    TRY.
        " Call has_field method
        DATA(lv_result) = zcl_reflection=>has_field( is_data = ls_data iv_field = lv_field ).
        cl_abap_unit_assert=>assert_true( lv_result ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD has_field_invalid_structure.
    TRY.
        " Invalid structure type for has_field
        DATA(lv_result) = zcl_reflection=>has_field( is_data = 'not a structure' iv_field = 'field1' ).
        cl_abap_unit_assert=>fail( msg = 'Exception expected but not raised' ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( act = lx_error->get_text( ) exp = 'Provided object is not a structure.' ).
    ENDTRY.
  ENDMETHOD.

  METHOD has_field_field_not_found.
    TYPES: BEGIN OF ty_test,
             field1 TYPE string,
           END OF ty_test.

    DATA: ls_data TYPE ty_test.

    ls_data-field1 = 'Test'.

    TRY.
        " Try to check for a non-existing field
        DATA(lv_result) = zcl_reflection=>has_field( is_data = ls_data iv_field = 'field2' ).
        cl_abap_unit_assert=>assert_false( lv_result ).
      CATCH zcx_reflection_msg INTO DATA(lx_error).
        cl_abap_unit_assert=>fail( msg = lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.