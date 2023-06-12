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
                                         ( entity = 'TpAdhocMethods' table = '/EXAOTP/T_TP_PM' )
                                         ( entity = 'TpAdhocMethodsText' table = '/EXAOTP/T_TP_PMT' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCMETHODS_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocMethodsAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocMethodsAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocMethodsAll
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCMETHODS_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = '/EXAOTP/T_TP_PM'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = '/EXAOTP/T_TP_PM'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
    ENTITY TpAdhocMethodsAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TpAdhocMethods = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
      ENTITY TpAdhocMethodsAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
      ENTITY TpAdhocMethodsAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCMETHODS' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_/EXAOTP/I_TPADHOCMETHODS_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_/EXAOTP/I_TPADHOCMETHODS_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TpAdhocMethodsAll INDEX 1 INTO DATA(all).
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
CLASS LHC_/EXAOTP/I_TPADHOCMETHODS DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethods~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethods~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocMethods
        RESULT result,
      COPYTPADHOCMETHODS FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocMethods~CopyTpAdhocMethods,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocMethods
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocMethods
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCMETHODS IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocMethods_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_PM_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_PM'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocMethods ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
*      ENTITY TpAdhocMethods
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocMethods).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_PM' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocMethods ASSIGNING FIELD-SYMBOL(<TpAdhocMethods>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocMethods>-Method  ) )
*        ( element = 'CreateFlag' check = table->field( 'CREATE_FLAG' )->get_value_check( ia_value = <TpAdhocMethods>-CreateFlag  ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocMethods>-%TKY ) INTO TABLE failed-TpAdhocMethods.
*        INSERT VALUE #( %TKY        = <TpAdhocMethods>-%TKY
*                        %STATE_AREA = 'TpAdhocMethods_Input_Check' ) INTO TABLE reported-TpAdhocMethods.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocMethods>-%TKY
*                          %STATE_AREA = 'TpAdhocMethods_Input_Check'
*                          %PATH-TpAdhocMethodsAll-SingletonID = 1
*                          %PATH-TpAdhocMethodsAll-%IS_DRAFT = <TpAdhocMethods>-%IS_DRAFT
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocMethods ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_PM'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_TpAdhocMethodsText = edit_flag.
  ENDMETHOD.
  METHOD COPYTPADHOCMETHODS.
    DATA new_TpAdhocMethods TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocMethods_S\_TpAdhocMethods.
    DATA new_TpAdhocMethodsText TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocMethods_S\\TpAdhocMethods\_TpAdhocMethodsText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TpAdhocMethods = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
      ENTITY TpAdhocMethods
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_TpAdhocMethods)
      FAILED DATA(read_failed).
    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
      ENTITY TpAdhocMethods BY \_TpAdhocMethodsText
      ALL FIELDS WITH CORRESPONDING #( ref_TpAdhocMethods )
      RESULT DATA(ref_TpAdhocMethodsText).

    LOOP AT ref_TpAdhocMethods ASSIGNING FIELD-SYMBOL(<ref_TpAdhocMethods>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TpAdhocMethods>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TpAdhocMethods>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TpAdhocMethods>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TpAdhocMethods> EXCEPT
            Chnam
            Crnam
            Crtimestamp
            LastChangedAt
            LocalLastChangedAt
            Method
            SingletonID
        ) ) )
      ) TO new_TpAdhocMethods ASSIGNING FIELD-SYMBOL(<new_TpAdhocMethods>).
      <new_TpAdhocMethods>-%TARGET[ 1 ]-Method = key-%PARAM-Method.
      FIELD-SYMBOLS <new_TpAdhocMethodsText> LIKE LINE OF new_TpAdhocMethodsText.
      UNASSIGN <new_TpAdhocMethodsText>.
      LOOP AT ref_TpAdhocMethodsText ASSIGNING FIELD-SYMBOL(<ref_TpAdhocMethodsText>) USING KEY draft WHERE %TKY-%IS_DRAFT = key-%TKY-%IS_DRAFT
              AND %TKY-Method = key-%TKY-Method.
        IF <new_TpAdhocMethodsText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = key_cid
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_TpAdhocMethodsText ASSIGNING <new_TpAdhocMethodsText>.
        ENDIF.
        INSERT VALUE #( %CID = key_cid && <ref_TpAdhocMethodsText>-Spras
                        %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_TpAdhocMethodsText> EXCEPT
                                                 LocalLastChangedAt
                                                 Method
                                                 SingletonID
        ) ) INTO TABLE <new_TpAdhocMethodsText>-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        <target>-%KEY-Method = key-%PARAM-Method.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
      ENTITY TpAdhocMethodsAll CREATE BY \_TpAdhocMethods
      FIELDS (
               Method
               ActiveFlag
               CreateFlag
             ) WITH new_TpAdhocMethods
      ENTITY TpAdhocMethods CREATE BY \_TpAdhocMethodsText
      FIELDS (
               Spras
               Method
               Description
             ) WITH new_TpAdhocMethodsText
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-TpAdhocMethods = mapped_create-TpAdhocMethods.
    INSERT LINES OF read_failed-TpAdhocMethods INTO TABLE failed-TpAdhocMethods.

    IF failed-TpAdhocMethods IS INITIAL.
      reported-TpAdhocMethods = VALUE #( FOR created IN mapped-TpAdhocMethods (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTpAdhocMethods = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TpAdhocMethodsAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TpAdhocMethodsAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCMETHODS' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyTpAdhocMethods = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyTpAdhocMethods = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCMETHODSTE DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethodsText~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethodsText~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocMethodsText
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCMETHODSTE IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocMethods_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_PM_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_PMT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocMethodsText ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocMethods_S IN LOCAL MODE
*      ENTITY TpAdhocMethodsText
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocMethodsText).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_PMT' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocMethodsText ASSIGNING FIELD-SYMBOL(<TpAdhocMethodsText>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocMethodsText>-Method
*              it_additional_fields = VALUE #( ) ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocMethodsText>-%TKY ) INTO TABLE failed-TpAdhocMethodsText.
*        INSERT VALUE #( %TKY        = <TpAdhocMethodsText>-%TKY
*                        %STATE_AREA = 'TpAdhocMethodsText_Input_Check' ) INTO TABLE reported-TpAdhocMethodsText.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocMethodsText>-%TKY
*                          %STATE_AREA = 'TpAdhocMethodsText_Input_Check'
*                          %PATH-TpAdhocMethodsAll-SingletonID = 1
*                          %PATH-TpAdhocMethodsAll-%IS_DRAFT = <TpAdhocMethodsText>-%IS_DRAFT
*                          %PATH-TpAdhocMethods-%IS_DRAFT = <TpAdhocMethodsText>-%IS_DRAFT
*                          %PATH-TpAdhocMethods-Method = <TpAdhocMethodsText>-Method
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocMethodsText ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_PMT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
