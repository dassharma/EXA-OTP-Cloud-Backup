@EndUserText.label: 'Maintain TP Adhoc Method Algorithms Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocAlgText
  as projection on /EXAOTP/I_TpAdhocAlgText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Spras,
  key Method,
  key Algorithm,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _TpAdhocAlg : redirected to parent /EXAOTP/C_TpAdhocAlg,
  _TpAdhocAlgAll : redirected to /EXAOTP/C_TpAdhocAlg_S
  
}
