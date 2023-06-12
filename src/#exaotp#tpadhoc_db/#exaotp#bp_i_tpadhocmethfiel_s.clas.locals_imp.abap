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
                                         ( entity = 'TpAdhocMethField' table = '/EXAOTP/T_TP_FLD' )
                                         ( entity = 'TpAdhocMethFielText' table = '/EXAOTP/T_TP_FLT' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/EXAOTP/I_TPADHOCMETHFIELD DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TpAdhocMethField
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocMethFieldAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TpAdhocMethField
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethFielText~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TpAdhocMethFielText~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TpAdhocMethFielText
        RESULT result,
      COPYTPADHOCMETHFIELD FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TpAdhocMethField~CopyTpAdhocMethField,
      get_instance_features_1 FOR INSTANCE FEATURES
            IMPORTING keys REQUEST requested_features FOR TpAdhocMethFieldAll RESULT result.

          METHODS get_global_authorizations_1 FOR GLOBAL AUTHORIZATION
            IMPORTING REQUEST requested_authorizations FOR TpAdhocMethFieldAll RESULT result.
          METHODS get_global_features_1 FOR GLOBAL FEATURES
            IMPORTING REQUEST requested_features FOR TpAdhocMethField RESULT result.

          METHODS ValidateDataConsistency_1 FOR VALIDATE ON SAVE
            IMPORTING keys FOR TpAdhocMethField~ValidateDataConsistency.

          METHODS ValidateTransportRequest_1 FOR VALIDATE ON SAVE
            IMPORTING keys FOR TpAdhocMethField~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_/EXAOTP/I_TPADHOCMETHFIELD IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyTpAdhocMethField = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
      ENTITY TpAdhocMethFieldAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
      ENTITY TpAdhocMethFieldAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/EXAOTP/I_TPADHOCMETHFIELD' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyTpAdhocMethField = is_authorized.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE /EXAOTP/I_TpAdhocMethField_S.
    SELECT SINGLE TransportRequestID
      FROM /EXAOTP/D_TFD_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = '/EXAOTP/T_TP_FLT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-TpAdhocMethFielText ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
*    READ ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
*      ENTITY TpAdhocMethFielText
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TpAdhocMethFielText).
*    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( '/EXAOTP/T_TP_FLT' ).
*    DATA: BEGIN OF element_check,
*            element  TYPE string,
*            check    TYPE ref to if_xco_dp_check,
*          END OF element_check,
*          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
*    LOOP AT TpAdhocMethFielText ASSIGNING FIELD-SYMBOL(<TpAdhocMethFielText>).
*      element_checks = VALUE #(
*        ( element = 'Method' check = table->field( 'METHOD' )->get_value_check( ia_value = <TpAdhocMethFielText>-Method  ) )
*        ( element = 'ColumnId' check = table->field( 'COLUMN_ID' )->get_value_check( ia_value = <TpAdhocMethFielText>-ColumnId
*              it_additional_fields = VALUE #(
*                ( table_name = '/EXAOTP/T_TP_FLT' field_name = 'METHOD' value = REF #( <TpAdhocMethFielText>-Method ) ) ) ) )
*      ).
*      LOOP AT element_checks INTO element_check.
*        element_check-check->execute( ).
*        CHECK element_check-check->passed = xco_cp=>boolean->false.
*        INSERT VALUE #( %TKY        = <TpAdhocMethFielText>-%TKY ) INTO TABLE failed-TpAdhocMethFielText.
*        INSERT VALUE #( %TKY        = <TpAdhocMethFielText>-%TKY
*                        %STATE_AREA = 'TpAdhocMethFielText_Input_Check' ) INTO TABLE reported-TpAdhocMethFielText.
*        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
*          INSERT VALUE #( %TKY = <TpAdhocMethFielText>-%TKY
*                          %STATE_AREA = 'TpAdhocMethFielText_Input_Check'
*                          %PATH-TpAdhocMethFieldAll-SingletonID = 1
*                          %PATH-TpAdhocMethFieldAll-%IS_DRAFT = <TpAdhocMethFielText>-%IS_DRAFT
*                          %PATH-TpAdhocMethField-%IS_DRAFT = <TpAdhocMethFielText>-%IS_DRAFT
*                          %PATH-TpAdhocMethField-Method = <TpAdhocMethFielText>-Method
*                          %PATH-TpAdhocMethField-ColumnId = <TpAdhocMethFielText>-ColumnId
*                          %msg = new_message(
*                                   id       = <msg>->value-msgid
*                                   number   = <msg>->value-msgno
*                                   severity = if_abap_behv_message=>severity-error
*                                   v1       = <msg>->value-msgv1
*                                   v2       = <msg>->value-msgv2
*                                   v3       = <msg>->value-msgv3
*                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-TpAdhocMethFielText ASSIGNING FIELD-SYMBOL(<rep>).
*          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
*          <comp> = if_abap_behv=>mk-on.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/EXAOTP/T_TP_FLT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYTPADHOCMETHFIELD.
    DATA new_TpAdhocMethField TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocMethField_S\_TpAdhocMethField.
    DATA new_TpAdhocMethFielText TYPE TABLE FOR CREATE /EXAOTP/I_TpAdhocMethField_S\\TpAdhocMethField\_TpAdhocMethFielText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TpAdhocMethField = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
      ENTITY TpAdhocMethField
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_TpAdhocMethField)
      FAILED DATA(read_failed).
    READ ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
      ENTITY TpAdhocMethField BY \_TpAdhocMethFielText
      ALL FIELDS WITH CORRESPONDING #( ref_TpAdhocMethField )
      RESULT DATA(ref_TpAdhocMethFielText).

    LOOP AT ref_TpAdhocMethField ASSIGNING FIELD-SYMBOL(<ref_TpAdhocMethField>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TpAdhocMethField>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TpAdhocMethField>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TpAdhocMethField>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TpAdhocMethField> EXCEPT
            Chnam
            ColumnId
            Crnam
            Crtimestamp
            LastChangedAt
            LocalLastChangedAt
            Method
            SingletonID
        ) ) )
      ) TO new_TpAdhocMethField ASSIGNING FIELD-SYMBOL(<new_TpAdhocMethField>).
      <new_TpAdhocMethField>-%TARGET[ 1 ]-Method = key-%PARAM-Method.
      <new_TpAdhocMethField>-%TARGET[ 1 ]-ColumnId = key-%PARAM-ColumnId.
      FIELD-SYMBOLS <new_TpAdhocMethFielText> LIKE LINE OF new_TpAdhocMethFielText.
      UNASSIGN <new_TpAdhocMethFielText>.
      LOOP AT ref_TpAdhocMethFielText ASSIGNING FIELD-SYMBOL(<ref_TpAdhocMethFielText>) USING KEY draft WHERE %TKY-%IS_DRAFT = key-%TKY-%IS_DRAFT
              AND %TKY-Method = key-%TKY-Method
              AND %TKY-ColumnId = key-%TKY-ColumnId.
        IF <new_TpAdhocMethFielText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = key_cid
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_TpAdhocMethFielText ASSIGNING <new_TpAdhocMethFielText>.
        ENDIF.
        INSERT VALUE #( %CID = key_cid && <ref_TpAdhocMethFielText>-Spras
                        %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_TpAdhocMethFielText> EXCEPT
                                                 ColumnId
                                                 LocalLastChangedAt
                                                 Method
                                                 SingletonID
        ) ) INTO TABLE <new_TpAdhocMethFielText>-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        <target>-%KEY-Method = key-%PARAM-Method.
        <target>-%KEY-ColumnId = key-%PARAM-ColumnId.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF /EXAOTP/I_TpAdhocMethField_S IN LOCAL MODE
      ENTITY TpAdhocMethFieldAll CREATE BY \_TpAdhocMethField
      FIELDS (
               Method
               ColumnId
               Percent
               Enabled
               Hide
               ReadOnly
               Param
               Formula
               Seq
               QtyFlag
               CurrencyInd
               RefTooltip
               QtyCurrField
               SavedParam
               ErrorFlag
               MaxLength
               Filter
               DropDownFlag
               EditParamFlag
               Hierarchyposition
               Service
               F4Flag
               DataElement
               Entity
               CheckBoxFlag
             ) WITH new_TpAdhocMethField
      ENTITY TpAdhocMethField CREATE BY \_TpAdhocMethFielText
      FIELDS (
               Spras
               Method
               ColumnId
               Description
             ) WITH new_TpAdhocMethFielText
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-TpAdhocMethField = mapped_create-TpAdhocMethField.
    INSERT LINES OF read_failed-TpAdhocMethField INTO TABLE failed-TpAdhocMethField.

    IF failed-TpAdhocMethField IS INITIAL.
      reported-TpAdhocMethField = VALUE #( FOR created IN mapped-TpAdhocMethField (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTpAdhocMethField = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TpAdhocMethFieldAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TpAdhocMethFieldAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD get_instance_features_1.
  ENDMETHOD.

  METHOD get_global_authorizations_1.
  ENDMETHOD.

  METHOD get_global_features_1.
  ENDMETHOD.

  METHOD ValidateDataConsistency_1.
  ENDMETHOD.

  METHOD ValidateTransportRequest_1.
  ENDMETHOD.

ENDCLASS.
CLASS LSC_/EXAOTP/I_TPADHOCMETHFIELD DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_/EXAOTP/I_TPADHOCMETHFIELD IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TpAdhocMethFieldAll INDEX 1 INTO DATA(all).
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
