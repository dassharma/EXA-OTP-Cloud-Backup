@EndUserText.label: 'Maintain TP Adhoc Attributes Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocAttText
  as projection on /EXAOTP/I_TpAdhocAttText
{
  key Method,
  key Algorithm,
  key NodeId,
  key TpParamType,
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Spras,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _TpAdhocAtt : redirected to parent /EXAOTP/C_TpAdhocAtt,
  _TpAdhocAttAll : redirected to /EXAOTP/C_TpAdhocAtt_S
  
}
