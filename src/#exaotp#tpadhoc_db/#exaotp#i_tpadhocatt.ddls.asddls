@EndUserText.label: 'TP Adhoc Attributes'
@AccessControl.authorizationCheck: #CHECK
define view entity /EXAOTP/I_TpAdhocAtt
  as select from /EXAOTP/T_TP_ATT
  association to parent /EXAOTP/I_TpAdhocAtt_S as _TpAdhocAttAll on $projection.SingletonID = _TpAdhocAttAll.SingletonID
  composition [0..*] of /EXAOTP/I_TpAdhocAttText as _TpAdhocAttText
{
  key METHOD as Method,
  key ALGORITHM as Algorithm,
  key NODE_ID as NodeId,
  key TP_PARAM_TYPE as TpParamType,
  FORMULA as Formula,
  PERCENT as Percent,
  ENABLED as Enabled,
  KPI_IND as KpiInd,
  SOURCE as Source,
  SEQ as Seq,
  DEF_VALUE as DefValue,
  TP_OUTPUT as TpOutput,
  TP_RESULT as TpResult,
  TP_FIN_OUTPUT as TpFinOutput,
  TP_ICCOMP as TpIccomp,
  CAL_PRIO as CalPrio,
  CONV_REL as ConvRel,
  PROP_IND as PropInd,
  PROP_TP_IND as PropTpInd,
  TPRICE as Tprice,
  CURRENCY_IND as CurrencyInd,
  GROUP_CURR as GroupCurr,
  TP_CHANGE as TpChange,
  SERVICE as Service,
  ENTITY as Entity,
  DROP_DOWN_FLAG as DropDownFlag,
  CHECK_BOX_FLAG as CheckBoxFlag,
  F4_FLAG as F4Flag,
  DATA_ELEMENT as DataElement,
  HIDE as Hide,
  @Semantics.user.createdBy: true
  CRNAM as Crnam,
  @Semantics.systemDateTime.createdAt: true
  CRTIMESTAMP as Crtimestamp,
  @Semantics.user.lastChangedBy: true
  CHNAM as Chnam,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _TpAdhocAttAll,
  _TpAdhocAttText
  
}
