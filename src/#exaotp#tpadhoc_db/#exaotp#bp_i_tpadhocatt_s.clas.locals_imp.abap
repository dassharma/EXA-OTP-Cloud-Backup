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
                                         ( entity = 'TpAdhocAtt' table = '/EXAOTP/T_TP_ATT' )
                                         ( entity = 'TpAdhocAttText' table = '/EXAOTP/T_TP_ART' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCATT_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocAttAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocAttAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocAttAll
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCATT_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = '/EXAOTP/T_TP_ATT'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = '/EXAOTP/T_TP_ATT'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
    ENTITY TpAdhocAttAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TpAdhocAtt = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
      ENTITY TpAdhocAttAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
      ENTITY TpAdhocAttAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCATT' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_/EXAOTP/I_TPADHOCATT_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_/EXAOTP/I_TPADHOCATT_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TpAdhocAttAll INDEX 1 INTO DATA(all).
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
CLASS LHC_/EXAOTP/I_TPADHOCATT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAtt~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAtt~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocAtt
        RESULT result,
      COPYTPADHOCATT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocAtt~CopyTpAdhocAtt,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocAtt
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocAtt
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCATT IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocAtt_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_TATT_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_ATT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocAtt ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
*      ENTITY TpAdhocAtt
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocAtt).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_ATT' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocAtt ASSIGNING FIELD-SYMBOL(<TpAdhocAtt>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocAtt>-Method  ) )
*        ( element = 'Algorithm' check = table->field( 'ALGORITHM' )->get_value_check( ia_value = <TpAdhocAtt>-Algorithm
*              it_additional_fields = VALUE #(
*                ( table_name = '/EXAOTP/T_TP_ATT' field_name = 'METHOD' value = REF #( <TpAdhocAtt>-Method ) ) ) ) )
*        ( element = 'TpParamType' check = table->field( 'TP_PARAM_TYPE' )->get_value_check( ia_value = <TpAdhocAtt>-TpParamType  ) )
*        ( element = 'Percent' check = table->field( 'PERCENT' )->get_value_check( ia_value = <TpAdhocAtt>-Percent  ) )
*        ( element = 'Enabled' check = table->field( 'ENABLED' )->get_value_check( ia_value = <TpAdhocAtt>-Enabled  ) )
*        ( element = 'KpiInd' check = table->field( 'KPI_IND' )->get_value_check( ia_value = <TpAdhocAtt>-KpiInd  ) )
*        ( element = 'TpOutput' check = table->field( 'TP_OUTPUT' )->get_value_check( ia_value = <TpAdhocAtt>-TpOutput  ) )
*        ( element = 'TpResult' check = table->field( 'TP_RESULT' )->get_value_check( ia_value = <TpAdhocAtt>-TpResult  ) )
*        ( element = 'TpFinOutput' check = table->field( 'TP_FIN_OUTPUT' )->get_value_check( ia_value = <TpAdhocAtt>-TpFinOutput  ) )
*        ( element = 'TpIccomp' check = table->field( 'TP_ICCOMP' )->get_value_check( ia_value = <TpAdhocAtt>-TpIccomp  ) )
*        ( element = 'ConvRel' check = table->field( 'CONV_REL' )->get_value_check( ia_value = <TpAdhocAtt>-ConvRel  ) )
*        ( element = 'PropInd' check = table->field( 'PROP_IND' )->get_value_check( ia_value = <TpAdhocAtt>-PropInd  ) )
*        ( element = 'PropTpInd' check = table->field( 'PROP_TP_IND' )->get_value_check( ia_value = <TpAdhocAtt>-PropTpInd  ) )
*        ( element = 'Tprice' check = table->field( 'TPRICE' )->get_value_check( ia_value = <TpAdhocAtt>-Tprice  ) )
*        ( element = 'CurrencyInd' check = table->field( 'CURRENCY_IND' )->get_value_check( ia_value = <TpAdhocAtt>-CurrencyInd  ) )
*        ( element = 'GroupCurr' check = table->field( 'GROUP_CURR' )->get_value_check( ia_value = <TpAdhocAtt>-GroupCurr  ) )
*        ( element = 'TpChange' check = table->field( 'TP_CHANGE' )->get_value_check( ia_value = <TpAdhocAtt>-TpChange  ) )
*        ( element = 'DropDownFlag' check = table->field( 'DROP_DOWN_FLAG' )->get_value_check( ia_value = <TpAdhocAtt>-DropDownFlag  ) )
*        ( element = 'CheckBoxFlag' check = table->field( 'CHECK_BOX_FLAG' )->get_value_check( ia_value = <TpAdhocAtt>-CheckBoxFlag  ) )
*        ( element = 'F4Flag' check = table->field( 'F4_FLAG' )->get_value_check( ia_value = <TpAdhocAtt>-F4Flag  ) )
*        ( element = 'Hide' check = table->field( 'HIDE' )->get_value_check( ia_value = <TpAdhocAtt>-Hide  ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocAtt>-%TKY ) INTO TABLE failed-TpAdhocAtt.
*        INSERT VALUE #( %TKY        = <TpAdhocAtt>-%TKY
*                        %STATE_AREA = 'TpAdhocAtt_Input_Check' ) INTO TABLE reported-TpAdhocAtt.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocAtt>-%TKY
*                          %STATE_AREA = 'TpAdhocAtt_Input_Check'
*                          %PATH-TpAdhocAttAll-SingletonID = 1
*                          %PATH-TpAdhocAttAll-%IS_DRAFT = <TpAdhocAtt>-%IS_DRAFT
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocAtt ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_ATT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_TpAdhocAttText = edit_flag.
  ENDMETHOD.
  METHOD COPYTPADHOCATT.
    DATA new_TpAdhocAtt TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocAtt_S\_TpAdhocAtt.
    DATA new_TpAdhocAttText TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocAtt_S\\TpAdhocAtt\_TpAdhocAttText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TpAdhocAtt = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
      ENTITY TpAdhocAtt
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_TpAdhocAtt)
      FAILED DATA(read_failed).
    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
      ENTITY TpAdhocAtt BY \_TpAdhocAttText
      ALL FIELDS WITH CORRESPONDING #( ref_TpAdhocAtt )
      RESULT DATA(ref_TpAdhocAttText).

    LOOP AT ref_TpAdhocAtt ASSIGNING FIELD-SYMBOL(<ref_TpAdhocAtt>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TpAdhocAtt>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TpAdhocAtt>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TpAdhocAtt>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TpAdhocAtt> EXCEPT
            Algorithm
            Chnam
            Crnam
            Crtimestamp
            LastChangedAt
            LocalLastChangedAt
            Method
            NodeId
            SingletonID
            TpParamType
        ) ) )
      ) TO new_TpAdhocAtt ASSIGNING FIELD-SYMBOL(<new_TpAdhocAtt>).
      <new_TpAdhocAtt>-%TARGET[ 1 ]-Method = key-%PARAM-Method.
      <new_TpAdhocAtt>-%TARGET[ 1 ]-Algorithm = key-%PARAM-Algorithm.
      <new_TpAdhocAtt>-%TARGET[ 1 ]-NodeId = key-%PARAM-NodeId.
      <new_TpAdhocAtt>-%TARGET[ 1 ]-TpParamType = key-%PARAM-TpParamType.
      FIELD-SYMBOLS <new_TpAdhocAttText> LIKE LINE OF new_TpAdhocAttText.
      UNASSIGN <new_TpAdhocAttText>.
      LOOP AT ref_TpAdhocAttText ASSIGNING FIELD-SYMBOL(<ref_TpAdhocAttText>) USING KEY draft WHERE %TKY-%IS_DRAFT = key-%TKY-%IS_DRAFT
              AND %TKY-Method = key-%TKY-Method
              AND %TKY-Algorithm = key-%TKY-Algorithm
              AND %TKY-NodeId = key-%TKY-NodeId
              AND %TKY-TpParamType = key-%TKY-TpParamType.
        IF <new_TpAdhocAttText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = key_cid
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_TpAdhocAttText ASSIGNING <new_TpAdhocAttText>.
        ENDIF.
        INSERT VALUE #( %CID = key_cid && <ref_TpAdhocAttText>-Spras
                        %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_TpAdhocAttText> EXCEPT
                                                 Algorithm
                                                 LocalLastChangedAt
                                                 Method
                                                 NodeId
                                                 SingletonID
                                                 TpParamType
        ) ) INTO TABLE <new_TpAdhocAttText>-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        <target>-%KEY-Method = key-%PARAM-Method.
        <target>-%KEY-Algorithm = key-%PARAM-Algorithm.
        <target>-%KEY-NodeId = key-%PARAM-NodeId.
        <target>-%KEY-TpParamType = key-%PARAM-TpParamType.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
      ENTITY TpAdhocAttAll CREATE BY \_TpAdhocAtt
      FIELDS (
               Method
               Algorithm
               NodeId
               TpParamType
               Formula
               Percent
               Enabled
               KpiInd
               Source
               Seq
               DefValue
               TpOutput
               TpResult
               TpFinOutput
               TpIccomp
               CalPrio
               ConvRel
               PropInd
               PropTpInd
               Tprice
               CurrencyInd
               GroupCurr
               TpChange
               Service
               Entity
               DropDownFlag
               CheckBoxFlag
               F4Flag
               DataElement
               Hide
             ) WITH new_TpAdhocAtt
      ENTITY TpAdhocAtt CREATE BY \_TpAdhocAttText
      FIELDS (
               Method
               Algorithm
               NodeId
               TpParamType
               Spras
               Description
             ) WITH new_TpAdhocAttText
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-TpAdhocAtt = mapped_create-TpAdhocAtt.
    INSERT LINES OF read_failed-TpAdhocAtt INTO TABLE failed-TpAdhocAtt.

    IF failed-TpAdhocAtt IS INITIAL.
      reported-TpAdhocAtt = VALUE #( FOR created IN mapped-TpAdhocAtt (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTpAdhocAtt = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TpAdhocAttAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TpAdhocAttAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCATT' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyTpAdhocAtt = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyTpAdhocAtt = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCATTTEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAttText~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocAttText~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocAttText
        RESULT result.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCATTTEXT IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocAtt_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_TATT_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_ART'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocAttText ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocAtt_S IN LOCAL MODE
