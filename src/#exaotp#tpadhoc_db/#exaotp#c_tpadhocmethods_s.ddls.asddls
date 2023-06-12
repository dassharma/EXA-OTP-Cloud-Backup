@EndUserText.label: 'Maintain TP Adhoc Pricing Methods Single'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity /EXAOTP/C_TpAdhocMethods_S
  provider contract transactional_query
  as projection on /EXAOTP/I_TpAdhocMethods_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _TpAdhocMethods : redirected to composition child /EXAOTP/C_TpAdhocMethods
  
}
