@EndUserText.label: 'TP Adhoc Pricing Method Fields'
@AccessControl.authorizationCheck: #CHECK
define view entity /EXAOTP/I_TpAdhocMethField
  as select from /EXAOTP/T_TP_FLD
  association to parent /EXAOTP/I_TpAdhocMethField_S as _TpAdhocMethFieldAll on $projection.SingletonID = _TpAdhocMethFieldAll.SingletonID
  composition [0..*] of /EXAOTP/I_TpAdhocMethFieldText as _TpAdhocMethFielText
{
  key METHOD as Method,
  key COLUMN_ID as ColumnId,
  PERCENT as Percent,
  ENABLED as Enabled,
  HIDE as Hide,
  READ_ONLY as ReadOnly,
  PARAM as Param,
  FORMULA as Formula,
  SEQ as Seq,
  QTY_FLAG as QtyFlag,
  CURRENCY_IND as CurrencyInd,
  REF_TOOLTIP as RefTooltip,
  QTY_CURR_FIELD as QtyCurrField,
  SAVED_PARAM as SavedParam,
  ERROR_FLAG as ErrorFlag,
  MAX_LENGTH as MaxLength,
  FILTER as Filter,
  DROP_DOWN_FLAG as DropDownFlag,
  EDIT_PARAM_FLAG as EditParamFlag,
  HIERARCHYPOSITION as Hierarchyposition,
  SERVICE as Service,
  F4_FLAG as F4Flag,
  DATA_ELEMENT as DataElement,
  ENTITY as Entity,
  CHECK_BOX_FLAG as CheckBoxFlag,
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
  _TpAdhocMethFieldAll,
  _TpAdhocMethFielText
  
}
