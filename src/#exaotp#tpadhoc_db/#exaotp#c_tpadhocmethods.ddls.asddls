@EndUserText.label: 'Maintain TP Adhoc Pricing Methods'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocMethods
  as projection on /EXAOTP/I_TpAdhocMethods
{
  key Method,
  ActiveFlag,
  CreateFlag,
  Crnam, 
  Crtimestamp,
  Chnam,  
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _TpAdhocMethodsAll : redirected to parent /EXAOTP/C_TpAdhocMethods_S,
  _TpAdhocMethodsText : redirected to composition child /EXAOTP/C_TpAdhocMethodsText,
  _TpAdhocMethodsText.Description : localized
  
}
