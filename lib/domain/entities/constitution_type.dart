enum ConstitutionType {
  individual('Individual', 1),
  proprietorship('Proprietorship', 2),
  partnership('Partnership', 3),
  company('Company', 4);

  const ConstitutionType(this.label, this.type);

  final String label;
  final int type;
}
