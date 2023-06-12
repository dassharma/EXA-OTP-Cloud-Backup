@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporting Company'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity /EXAOTP/I_CCREP as select from /exaotp/t_ccrep
    composition [0..*] of /EXAOTP/I_CCREPT as _CompanyReportingText
{
    key ccode_reporting as CcodeReporting,
    country as Country,
    city as City,
    local_curr as LocalCurr,   
    ccode_type as CcodeType,
    impl_type as ImplType,    
    _CompanyReportingText
    
}
