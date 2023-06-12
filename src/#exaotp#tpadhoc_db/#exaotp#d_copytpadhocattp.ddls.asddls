@EndUserText.label: 'Copy TP Adhoc Attributes'
define abstract entity /EXAOTP/D_CopyTpAdhocAttP
{
  @EndUserText.label: 'New Pricing Method'
  Method : /EXAOTP/DE_TP_PRICING_METHOD;
  @EndUserText.label: 'New TP Algorthm'
  Algorithm : /EXAOTP/DE_TP_ALGORITHM;
  @EndUserText.label: 'New Node ID'
  NodeId : /EXAOTP/DE_NODE_ID;
  @EndUserText.label: 'New TP Par Type'
  TpParamType : /EXAOTP/DE_TP_PARAM_TYPE;
  
}
