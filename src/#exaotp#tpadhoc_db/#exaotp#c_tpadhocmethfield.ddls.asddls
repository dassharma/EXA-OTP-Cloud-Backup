@EndUserText.label: 'Maintain TP Adhoc Pricing Method Fields'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity /EXAOTP/C_TpAdhocMethField
  as projection on /EXAOTP/I_TpAdhocMethField
{
  key Method,
  key ColumnId,
  Percent,
  Enabled,
  Hide,
  ReadOnly,
  Param,
  Formula,
  Seq,
  QtyFlag,
  CurrencyInd,
  RefTooltip,
  QtyCurrField,
  SavedParam,
  ErrorFlag,
  MaxLength,
  Filter,
  DropDownFlag,
  EditParamFlag,
  Hierarchyposition,
  Service,
  F4Flag,
  DataElement,
  Entity,
  CheckBoxFlag,
  Crnam,
  Crtimestamp,
  Chnam,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _TpAdhocMethFieldAll : redirected to parent /EXAOTP/C_TpAdhocMethField_S,
  _TpAdhocMethFielText : redirected to composition child /EXAOTP/C_TpAdhocMethFieldText,
  _TpAdhocMethFielText.Description : localized
  
}
