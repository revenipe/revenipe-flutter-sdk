enum TrialPaymentMethodBehavior {
  direct('direct'),
  setupIntent('setup_intent');

  final String value;

  const TrialPaymentMethodBehavior(this.value);
}
