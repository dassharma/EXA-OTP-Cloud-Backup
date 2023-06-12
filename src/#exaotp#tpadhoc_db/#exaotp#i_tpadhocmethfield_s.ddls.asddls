@EndUserText.label: 'TP Adhoc Pricing Method Fields Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity /EXAOTP/I_TpAdhocMethField_S
  as select from I_Language
    left outer join /EXAOTP/T_TP_FLD on 0 = 0
  composition [0..*] of /EXAOTP/I_TpAdhocMethField as _TpAdhocMethField
{
  key 1 as SingletonID,
  _TpAdhocMethField,
  max( /EXAOTP/T_TP_FLD.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
