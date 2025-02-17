  go_arch_mand->populate_vrm_values(
    iv_table_name = 'YMCMS_ARC_ST_RIN'
    iv_key_field  = 'STATO_PROX_RIN'
    iv_text_field = 'DESCRIZIONE'
    iv_vrm_id     = CONV vrm_id( 'GS_SCREEN_FIELDS-STATO_PROS_RIN' ) ).

    METHODS populate_vrm_values IMPORTING iv_table_name TYPE string
                                          iv_key_field  TYPE string
                                          iv_text_field TYPE string
                                          iv_vrm_id     TYPE vrm_id.


  METHOD  populate_vrm_values.

    DATA: lt_data  TYPE STANDARD TABLE OF string,
          lt_list  TYPE vrm_values,
          ls_value TYPE vrm_value,
          lt_ref   TYPE REF TO data,
          lo_descr TYPE REF TO cl_abap_structdescr,
          lo_data  TYPE REF TO cl_abap_datadescr.

    FIELD-SYMBOLS: <lt_data> TYPE STANDARD TABLE,
                   <ls_data> TYPE any,
                   <lv_key>  TYPE any,
                   <lv_text> TYPE any.

    CREATE DATA lt_ref TYPE TABLE OF (iv_table_name).
    ASSIGN lt_ref->* TO <lt_data>.

    SELECT * FROM (iv_table_name) INTO TABLE <lt_data>.

    LOOP AT <lt_data> ASSIGNING <ls_data>.
      ASSIGN COMPONENT iv_key_field OF STRUCTURE <ls_data> TO <lv_key>.
      ASSIGN COMPONENT iv_text_field OF STRUCTURE <ls_data> TO <lv_text>.

      IF sy-subrc = 0.
        ls_value = VALUE vrm_value( key = <lv_key> text = <lv_text> ).
        APPEND ls_value TO lt_list.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = iv_vrm_id
        values = lt_list.

  ENDMETHOD.
