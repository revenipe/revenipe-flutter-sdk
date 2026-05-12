enum RevenipePurchaseMethod {
  paymentSheet('payment_sheet'),
  hostedCheckout('hosted_checkout');

 final String value;

 const RevenipePurchaseMethod(this.value);
}