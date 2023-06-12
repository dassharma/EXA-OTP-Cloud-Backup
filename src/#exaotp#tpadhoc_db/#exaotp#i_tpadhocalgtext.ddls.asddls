@EndUserText.label: 'TP Adhoc Method Algorithms Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity /EXAOTP/I_TpAdhocAlgText
  as select from /EXAOTP/T_TP_ALT
  association [1..1] to /EXAOTP/I_TpAdhocAlg_S as _TpAdhocAlgAll on $projection.SingletonID = _TpAdhocAlgAll.SingletonID
  association to parent /EXAOTP/I_TpAdhocAlg as _TpAdhocAlg on $projection.Method = _TpAdhocAlg.Method and $projection.Algorithm = _TpAdhocAlg.Algorithm
  association [0..*] to I_LanguageText as _LanguageText on $projection.Spras = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key SPRAS as Spras,
  key METHOD as Method,
  key ALGORITHM as Algorithm,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocAlgAll,
  _TpAdhocAlg,
  _LanguageText
  
}
