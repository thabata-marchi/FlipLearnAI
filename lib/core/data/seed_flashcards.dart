import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Seed flashcards for initial app load
///
/// Contains 40 high-quality English ↔ Portuguese flashcards
/// across multiple vocabulary categories to give users a complete
/// experience before they create or generate their own.
abstract class SeedFlashcards {
  /// List of seed flashcards (40 cards - B2 Upper Intermediate Level)
  /// Advanced vocabulary: business, complex situations, nuanced
  /// expressions
  static List<FlashcardModel> get cards => [
        // Business & Professional Language (6 cards)
        FlashcardModel(
          id: 'seed_001',
          front: 'To devise a strategy',
          back: 'Elaborar uma estratégia',
          example: 'We need to devise a robust strategy before launch.',
          pronunciation: 'dih-VYZ uh STRAT-uh-jee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_002',
          front: 'To optimize processes',
          back: 'Otimizar processos',
          example: 'The company seeks to optimize processes for efficiency.',
          pronunciation: 'AHP-tuh-myz PRAH-ses-ez',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_003',
          front: 'Sustainability',
          back: 'Sustentabilidade',
          example: 'Sustainability is a strategic priority for us.',
          pronunciation: 'suh-sten-uh-BIL-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_004',
          front: 'Feasibility',
          back: 'Viabilidade',
          example: 'Evaluate the feasibility of this project first.',
          pronunciation: 'fee-zuh-BIL-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_005',
          front: 'Stakeholder',
          back: 'Interessado / Stakeholder',
          example: 'All stakeholders were involved in the decision.',
          pronunciation: 'STAKE-hol-der',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_006',
          front: 'Performance metrics',
          back: 'Desempenho',
          example: 'Employee performance improved this quarter.',
          pronunciation: 'per-FOR-muns MET-riks',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Advanced Verbs & Actions (8 cards)
        FlashcardModel(
          id: 'seed_007',
          front: 'To contravene',
          back: 'Contravir',
          example: "This decision goes against the company's principles.",
          pronunciation: 'con-truh-VEEN',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_008',
          front: 'To perpetuate',
          back: 'Perpetuar',
          example: 'We should perpetuate the cultural values.',
          pronunciation: 'per-PET-choo-ayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_009',
          front: 'To imbue',
          back: 'Imbuir',
          example: 'Leadership must imbue employees with purpose.',
          pronunciation: 'im-BYOO',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_010',
          front: 'To mitigate',
          back: 'Mitigar',
          example: "It's crucial to mitigate the environmental risks.",
          pronunciation: 'MIT-uh-gayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_011',
          front: 'To exacerbate',
          back: 'Exacerbar',
          example:
              'Lack of communication exacerbated the conflict between '
              'departments.',
          pronunciation: 'ig-ZAS-er-bayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_012',
          front: 'To instigate',
          back: 'Instigar',
          example: 'We should not instigate unnecessary confrontations.',
          pronunciation: 'IN-sti-gayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_013',
          front: 'To overcome',
          back: 'Transpor',
          example: 'Challenges must be overcome with creativity.',
          pronunciation: 'oh-ver-KUM',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_014',
          front: 'To apprehend',
          back: 'Apreender',
          example: 'The police managed to apprehend the assets.',
          pronunciation: 'ap-ri-HEND',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Complex Nouns & Abstract Concepts (8 cards)
        FlashcardModel(
          id: 'seed_015',
          front: 'Pragmatism',
          back: 'Pragmatismo',
          example: "The team's pragmatism allowed us to solve it quickly.",
          pronunciation: 'PRAG-muh-tiz-um',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_016',
          front: 'Diligence',
          back: 'Diligência',
          example: 'With due diligence, we identified the flaws.',
          pronunciation: 'DIL-i-jens',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_017',
          front: 'Rigor',
          back: 'Rigor',
          example: 'Scientific rigor is essential in research.',
          pronunciation: 'RIG-er',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_018',
          front: 'Perspicacity',
          back: 'Perspicácia',
          example: 'Your insight allowed us to anticipate trends.',
          pronunciation: 'per-spi-KAS-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_019',
          front: 'Subtlety',
          back: 'Sutileza',
          example: 'The subtlety went unnoticed by most.',
          pronunciation: 'SUB-tul-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_020',
          front: 'Ambiguity',
          back: 'Ambiguidade',
          example: 'The ambiguity of the contract caused confusion.',
          pronunciation: 'am-BIG-yuh-wuh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_021',
          front: 'Paradox',
          back: 'Paradoxo',
          example: "There's an interesting paradox in this argument.",
          pronunciation: 'PAR-uh-doks',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_022',
          front: 'Dichotomy',
          back: 'Dicotomia',
          example:
              'The dichotomy between theory and practice is constant '
              'challenge.',
          pronunciation: 'dy-KAH-tuh-mee',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Advanced Adjectives & Descriptors (6 cards)
        FlashcardModel(
          id: 'seed_023',
          front: 'Ambiguous',
          back: 'Ambíguo',
          example: "The government's response was quite ambiguous.",
          pronunciation: 'am-BIG-yuh-wus',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_024',
          front: 'Perspicacious',
          back: 'Perspicaz',
          example: 'Your insightful analysis contributed significantly.',
          pronunciation: 'per-spi-KAY-shus',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_025',
          front: 'Subtle',
          back: 'Sutil',
          example: 'The change was so subtle few noticed initially.',
          pronunciation: 'SUB-tul',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_026',
          front: 'Concomitant',
          back: 'Concomitante',
          example: 'There were several simultaneous changes.',
          pronunciation: 'kun-KOM-i-tant',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_027',
          front: 'Inherent',
          back: 'Inerente',
          example: 'Risk is inherent to any innovative business.',
          pronunciation: 'in-HEER-ent',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_028',
          front: 'Prolix',
          back: 'Prolixo',
          example: "The president's speech was excessively verbose.",
          pronunciation: 'PROH-liks',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Nuanced Expressions & Idioms (6 cards)
        FlashcardModel(
          id: 'seed_029',
          front: 'By way of',
          back: 'À guisa de',
          example: 'By way of conclusion, I summarize the main points.',
          pronunciation: 'by WAY uv',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_030',
          front: 'Despite',
          back: 'Malgrado',
          example: 'Despite the difficulties, we achieved our goals.',
          pronunciation: 'dih-SPYT',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_031',
          front: 'Inasmuch as',
          back: 'Porquanto',
          example: 'The decision was postponed because of missing info.',
          pronunciation: 'in-az-MUCH az',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_032',
          front: 'Nevertheless',
          back: 'Não obstante',
          example:
              'Nevertheless, the project was unanimously approved despite '
              'criticism.',
          pronunciation: 'nev-er-thuh-LES',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_033',
          front: 'Furthermore',
          back: 'Outrossim',
          example: 'Furthermore, we must consider the financial aspects.',
          pronunciation: 'FER-ther-mor',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_034',
          front: 'Thus',
          back: 'Dessarte',
          example: 'Thus, we conclude that the hypothesis was correct.',
          pronunciation: 'THUS',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Technical & Academic Language (4 cards)
        FlashcardModel(
          id: 'seed_035',
          front: 'Methodology',
          back: 'Metodologia',
          example:
              'The methodology used in this research follows '
              'international standards.',
          pronunciation: 'meth-uh-DAL-uh-jee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_036',
          front: 'Hypothesis',
          back: 'Hipótese',
          example:
              'The hypothesis was confirmed through rigorous '
              'experiments.',
          pronunciation: 'hy-PAH-thuh-sis',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_037',
          front: 'To corroborate',
          back: 'Corroborar',
          example: 'The data corroborate our previous interpretation.',
          pronunciation: 'kuh-RAH-buh-rayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_038',
          front: 'To refute',
          back: 'Refutar',
          example: 'The new study completely refutes the previous thesis.',
          pronunciation: 'rih-FYOOT',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Cultural & Advanced Expressions (2 cards)
        FlashcardModel(
          id: 'seed_039',
          front: 'Imponderable',
          back: 'Imponderável',
          example: 'The election result depends on several unknown factors.',
          pronunciation: 'im-PAH-ner-uh-bul',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_040',
          front: 'Serendipity',
          back: 'Serendipidade',
          example: 'We discovered the solution by pure chance.',
          pronunciation: 'ser-en-dip-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

  /// Count of seed flashcards
  static int get length => cards.length;

  /// Check if a flashcard ID belongs to seed data
  static bool isSeedFlashcard(String id) => id.startsWith('seed_');
}
