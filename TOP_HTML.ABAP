 METHOD top_of_page.

    CONSTANTS: lc_color   TYPE string VALUE '#E5E8E8'.

    DATA: lv_fatt_blocked TYPE i,
          lv_fatt_unblckd TYPE i,
          lv_fatt_error   TYPE i,
          lt_html_tab     TYPE sdydo_html_table.

    CASE mv_ribal_status.
      WHEN 'S'.
        DATA(lv_status) = EXACT char9('Fatto').
        DATA(lv_color)  = EXACT char6('green').
      WHEN 'E'.
        lv_status = 'Errore'.
        lv_color = 'red'.
      WHEN 'W'.
        lv_status = 'In Attesa'.
        lv_color = 'orange'.
    ENDCASE.

    LOOP AT mt_fattura ASSIGNING FIELD-SYMBOL(<ls_fattura>).
      IF <ls_fattura>-id = icon_interval_exclude_red.
        lv_fatt_blocked = lv_fatt_blocked + 1.
      ELSE.
        lv_fatt_unblckd = lv_fatt_unblckd + 1.
      ENDIF.
    ENDLOOP.

    DATA(lv_text) = EXACT sdydo_text_element( |Fatture estrate : { lines( mt_fattura ) }| ).

    lt_html_tab = VALUE #( ( |<body style="background-color: { lc_color }; border: 1px solid gray; margin: 0; padding: 10px ">| )
                           ( |  <div style="display: flex; justify-content: space-between;">| )
                           ( |    <font style = "font-size: 12pt; font-weight:bold; color="black">| )
                           ( |      { lv_text }| )
                           ( |    </font>| )
                           ( |    <span>| )
                           ( |      <font style = "font-size: 9pt; font-family:Sans-Serif; font-weight:bold; user-select:none color="black";>| )
                           ( |        Ribaltamento status:| )
                           ( |      </font>| )
                           ( |      <font style = "font-size: 9pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="{ lv_color }">| )
                           ( |        { lv_status }| )
                           ( |      </font>| )
                           ( |    </span>| )
                           ( |  </div>| )
                           ( |  <hr style=" margin-left: 0;">| )
                           ( |  <font style = "font-size: 10pt; font-family:Sans-Serif; user-select:none" color="black">| )
                           ( |    N. fatture esclude :| )
                           ( |  </font>| )
                           ( |  <font style = "font-size: 10pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="green">| )
                           ( |    { lv_fatt_unblckd }|      )
                           ( |  </font> &nbsp &nbsp &nbsp| )
                           ( |  <font style = "font-size: 10pt; font-family:Sans-Serif; user-select:none" color="black">| )
                           ( |    N. fatture esclude :| )
                           ( |  </font>| )
                           ( |  <font style = "font-size: 10pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="red">| )
                           ( |    { lv_fatt_blocked }| )
                           ( |  </font>| )
                           ( |</body>| ) ).

    mo_top->add_static_html( table_with_html  = lt_html_tab ).


*    DATA(lv_cont) =  |<body style="background-color: { lc_color };  border: 1px solid gray; margin: 0; padding: 10px ">| &&
*                     |<div style="display: flex; justify-content: space-between;"> <font style = "font-size: 12pt;| &&
*                     |font-weight:bold;color="black"> | &&
*                     lv_text && |</font>|.
*    DATA(lv_row) =  1 .
*    mo_top->html_insert(
*      EXPORTING
*        contents = lv_cont
*      CHANGING
*        position = lv_row ).
*
*    lv_cont = |<span><font style = "font-size: 9pt; font-family:Sans-Serif; font-weight:bold; user-select:none color="black";> | &&
*              |Ribaltamento status: </font>|.
*    lv_row  = 2 .
*    mo_top->html_insert(
*      EXPORTING
*        contents = lv_cont
*      CHANGING
*        position = lv_row ).
*
*    lv_cont = |<font style = "font-size: 9pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="{ lv_color }">{ lv_status }| &&
*              |</font></span></div> <hr style=" margin-left: 0;">|.
*    lv_row  = 3 .
*    mo_top->html_insert(
*      EXPORTING
*        contents = lv_cont
*      CHANGING
*        position = lv_row ).
*
*    lv_cont = |<font style = "font-size: 10pt; font-family:Sans-Serif; user-select:none" color="black"> N. fatture ribaltabile : </font>| &&
*              |<font style = "font-size: 10pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="green">| &&
*              lv_fatt_unblckd && |</font> &nbsp&nbsp&nbsp|.
*    lv_row  = 4 .
*    mo_top->html_insert(
*      EXPORTING
*        contents = lv_cont
*      CHANGING
*        position = lv_row ).
*
*    lv_cont = |<font style = "font-size: 10pt; font-family:Sans-Serif; user-select:none" color="black"> N. fatture esclude : </font>| &&
*              |<font style = "font-size: 10pt; font-family:Sans-Serif; font-weight:bold; user-select:none" color="red">{ lv_fatt_blocked }</font></body>|.
*    lv_row  = 5.
*    mo_top->html_insert(
*      EXPORTING
*        contents = lv_cont
*      CHANGING
*        position = lv_row ).

    mo_top->merge_document( ).
    mo_top->display_document(
     EXPORTING
       reuse_control      = 'X'
       parent             = mo_top_cnt
     EXCEPTIONS
       html_display_error = 1
       OTHERS             = 2 ).

  ENDMETHOD.
