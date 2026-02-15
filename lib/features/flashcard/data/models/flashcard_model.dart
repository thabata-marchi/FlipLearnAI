import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flashcard_model.g.dart';

/// Data model for Flashcard
///
/// Used for JSON serialization/deserialization and database storage.
/// Extends the domain Flashcard entity.
@JsonSerializable()
@HiveType(typeId: 0)
class FlashcardModel extends Flashcard {
  /// Constructor
  const FlashcardModel({
    required super.id,
    required super.front,
    required super.back,
    required super.createdAt,
    super.example,
    super.pronunciation,
    super.isFavorite = false,
    super.updatedAt,
  });

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

  /// Factory constructor for creating from JSON
  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get front => super.front;

  @HiveField(2)
  @override
  String get back => super.back;

  @HiveField(3)
  @override
  DateTime get createdAt => super.createdAt;

  @HiveField(4)
  @override
  String? get example => super.example;

  @HiveField(5)
  @override
  String? get pronunciation => super.pronunciation;

  @HiveField(6)
  @override
  bool get isFavorite => super.isFavorite;

  @HiveField(7)
  @override
  DateTime? get updatedAt => super.updatedAt;

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

  /// Create a copy of this model with some fields replaced
  @override
  FlashcardModel copyWith({
    String? id,
    String? front,
    String? back,
    String? example,
    String? pronunciation,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      example: example ?? this.example,
      pronunciation: pronunciation ?? this.pronunciation,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
