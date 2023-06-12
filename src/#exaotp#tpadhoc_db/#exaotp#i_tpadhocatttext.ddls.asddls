@EndUserText.label: 'TP Adhoc Attributes Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity /EXAOTP/I_TpAdhocAttText
  as select from /EXAOTP/T_TP_ART
  association [1..1] to /EXAOTP/I_TpAdhocAtt_S as _TpAdhocAttAll on $projection.SingletonID = _TpAdhocAttAll.SingletonID
  association to parent /EXAOTP/I_TpAdhocAtt as _TpAdhocAtt on $projection.Method = _TpAdhocAtt.Method and $projection.Algorithm = _TpAdhocAtt.Algorithm and $projection.NodeId = _TpAdhocAtt.NodeId and $projection.TpParamType = _TpAdhocAtt.TpParamType
  association [0..*] to I_LanguageText as _LanguageText on $projection.Spras = _LanguageText.LanguageCode
{
  key METHOD as Method,
  key ALGORITHM as Algorithm,
  key NODE_ID as NodeId,
  key TP_PARAM_TYPE as TpParamType,
  @Semantics.language: true
  key SPRAS as Spras,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocAttAll,
  _TpAdhocAtt,
  _LanguageText
  
}
