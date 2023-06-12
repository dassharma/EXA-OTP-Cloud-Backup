@EndUserText.label: 'Calculate Transfer Price'
@Metadata.allowExtensions: true
define root custom entity /EXAOTP/I_CalTransferPrice
{

      //  key guid              : xsduuid_char;
      @EndUserText.label : 'Sender'
      @EndUserText.quickInfo: 'Sender'
      @UI.lineItem       : [{position: 10}]
  key vendor             : /exaotp/de_vendor;

      @EndUserText.label : 'Receiver'
      @EndUserText.quickInfo: 'Receiver'
      @UI.lineItem       : [{position: 20}]
  key receiving_entity   : /exaotp/de_ccode_rec;

      @UI.hidden         : true
  key sysid              : /exaotp/de_sys_id;

      @EndUserText.label : 'Material'
      @EndUserText.quickInfo: 'Material'
      @UI.lineItem       : [{position: 30}]
  key material           : /exaotp/de_matnr;

      @EndUserText.label : 'Valid From'
      @EndUserText.quickInfo: 'Valid From'
      @UI.lineItem       : [{position: 95}]
      valid_from         : /exaotp/de_valid_from;

      @EndUserText.label : 'Valid To'
      @EndUserText.quickInfo: 'Valid To'
      @UI.lineItem       : [{position: 120}]
      valid_to           : /exaotp/de_valid_to;

      @EndUserText.label : 'Currency'
      @EndUserText.quickInfo: 'Currency'
      @UI.lineItem       : [{position: 120}]
      tp_currency        : /exaotp/de_curr;
      
      @EndUserText.label : 'Unit Of Measure'
      @EndUserText.quickInfo: 'Unit Of Measure'
      @UI.lineItem       : [{position: 120}]
      tp_uom             : /exaotp/de_meins;
      method             : /exaotp/de_tp_pricing_method;
      algorithm          : /exaotp/de_tp_algorithm;
      @Semantics.amount.currencyCode: 'tp_currency'
      proposed_tp        : /exaotp/de_tp;
      in_process         : /exaotp/de_hide;
      wf_status          : /exaotp/de_tpa_status;
      wf_id              : abap.numc( 12 );
      @Semantics.quantity.unitOfMeasure: 'tp_uom'
      price_qty_unit     : /exaotp/de_sales_price_unit;
      mat_descr          : /exaotp/de_description;
      alg_descr          : /exaotp/de_description;
      tp_update_process  : abap.char( 3 );
      vendor_desc        : /exaotp/de_description;
      recipient_desc     : /exaotp/de_description;
      currency_desc      : /exaotp/de_description;
      uom_desc           : /exaotp/de_description;
      vendor_country     : abap.char( 3 );
      rec_country        : abap.char( 3 );
      status_desc        : abap.char( 40 );
      is_user_authorized : abap.char( 1 );
      source_descr       : abap.char( 40 );
      seq_no             : /exaotp/de_sequence_number;
      ref_method         : /exaotp/de_tp_pricing_method;
      @Semantics.amount.currencyCode : 'tp_currency'
      ref_proposed_tp    : /exaotp/de_tp;
      tp_change          : /exaotp/de_top_defval;
      message_type       : bapi_mtype;
      message            : abap.string( 0 );
      @Semantics.amount.currencyCode : 'tp_currency'
      activetp           : /exaotp/de_tp;
      @Semantics.amount.currencyCode : 'tp_currency'
      asp                : /exaotp/de_tp;
      discount           : /exaotp/de_top_defval;
      @Semantics.amount.currencyCode : 'tp_currency'
      acp                : /exaotp/de_tp;
      markup             : /exaotp/de_top_defval;
      max_threshold      : /exaotp/de_top_defval;
      vendor_share       : /exaotp/de_top_defval;
      recipient_share    : /exaotp/de_top_defval;
      local_curr         : /exaotp/de_curr;
      method_descr       : /exaotp/de_description;
      @Semantics.amount.currencyCode : 'tp_currency'
      transfer_price     : /exaotp/de_tp;
      @Semantics.amount.currencyCode : 'tp_currency'
      gross_profit       : /exaotp/de_tp;
      @Semantics.amount.currencyCode : 'tp_currency'
      total              : /exaotp/de_tp;
      landing_cost       : /exaotp/de_ln_factor;
      @Semantics.amount.currencyCode : 'tp_currency'
      abs_landing_cost   : /exaotp/de_tp;
      trans_price_type   : /exaotp/de_tprice_type;
      @EndUserText.label : 'Transaction Price Type Description'
      price_type_descr   : abap.char( 40 );


}
