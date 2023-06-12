@EndUserText.label: 'Maintain TP Adhoc Method Algorithms'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocAlg
  as projection on /EXAOTP/I_TpAdhocAlg
{
  key Method,
  key Algorithm,
  ActiveFlag,
  Crnam,
  Crtimestamp,
  Chnam,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _TpAdhocAlgAll : redirected to parent /EXAOTP/C_TpAdhocAlg_S,
  _TpAdhocAlgText : redirected to composition child /EXAOTP/C_TpAdhocAlgText,
  _TpAdhocAlgText.Description : localized
  
}
