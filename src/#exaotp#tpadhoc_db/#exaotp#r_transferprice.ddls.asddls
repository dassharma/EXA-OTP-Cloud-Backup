@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED Transfer Price'
define root view entity /EXAOTP/R_TRANSFERPRICE
  as select from /exaotp/t_tp as TransferPrice
            association [0..1] to /EXAOTP/I_T_MATT as _MaterialText 
            on $projection.Material = _MaterialText.Material
            and $projection.SysID = _MaterialText.Sysid
            and _MaterialText.Spras = $session.system_language
                        
            association [0..1] to I_CurrencyText as _CurrencyText
            on $projection.Currency = _CurrencyText.Currency
            and _CurrencyText.Language = $session.system_language
            
            association [0..1] to I_UnitOfMeasureDimensionText as _UnitText
            on $projection.Uom = _UnitText.UnitOfMeasureDimension
            and _UnitText.Language = $session.system_language
                        
            association [0..1] to /EXAOTP/I_CCREP as _ReportingCompany
            on $projection.SendingEntity = _ReportingCompany.CcodeReporting
            
            association [0..1] to /EXAOTP/I_CCREP as _RecievingCompany
            on $projection.ReceivingEntity = _RecievingCompany.CcodeReporting
            
            association [0..1] to /EXAOTP/I_CCREPT as _ReportingCompanyText
            on $projection.SendingEntity = _ReportingCompanyText.CcodeReporting
            and _ReportingCompanyText.Spras = $session.system_language
            
            association [0..1] to /EXAOTP/I_CCREPT as _RecievingCompanyText
            on $projection.ReceivingEntity = _RecievingCompanyText.CcodeReporting
            and _RecievingCompanyText.Spras = $session.system_language
{
  key sysid as SysID,
  key material as Material,
  key sending_entity as SendingEntity,
  key receiving_entity as ReceivingEntity,
  key sender_tp_function as SenderTpFunction,
  key valid_from as ValidFrom,
  key seq_no as SeqNo,
  currency as Currency,
  uom as Uom,
  valid_to as ValidTo,
  active_flag as ActiveFlag,
  tp_update_process as TpUpdateProcess,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  price_qty_unit as PriceQtyUnit,
  meins as Meins,
  @Semantics.amount.currencyCode: 'Currency'
  transfer_price_pr as TransferPricePr,
  @Semantics.amount.currencyCode: 'Currency'
  transfer_price as TransferPrice,
  @Semantics.amount.currencyCode: 'Currency'
  transfer_price_in_src_sys as TransferPriceInSrcSys,
  act_in_src_sys as ActInSrcSys,
  comments as Comments,
  comments_short as CommentsShort,
  vakey as Vakey,
  wf_id as WfID,
  crapplication as Crapplication,
  chapplication as Chapplication,
  @Semantics.user.createdBy: true
  crnam as Crnam,
  @Semantics.systemDateTime.createdAt: true
  crtimestamp as Crtimestamp,
  @Semantics.user.lastChangedBy: true
  chnam as Chnam,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  //    associations
   _MaterialText,                    
   _CurrencyText,
   _UnitText,                    
   _ReportingCompany,
   _RecievingCompany,
   _ReportingCompanyText,
   _RecievingCompanyText
  
}
