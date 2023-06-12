@EndUserText.label: 'TP Adhoc Algorithms Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity /EXAOTP/I_TpAdhocAlg_S
  as select from I_Language
    left outer join /EXAOTP/T_TP_ALG on 0 = 0
  composition [0..*] of /EXAOTP/I_TpAdhocAlg as _TpAdhocAlg
{
  key 1 as SingletonID,
  _TpAdhocAlg,
  max( /EXAOTP/T_TP_ALG.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