*      ENTITY TpAdhocAttText
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocAttText).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_ART' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocAttText ASSIGNING FIELD-SYMBOL(<TpAdhocAttText>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocAttText>-Method  ) )
*        ( element = 'Algorithm' check = table->field( 'ALGORITHM' )->get_value_check( ia_value = <TpAdhocAttText>-Algorithm  ) )
*        ( element = 'TpParamType' check = table->field( 'TP_PARAM_TYPE' )->get_value_check( ia_value = <TpAdhocAttText>-TpParamType
*              it_additional_fields = VALUE #(
*                ( table_name = '/EXAOTP/T_TP_ART' field_name = 'METHOD' value = REF #( <TpAdhocAttText>-Method ) )
*                ( table_name = '/EXAOTP/T_TP_ART' field_name = 'ALGORITHM' value = REF #( <TpAdhocAttText>-Algorithm ) )
*                ( table_name = '/EXAOTP/T_TP_ART' field_name = 'NODE_ID' value = REF #( <TpAdhocAttText>-NodeId ) ) ) ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocAttText>-%TKY ) INTO TABLE failed-TpAdhocAttText.
*        INSERT VALUE #( %TKY        = <TpAdhocAttText>-%TKY
*                        %STATE_AREA = 'TpAdhocAttText_Input_Check' ) INTO TABLE reported-TpAdhocAttText.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocAttText>-%TKY
*                          %STATE_AREA = 'TpAdhocAttText_Input_Check'
*                          %PATH-TpAdhocAttAll-SingletonID = 1
*                          %PATH-TpAdhocAttAll-%IS_DRAFT = <TpAdhocAttText>-%IS_DRAFT
*                          %PATH-TpAdhocAtt-%IS_DRAFT = <TpAdhocAttText>-%IS_DRAFT
*                          %PATH-TpAdhocAtt-Method = <TpAdhocAttText>-Method
*                          %PATH-TpAdhocAtt-Algorithm = <TpAdhocAttText>-Algorithm
*                          %PATH-TpAdhocAtt-NodeId = <TpAdhocAttText>-NodeId
*                          %PATH-TpAdhocAtt-TpParamType = <TpAdhocAttText>-TpParamType
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocAttText ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_ART'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
