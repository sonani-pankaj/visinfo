import 'package:flutter/foundation.dart';

enum PlanTier { free, pro }

class UserEntitlement {
  const UserEntitlement({
    required this.planTier,
    required this.active,
  });

  final PlanTier planTier;
  final bool active;
}

class FeatureGates {
  const FeatureGates(this.entitlement);

  final UserEntitlement entitlement;

  bool get canUseLocalMetadataExtraction => !kIsWeb;

  bool get canUseProFeatures => entitlement.active && entitlement.planTier == PlanTier.pro;
}
