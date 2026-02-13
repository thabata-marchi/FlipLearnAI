import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/flashcard.dart';

part 'flashcard_model.g.dart';

/// Data model for Flashcard
///
/// Used for JSON serialization/deserialization and database storage.
/// Extends the domain Flashcard entity.
@JsonSerializable()
class FlashcardModel extends Flashcard {
  /// Constructor
  const FlashcardModel({
    required String id,
    required String front,
    required String back,
    required DateTime createdAt,
    String? example,
    String? pronunciation,
    bool isFavorite = false,
    DateTime? updatedAt,
  }) : super(
    id: id,
    front: front,
    back: back,
    example: example,
    pronunciation: pronunciation,
    isFavorite: isFavorite,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Factory constructor for creating from JSON
  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$FlashcardModelToJson(this);

  /// Convert model to entity
  Flashcard toEntity() => Flashcard(
    id: id,
    front: front,
    back: back,
    example: example,
    pronunciation: pronunciation,
    isFavorite: isFavorite,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Create model from entity
  factory FlashcardModel.fromEntity(Flashcard entity) => FlashcardModel(
    id: entity.id,
    front: entity.front,
    back: entity.back,
    example: entity.example,
    pronunciation: entity.pronunciation,
    isFavorite: entity.isFavorite,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
