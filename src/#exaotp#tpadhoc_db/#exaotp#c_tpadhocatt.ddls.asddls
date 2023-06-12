@EndUserText.label: 'Maintain TP Adhoc Attributes'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocAtt
  as projection on /EXAOTP/I_TpAdhocAtt
{
  key Method,
  key Algorithm,
  key NodeId,
  key TpParamType,
  Formula,
  Percent,
  Enabled,
  KpiInd,
  Source,
  Seq,
  DefValue,
  TpOutput,
  TpResult,
  TpFinOutput,
  TpIccomp,
  CalPrio,
  ConvRel,
  PropInd,
  PropTpInd,
  Tprice,
  CurrencyInd,
  GroupCurr,
  TpChange,
  Service,
  Entity,
  DropDownFlag,
  CheckBoxFlag,
  F4Flag,
  DataElement,
  Hide,
  Crnam,
  Crtimestamp,
  Chnam,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _TpAdhocAttAll : redirected to parent /EXAOTP/C_TpAdhocAtt_S,
  _TpAdhocAttText : redirected to composition child /EXAOTP/C_TpAdhocAttText,
  _TpAdhocAttText.Description : localized
  
}
