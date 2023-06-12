@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /EXAOTP/I_T_MATT as select from /exaotp/t_matt
  association to parent /EXAOTP/I_T_MAT as _Material
  on $projection.Sysid = _Material.Sysid
  and $projection.Material = _Material.Material
  association [0..*] to I_LanguageText as _LanguageText 
  on $projection.Spras = _LanguageText.LanguageCode
{
    key spras as Spras,
    key sysid as Sysid,
    key material as Material,
    description as Description,
    _Material,
    _LanguageText
}
