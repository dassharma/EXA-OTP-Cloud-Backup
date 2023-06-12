@EndUserText.label: 'Copy TP Adhoc Pricing Method Fields'
define abstract entity /EXAOTP/D_CopyTpAdhocMethField
{
  @EndUserText.label: 'New Pricing Method'
  Method : /EXAOTP/DE_TP_PRICING_METHOD;
  @EndUserText.label: 'New Component'
  ColumnId : /EXAOTP/DE_COLUMN_ID;
  
}
