  METHOD map_values.

    FIELD-SYMBOLS: <ls_param> TYPE ty_param ,
                   <lv_value> TYPE any.

    READ TABLE mt_param ASSIGNING <ls_param>
    WITH KEY structure = iv_structure BINARY SEARCH.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF cv_map IS REQUESTED.
      cv_map = <ls_param>-value.
      RETURN.
    ENDIF.


    LOOP AT mt_param ASSIGNING <ls_param> FROM sy-tabix.

      IF <ls_param>-structure <> iv_structure.
        EXIT.
      ENDIF.

      ASSIGN COMPONENT <ls_param>-name OF STRUCTURE cs_map TO <lv_value>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      <lv_value> =  <ls_param>-value.

      IF cs_mapx IS NOT REQUESTED.
        CONTINUE.
      ENDIF.

      ASSIGN COMPONENT <ls_param>-name OF STRUCTURE cs_mapx TO <lv_value>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      <lv_value> =  abap_true.

    ENDLOOP.

  ENDMETHOD.    
