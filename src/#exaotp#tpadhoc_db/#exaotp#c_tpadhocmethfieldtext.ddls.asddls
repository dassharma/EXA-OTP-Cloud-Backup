@EndUserText.label: 'Maintain TP Adhoc Pricing Method Fields '
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocMethFieldText
  as projection on /EXAOTP/I_TpAdhocMethFieldText
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
  key ColumnId,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _TpAdhocMethField : redirected to parent /EXAOTP/C_TpAdhocMethField,
  _TpAdhocMethFieldAll : redirected to /EXAOTP/C_TpAdhocMethField_S
  
}
