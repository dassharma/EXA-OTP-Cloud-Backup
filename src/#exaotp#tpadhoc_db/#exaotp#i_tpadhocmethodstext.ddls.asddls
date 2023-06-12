@EndUserText.label: 'TP Adhoc Pricing Methods Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity /EXAOTP/I_TpAdhocMethodsText
  as select from /EXAOTP/T_TP_PMT
  association [1..1] to /EXAOTP/I_TpAdhocMethods_S as _TpAdhocMethodsAll on $projection.SingletonID = _TpAdhocMethodsAll.SingletonID
  association to parent /EXAOTP/I_TpAdhocMethods as _TpAdhocMethods on $projection.Method = _TpAdhocMethods.Method
  association [0..*] to I_LanguageText as _LanguageText on $projection.Spras = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key SPRAS as Spras,
  key METHOD as Method,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocMethodsAll,
  _TpAdhocMethods,
  _LanguageText
  
}
