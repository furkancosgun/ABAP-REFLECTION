CLASS zcx_reflection_msg DEFINITION
  INHERITING FROM cx_static_check
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          previous LIKE previous OPTIONAL
          message  TYPE clike
          p1       TYPE clike OPTIONAL
          p2       TYPE clike OPTIONAL
          p3       TYPE clike OPTIONAL
          p4       TYPE clike OPTIONAL.
    METHODS
      get_text
        REDEFINITION .
  PRIVATE SECTION.
    DATA:message TYPE string.
ENDCLASS.



CLASS zcx_reflection_msg IMPLEMENTATION.
  METHOD:constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    me->message = message.
    IF p1 IS SUPPLIED.
      REPLACE ALL OCCURRENCES OF '&1' IN me->message WITH p1.
    ENDIF.
    IF p2 IS SUPPLIED.
      REPLACE ALL OCCURRENCES OF '&2' IN me->message WITH p2.
    ENDIF.
    IF p3 IS SUPPLIED.
      REPLACE ALL OCCURRENCES OF '&3' IN me->message WITH p3.
    ENDIF.
    IF p4 IS SUPPLIED.
      REPLACE ALL OCCURRENCES OF '&4' IN me->message WITH p4.
    ENDIF.
  ENDMETHOD.
  METHOD:get_text.
    result = message.
  ENDMETHOD.
ENDCLASS.