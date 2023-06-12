@EndUserText.label: 'TP Adhoc Method Algorithms'
@AccessControl.authorizationCheck: #CHECK
define view entity /EXAOTP/I_TpAdhocAlg
  as select from /exaotp/t_tp_alg
  association to parent /EXAOTP/I_TpAdhocAlg_S as _TpAdhocAlgAll on $projection.SingletonID = _TpAdhocAlgAll.SingletonID
  composition [0..*] of /EXAOTP/I_TpAdhocAlgText as _TpAdhocAlgText
{
  key method as Method,
  key algorithm as Algorithm,
  active_flag as ActiveFlag,
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
  _TpAdhocAlgAll,
  _TpAdhocAlgText
  
}
