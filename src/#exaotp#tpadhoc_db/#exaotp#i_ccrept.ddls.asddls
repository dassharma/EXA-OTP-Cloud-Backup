@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporting Company Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /EXAOTP/I_CCREPT as select from /exaotp/t_ccrept
    association to parent /EXAOTP/I_CCREP as _CompanyReporting
    on $projection.CcodeReporting = _CompanyReporting.CcodeReporting
    association [0..*] to I_LanguageText as _LanguageText 
    on $projection.Spras = _LanguageText.LanguageCode
{
    key spras as Spras,
    key ccode_reporting as CcodeReporting,
    description as Description,
     _CompanyReporting, // Make association public
     _LanguageText 
}
