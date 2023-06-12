@EndUserText.label: 'TP Adhoc Attributes Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity /EXAOTP/I_TpAdhocAtt_S
  as select from I_Language
    left outer join /EXAOTP/T_TP_ATT on 0 = 0
  composition [0..*] of /EXAOTP/I_TpAdhocAtt as _TpAdhocAtt
{
  key 1 as SingletonID,
  _TpAdhocAtt,
  max( /EXAOTP/T_TP_ATT.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
