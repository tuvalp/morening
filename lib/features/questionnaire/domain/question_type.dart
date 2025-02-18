enum QuestionType { singleSelect, multiSelect, freeText }

extension QuestionTypeExtension on QuestionType {
  static QuestionType fromString(String type) {
    switch (type) {
      case 'singleSelect':
        return QuestionType.singleSelect;
      case 'multiSelect':
        return QuestionType.multiSelect;
      case 'freeText':
        return QuestionType.freeText;
      default:
        return QuestionType.singleSelect; // Fallback to default
    }
  }
}
