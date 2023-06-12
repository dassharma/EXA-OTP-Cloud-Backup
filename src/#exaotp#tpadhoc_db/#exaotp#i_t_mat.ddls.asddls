@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity /EXAOTP/I_T_MAT as select from /exaotp/t_mat    
    composition [0..*] of /EXAOTP/I_T_MATT as _MaterialText    
                 
{
    key sysid as Sysid,
    key material as Material,
//    mtart as Mtart,
//    meins as Meins,
//    matkl as Matkl,
//    prodh as Prodh,
//    not_relevant_for_tp as NotRelevantForTp,
//    not_relevant_for_sim as NotRelevantForSim,
//    temp_mat as TempMat,
//    mtpos as Mtpos,
//    internal_material as InternalMaterial,
//    original_material as OriginalMaterial,
//    @Semantics.user.createdBy: true
//    crnam as Crnam,
//    @Semantics.systemDateTime.createdAt: true
//    crtimestamp as Crtimestamp,
//    @Semantics.user.lastChangedBy: true
//    chnam as Chnam,
//    @Semantics.systemDateTime.lastChangedAt: true
//    chtimestamp as Chtimestamp,
    _MaterialText
    
}
