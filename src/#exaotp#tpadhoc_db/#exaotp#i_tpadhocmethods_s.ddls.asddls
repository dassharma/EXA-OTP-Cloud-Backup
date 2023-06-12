@EndUserText.label: 'TP Adhoc Pricing Methods Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity /EXAOTP/I_TpAdhocMethods_S
  as select from I_Language
    left outer join /exaotp/t_tp_pm on 0 = 0
  composition [0..*] of /EXAOTP/I_TpAdhocMethods as _TpAdhocMethods
{
  key 1 as SingletonID,
  _TpAdhocMethods,
  max( /exaotp/t_tp_pm.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
