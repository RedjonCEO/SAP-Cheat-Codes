REPORT zrd_join_fields.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_tab1 TYPE dd03l-tabname.
PARAMETERS: p_tab2 TYPE dd03l-tabname.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_fname RADIOBUTTON GROUP g1,
            p_tname RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

DATA: lt_table1        TYPE TABLE OF dd03l,
      lt_table2        TYPE TABLE OF dd03l,
      lt_common_fields TYPE TABLE OF dd03l-fieldname,
      lv_title         TYPE string.

SELECT * FROM dd03l INTO TABLE lt_table1 WHERE tabname = p_tab1.
SELECT * FROM dd03l INTO TABLE lt_table2 WHERE tabname = p_tab2.

CASE abap_true.
  WHEN p_fname.
    LOOP AT lt_table1 INTO DATA(ls_field1).
      READ TABLE lt_table2 INTO DATA(ls_field2) WITH KEY fieldname = ls_field1-fieldname.
      IF sy-subrc = 0.
        APPEND ls_field1-fieldname TO lt_common_fields.
      ENDIF.
    ENDLOOP.
    CONCATENATE 'Common fields of ' p_tab1 ' and ' p_tab2 ' compared by fieldnames are: ' INTO lv_title SEPARATED BY space.
  WHEN p_tname.
    LOOP AT lt_table1 INTO ls_field1.
      READ TABLE lt_table2 INTO ls_field2 WITH KEY rollname = ls_field1-rollname.
      IF sy-subrc = 0.
        APPEND ls_field1-rollname TO lt_common_fields.
      ENDIF.
    ENDLOOP.
    CONCATENATE 'Common fields of ' p_tab1 ' and ' p_tab2 ' compared by technical names are: ' INTO lv_title SEPARATED BY space.
ENDCASE.

  WRITE: lv_title.

LOOP AT lt_common_fields INTO DATA(ls_common).
  IF ls_common(1) = '.'.
    CONTINUE.
  ENDIF.
  WRITE: / ls_common.
ENDLOOP.
