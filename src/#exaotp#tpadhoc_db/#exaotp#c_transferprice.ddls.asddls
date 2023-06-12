@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Transfer Price'
@ObjectModel.semanticKey: [ 'SysID', 'Material', 'SendingEntity', 'ReceivingEntity', 'SenderTpFunction', 'ValidFrom', 'SeqNo' ]
define root view entity /EXAOTP/C_TRANSFERPRICE
  provider contract transactional_query
  as projection on /EXAOTP/R_TRANSFERPRICE
{
  key SysID,
  key Material,
  key SendingEntity,
  key ReceivingEntity,
  key SenderTpFunction,
  key ValidFrom,
  key SeqNo,
  Currency,
  Uom,
  ValidTo,
  ActiveFlag,
  TpUpdateProcess,
  PriceQtyUnit,
  Meins,
  TransferPricePr,
  TransferPrice,
  TransferPriceInSrcSys,
  ActInSrcSys,
  Comments,
  CommentsShort,
  Vakey,
  WfID,
  Crapplication,
  Chapplication,
  Crnam,
  Crtimestamp,
  Chnam,
  LastChangedAt,
  LocalLastChangedAt
  
}
