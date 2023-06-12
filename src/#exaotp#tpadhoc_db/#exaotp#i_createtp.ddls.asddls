@EndUserText.label: 'Create Transaction'
define root abstract entity /EXAOTP/I_CREATETP
   
{  
  key Sender   : abap.char( 4 );
  key Receiver : abap.char( 4 );    
  key Material : /exaotp/de_matnr;
  TP_CURRENCY : /exaotp/de_curr;
  UOM         : /exaotp/de_meins;
  method      : /exaotp/de_tp_pricing_method;   
    
}
