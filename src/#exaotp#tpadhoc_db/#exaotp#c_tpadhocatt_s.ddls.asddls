@EndUserText.label: 'Maintain TP Adhoc Attributes Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity /EXAOTP/C_TpAdhocAtt_S
  provider contract transactional_query
  as projection on /EXAOTP/I_TpAdhocAtt_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _TpAdhocAtt : redirected to composition child /EXAOTP/C_TpAdhocAtt
  
}
