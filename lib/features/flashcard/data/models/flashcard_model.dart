import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/flashcard.dart';

part 'flashcard_model.g.dart';

/// Data model for Flashcard
///
/// Used for JSON serialization/deserialization and database storage.
/// Extends the domain Flashcard entity.
@JsonSerializable()
@HiveType(typeId: 0)
class FlashcardModel extends Flashcard {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String front;

  @HiveField(2)
  @override
  final String back;

  @HiveField(3)
  @override
  final DateTime createdAt;

  @HiveField(4)
  @override
  final String? example;

  @HiveField(5)
  @override
  final String? pronunciation;

  @HiveField(6)
  @override
  final bool isFavorite;

  @HiveField(7)
  @override
  final DateTime? updatedAt;

  /// Constructor
  const FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    required this.createdAt,
    this.example,
    this.pronunciation,
    this.isFavorite = false,
    this.updatedAt,
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
