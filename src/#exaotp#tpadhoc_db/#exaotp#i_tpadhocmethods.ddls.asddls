@EndUserText.label: 'TP Adhoc Pricing Methods'
@AccessControl.authorizationCheck: #CHECK
define view entity /EXAOTP/I_TpAdhocMethods
  as select from /exaotp/t_tp_pm
  association to parent /EXAOTP/I_TpAdhocMethods_S as _TpAdhocMethodsAll on $projection.SingletonID = _TpAdhocMethodsAll.SingletonID
  composition [0..*] of /EXAOTP/I_TpAdhocMethodsText as _TpAdhocMethodsText
{
  key method as Method,
  active_flag as ActiveFlag,
  create_flag as CreateFlag,
  @Semantics.user.createdBy: true
  crnam as Crnam, 
  @Semantics.systemDateTime.createdAt: true
  crtimestamp as Crtimestamp,
  @Semantics.user.lastChangedBy: true
  chnam as Chnam, 
  @Semantics.systemDateTime.lastChangedAt: true  
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocMethodsAll,
  _TpAdhocMethodsText
  
}
