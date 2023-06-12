@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TP Header Staging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity /EXAOTP/I_TP_HDR as select from /exaotp/t_tp_hdr as tp
            association [0..1] to /EXAOTP/I_T_MATT as _MaterialText 
            on $projection.MATERIAL = _MaterialText.Material
            and $projection.SysId = _MaterialText.Sysid
            and _MaterialText.Spras = $session.system_language
            
            association [0..1] to /EXAOTP/I_TpAdhocAlgText as _AlgorithmText
            on $projection.method = _AlgorithmText.Method
            and $projection.algorithm = _AlgorithmText.Algorithm
            and _AlgorithmText.Spras = $session.system_language
            
            association [0..1] to I_CurrencyText as _CurrencyText
            on $projection.TP_Currency = _CurrencyText.Currency
            and _CurrencyText.Language = $session.system_language
            
            association [0..1] to I_UnitOfMeasureDimensionText as _UnitText
            on $projection.TP_UOM = _UnitText.UnitOfMeasureDimension
            and _UnitText.Language = $session.system_language
            
            association [0..1] to /EXAOTP/I_TpAdhocMethodsText as _MethodText
            on $projection.method = _MethodText.Method
            and _MethodText.Spras = $session.system_language
            
            association [0..1] to /EXAOTP/I_CCREP as _ReportingCompany
            on $projection.Vendor = _ReportingCompany.CcodeReporting
            
            association [0..1] to /EXAOTP/I_CCREP as _RecievingCompany
            on $projection.Vendor = _RecievingCompany.CcodeReporting
            
            association [0..1] to /EXAOTP/I_CCREPT as _ReportingCompanyText
            on $projection.Vendor = _ReportingCompanyText.CcodeReporting
            and _ReportingCompanyText.Spras = $session.system_language
            
            association [0..1] to /EXAOTP/I_CCREPT as _RecievingCompanyText
            on $projection.Vendor = _RecievingCompanyText.CcodeReporting
            and _RecievingCompanyText.Spras = $session.system_language
                       
{
     
    key tp.sysid as SysId,
    
//    @UI.hidden: true 
//    key tp.guid as Guid,

    key tp.vendor as Vendor,

    key tp.receiving_entity as Receiving_Entity, 

    key tp.material as MATERIAL,
 
    key tp.valid_from,
  
    concat(tp.sysid, tp.material) as SMATERIAL,

    tp.tp_currency as TP_Currency, 

    '' as View_param, 

    tp.tp_uom as TP_UOM,

    tp.valid_to,
 
    tp.method,

    tp.algorithm,

    @Semantics.amount.currencyCode: 'TP_Currency'
    tp.proposed_tp as Proposed_TP,

    @Semantics.quantity.unitOfMeasure: 'TP_UOM'
    tp.price_qty_unit as Price_qty_unit,

    @Semantics.user.createdBy: true
    tp.crnam,
 
    @Semantics.systemDateTime.createdAt: true
    tp.crtimestamp,
    
    @Semantics.user.lastChangedBy: true
    tp.chnam,
     
    @Semantics.systemDateTime.lastChangedAt: true    
    tp.chtimestamp,
    
    _MaterialText.Description as MAT_DESCR, 
    
    _AlgorithmText.Description as ALG_DESCR,
    
    @EndUserText.label: 'Sender Description'
    @EndUserText.quickInfo: 'Sender Description' 
    _ReportingCompanyText.Description as vendor_desc,
    
    @EndUserText.label: 'Receiver Description'
    @EndUserText.quickInfo: 'Receiver Description'
    _RecievingCompanyText.Description as recipient_desc,
    
    @EndUserText.label: 'Currency Description'
    @EndUserText.quickInfo: 'Currency Description'
    _CurrencyText.CurrencyName as currency_desc,
    
    @EndUserText.label: 'UoM Description'
    @EndUserText.quickInfo: 'UoM Description'
    _UnitText.UnitOfMeasureDimensionName as uom_desc,
    
    @EndUserText.label: 'Sender Country'
    @EndUserText.quickInfo: 'Sender Country'
    _ReportingCompany.Country as vendor_country,
    
    @EndUserText.label: 'Receiver Country'
    @EndUserText.quickInfo: 'Receiver Country'
    _RecievingCompany.Country as rec_country,

    tp.wf_status as STATUS,
 
    tp.in_process as In_Process,
 
    tp.wf_flag,

    tp.wf_id as Wf_Id,

    tp.active_flag,
    
//    @EndUserText.label: 'Status' 
//    @EndUserText.quickInfo: 'Status'
//    @UI.lineItem: [{position: 102}]
//    case when tp.wf_status = '03' then
//    da.ddtext
//    else
//    ds.ddtext end as STATUS_DESC,
       
    @EndUserText.label: 'Pricing Method' 
    @EndUserText.quickInfo: 'Pricing Method'
    @UI.lineItem: [{position: 100}]
    _MethodText.Description as METHOD_DESCR,   
 
    tp.wf_id as wfid, 

    'TPA' as Source,
    
//    associations
    _MaterialText,
    _AlgorithmText,
    _CurrencyText,
    _UnitText,
    _MethodText,
    _ReportingCompany,
    _RecievingCompany,
    _ReportingCompanyText,
    _RecievingCompanyText

} 
