@EndUserText.label: 'Maintain TP Adhoc Algorithms Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity /EXAOTP/C_TpAdhocAlg_S
  provider contract transactional_query
  as projection on /EXAOTP/I_TpAdhocAlg_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _TpAdhocAlg : redirected to composition child /EXAOTP/C_TpAdhocAlg
  
}
