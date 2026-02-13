import 'package:equatable/equatable.dart';

/// Core business entity representing a flashcard
///
/// A flashcard contains a word/phrase on the front and its translation/definition
/// on the back, along with optional examples and pronunciation guide.
class Flashcard extends Equatable {
  /// Unique identifier for this flashcard
  final String id;

  /// Front side text (typically the word to learn)
  final String front;

  /// Back side text (typically the translation/definition)
  final String back;

  /// Optional example sentence or usage
  final String? example;

  /// Whether this flashcard is marked as favorite
  final bool isFavorite;

  /// When this flashcard was created
  final DateTime createdAt;

  /// Optional pronunciation guide
  final String? pronunciation;

  /// When this flashcard was last updated
  final DateTime? updatedAt;

  /// Constructor
  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.createdAt,
    this.isFavorite = false,
    this.example,
    this.pronunciation,
    this.updatedAt,
  });

  /// Create a copy of this flashcard with some fields replaced
  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    String? example,
    String? pronunciation,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
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

  @override
  List<Object?> get props => [
    id,
    front,
    back,
    example,
    pronunciation,
    isFavorite,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => '''
Flashcard(
  id: $id,
  front: $front,
  back: $back,
  example: $example,
  pronunciation: $pronunciation,
  isFavorite: $isFavorite,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
)''';
}
