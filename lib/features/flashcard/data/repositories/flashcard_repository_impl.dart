import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/ai_remote_datasource.dart';
import '../datasources/flashcard_local_datasource.dart';
import '../models/flashcard_model.dart';

/// Implementation of FlashcardRepository
///
/// Coordinates between local and remote data sources and
/// converts exceptions to Failures for domain layer.
class FlashcardRepositoryImpl extends FlashcardRepository {
  /// Local data source for Hive operations
  final FlashcardLocalDataSource localDataSource;

  /// Remote data source for AI operations
  final AIRemoteDataSource remoteDataSource;

  /// Constructor
  FlashcardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Flashcard>>> getAll() async {
    try {
      final models = await localDataSource.getFlashcards();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load flashcards'));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> getById(String id) async {
    try {
      final model = await localDataSource.getFlashcardById(id);
      if (model == null) {
        return Left(CacheFailure('Flashcard not found'));
      }
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load flashcard'));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> create(Flashcard flashcard) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.saveFlashcard(model);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to create flashcard'));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> update(Flashcard flashcard) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.updateFlashcard(model);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update flashcard'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await localDataSource.deleteFlashcard(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to delete flashcard'));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> generateWithAI({
    required String word,
    required String aiProvider,
    required String apiKey,
  }) async {
    try {
      final model = await remoteDataSource.generateFlashcard(
        word: word,
        aiProvider: aiProvider,
        apiKey: apiKey,
      );

      // Save to local storage for future access
      await localDataSource.saveFlashcard(model);

      return Right(model.toEntity());
    } on AIServiceException catch (e) {
      return Left(AIServiceFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to generate flashcard with AI'));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> toggleFavorite(String id) async {
    try {
      final model = await localDataSource.getFlashcardById(id);
      if (model == null) {
        return Left(CacheFailure('Flashcard not found'));
      }

      final updatedModel = model.copyWith(
        isFavorite: !model.isFavorite,
        updatedAt: DateTime.now(),
      );
      await localDataSource.updateFlashcard(updatedModel);

      return Right(updatedModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update favorite status'));
    }
  }

  @override
  Future<Either<Failure, List<Flashcard>>> search(String query) async {
    try {
      final allModels = await localDataSource.getFlashcards();

      final lowerQuery = query.toLowerCase();
      final filtered = allModels
          .where(
            (model) =>
                model.front.toLowerCase().contains(lowerQuery) ||
                model.back.toLowerCase().contains(lowerQuery),
          )
          .toList();

      final entities = filtered.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to search flashcards'));
    }
  }
}
