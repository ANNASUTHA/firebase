import 'package:flutter/foundation.dart';

enum MessageType { general, personal }

extension MessageTypeExtension on MessageType {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case MessageType.general:
        return 'General';
      case MessageType.personal:
        return 'Personal';
    }
  }
}

enum TrainerLevel {
  all,
  provZoneTrainer,
  zoneTrainer,
  provNationalTrainer,
  nationalTrainer,
  authorGraduate,
}

extension TrainerLevelExtension on TrainerLevel {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case TrainerLevel.all:
        return 'All';
      case TrainerLevel.provZoneTrainer:
        return 'Prov. Zone Trainer';
      case TrainerLevel.zoneTrainer:
        return 'Zone Trainer';
      case TrainerLevel.provNationalTrainer:
        return 'Prov. National Trainer';
      case TrainerLevel.nationalTrainer:
        return 'National Trainer';
      case TrainerLevel.authorGraduate:
        return 'Author Graduate';
    }
  }
}
