@EndUserText.label: 'Maintain TP Adhoc Pricing Methods Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocMethodsText
  as projection on /EXAOTP/I_TpAdhocMethodsText
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
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _TpAdhocMethods : redirected to parent /EXAOTP/C_TpAdhocMethods,
  _TpAdhocMethodsAll : redirected to /EXAOTP/C_TpAdhocMethods_S
  
}
