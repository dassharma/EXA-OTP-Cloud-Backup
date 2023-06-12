@EndUserText.label: 'Maintain TP Adhoc Pricing Method Fields '
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity /EXAOTP/C_TpAdhocMethField_S
  provider contract transactional_query
  as projection on /EXAOTP/I_TpAdhocMethField_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _TpAdhocMethField : redirected to composition child /EXAOTP/C_TpAdhocMethField
  
}
