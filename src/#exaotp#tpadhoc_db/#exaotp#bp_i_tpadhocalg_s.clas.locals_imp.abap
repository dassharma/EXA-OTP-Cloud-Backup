CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'TpAdhocAlg' table = '/EXAOTP/T_TP_ALG' )
                                         ( entity = 'TpAdhocAlgText' table = '/EXAOTP/T_TP_ALT' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCALG_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocAlgAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocAlgAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocAlgAll
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCALG_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = '/EXAOTP/T_TP_ALG'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = '/EXAOTP/T_TP_ALG'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
    ENTITY TpAdhocAlgAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TpAdhocAlg = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
      ENTITY TpAdhocAlgAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
      ENTITY TpAdhocAlgAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCALG' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_/EXAOTP/I_TPADHOCALG_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_/EXAOTP/I_TPADHOCALG_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TpAdhocAlgAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCALG DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAlg~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAlg~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocAlg
        RESULT result,
      COPYTPADHOCALG FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocAlg~CopyTpAdhocAlg,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocAlg
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocAlg
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCALG IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocAlg_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_TALG_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_ALG'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocAlg ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
*      ENTITY TpAdhocAlg
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocAlg).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_ALG' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocAlg ASSIGNING FIELD-SYMBOL(<TpAdhocAlg>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocAlg>-Method
*              it_additional_fields = VALUE #( ) ) )
*        ( element = 'Algorithm' check = table->field( 'ALGORITHM' )->get_value_check( ia_value = <TpAdhocAlg>-Algorithm  ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocAlg>-%TKY ) INTO TABLE failed-TpAdhocAlg.
*        INSERT VALUE #( %TKY        = <TpAdhocAlg>-%TKY
*                        %STATE_AREA = 'TpAdhocAlg_Input_Check' ) INTO TABLE reported-TpAdhocAlg.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocAlg>-%TKY
*                          %STATE_AREA = 'TpAdhocAlg_Input_Check'
*                          %PATH-TpAdhocAlgAll-SingletonID = 1
*                          %PATH-TpAdhocAlgAll-%IS_DRAFT = <TpAdhocAlg>-%IS_DRAFT
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocAlg ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_ALG'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_TpAdhocAlgText = edit_flag.
  ENDMETHOD.
  METHOD COPYTPADHOCALG.
    DATA new_TpAdhocAlg TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocAlg_S\_TpAdhocAlg.
    DATA new_TpAdhocAlgText TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocAlg_S\\TpAdhocAlg\_TpAdhocAlgText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TpAdhocAlg = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
      ENTITY TpAdhocAlg
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_TpAdhocAlg)
      FAILED DATA(read_failed).
    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
      ENTITY TpAdhocAlg BY \_TpAdhocAlgText
      ALL FIELDS WITH CORRESPONDING #( ref_TpAdhocAlg )
      RESULT DATA(ref_TpAdhocAlgText).

    LOOP AT ref_TpAdhocAlg ASSIGNING FIELD-SYMBOL(<ref_TpAdhocAlg>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TpAdhocAlg>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TpAdhocAlg>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TpAdhocAlg>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TpAdhocAlg> EXCEPT
            Algorithm
            Chnam
            Crnam
            Crtimestamp
            LastChangedAt
            LocalLastChangedAt
            Method
            SingletonID
        ) ) )
      ) TO new_TpAdhocAlg ASSIGNING FIELD-SYMBOL(<new_TpAdhocAlg>).
      <new_TpAdhocAlg>-%TARGET[ 1 ]-Method = key-%PARAM-Method.
      <new_TpAdhocAlg>-%TARGET[ 1 ]-Algorithm = key-%PARAM-Algorithm.
      FIELD-SYMBOLS <new_TpAdhocAlgText> LIKE LINE OF new_TpAdhocAlgText.
      UNASSIGN <new_TpAdhocAlgText>.
      LOOP AT ref_TpAdhocAlgText ASSIGNING FIELD-SYMBOL(<ref_TpAdhocAlgText>) USING KEY draft WHERE %TKY-%IS_DRAFT = key-%TKY-%IS_DRAFT
              AND %TKY-Method = key-%TKY-Method
              AND %TKY-Algorithm = key-%TKY-Algorithm.
        IF <new_TpAdhocAlgText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = key_cid
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_TpAdhocAlgText ASSIGNING <new_TpAdhocAlgText>.
        ENDIF.
        INSERT VALUE #( %CID = key_cid && <ref_TpAdhocAlgText>-Spras
                        %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_TpAdhocAlgText> EXCEPT
                                                 Algorithm
                                                 LocalLastChangedAt
                                                 Method
                                                 SingletonID
        ) ) INTO TABLE <new_TpAdhocAlgText>-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        <target>-%KEY-Method = key-%PARAM-Method.
        <target>-%KEY-Algorithm = key-%PARAM-Algorithm.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
      ENTITY TpAdhocAlgAll CREATE BY \_TpAdhocAlg
      FIELDS (
               Method
               Algorithm
               ActiveFlag
             ) WITH new_TpAdhocAlg
      ENTITY TpAdhocAlg CREATE BY \_TpAdhocAlgText
      FIELDS (
               Spras
               Method
               Algorithm
               Description
             ) WITH new_TpAdhocAlgText
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-TpAdhocAlg = mapped_create-TpAdhocAlg.
    INSERT LINES OF read_failed-TpAdhocAlg INTO TABLE failed-TpAdhocAlg.

    IF failed-TpAdhocAlg IS INITIAL.
      reported-TpAdhocAlg = VALUE #( FOR created IN mapped-TpAdhocAlg (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTpAdhocAlg = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TpAdhocAlgAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TpAdhocAlgAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCALG' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyTpAdhocAlg = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyTpAdhocAlg = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCALGTEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAlgText~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAlgText~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocAlgText
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCALGTEXT IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocAlg_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_TALG_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_ALT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocAlgText ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocAlg_S IN LOCAL MODE
*      ENTITY TpAdhocAlgText
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocAlgText).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_ALT' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocAlgText ASSIGNING FIELD-SYMBOL(<TpAdhocAlgText>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocAlgText>-Method  ) )
*        ( element = 'Algorithm' check = table->field( 'ALGORITHM' )->get_value_check( ia_value = <TpAdhocAlgText>-Algorithm
*              it_additional_fields = VALUE #(
*                ( table_name = '/EXAOTP/T_TP_ALT' field_name = 'METHOD' value = REF #( <TpAdhocAlgText>-Method ) ) ) ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocAlgText>-%TKY ) INTO TABLE failed-TpAdhocAlgText.
*        INSERT VALUE #( %TKY        = <TpAdhocAlgText>-%TKY
*                        %STATE_AREA = 'TpAdhocAlgText_Input_Check' ) INTO TABLE reported-TpAdhocAlgText.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocAlgText>-%TKY
*                          %STATE_AREA = 'TpAdhocAlgText_Input_Check'
*                          %PATH-TpAdhocAlgAll-SingletonID = 1
*                          %PATH-TpAdhocAlgAll-%IS_DRAFT = <TpAdhocAlgText>-%IS_DRAFT
*                          %PATH-TpAdhocAlg-%IS_DRAFT = <TpAdhocAlgText>-%IS_DRAFT
*                          %PATH-TpAdhocAlg-Method = <TpAdhocAlgText>-Method
*                          %PATH-TpAdhocAlg-Algorithm = <TpAdhocAlgText>-Algorithm
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocAlgText ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_ALT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
