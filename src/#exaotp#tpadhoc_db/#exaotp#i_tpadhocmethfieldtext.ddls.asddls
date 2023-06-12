@EndUserText.label: 'TP Adhoc Pricing Method Fields Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity /EXAOTP/I_TpAdhocMethFieldText
  as select from /EXAOTP/T_TP_FLT
  association [1..1] to /EXAOTP/I_TpAdhocMethField_S as _TpAdhocMethFieldAll on $projection.SingletonID = _TpAdhocMethFieldAll.SingletonID
  association to parent /EXAOTP/I_TpAdhocMethField as _TpAdhocMethField on $projection.Method = _TpAdhocMethField.Method and $projection.ColumnId = _TpAdhocMethField.ColumnId
  association [0..*] to I_LanguageText as _LanguageText on $projection.Spras = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key SPRAS as Spras,
  key METHOD as Method,
  key COLUMN_ID as ColumnId,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocMethFieldAll,
  _TpAdhocMethField,
  _LanguageText
  
}
