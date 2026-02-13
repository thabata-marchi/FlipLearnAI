import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Seed flashcards for initial app load
///
/// Contains 40 high-quality English ↔ Portuguese flashcards
/// for B2-level English learning
abstract class SeedFlashcards {
  /// List of seed flashcards (40 cards - B2 Upper Intermediate Level)
  static List<FlashcardModel> get cards => [
        // Greetings & Common Expressions (6 cards)
        FlashcardModel(
          id: 'seed_001',
          front: 'Hello',
          back: 'Olá',
          example: 'Hello, how are you today?',
          pronunciation: 'huh-LOH',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_002',
          front: 'Good morning',
          back: 'Bom dia',
          example: 'Good morning, professor! Did you sleep well?',
          pronunciation: 'good MOR-ning',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_003',
          front: 'Good night',
          back: 'Boa noite',
          example: 'Good night, sleep well and see you tomorrow.',
          pronunciation: 'good NITE',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_004',
          front: 'Nice to meet you',
          back: 'Prazer em conhecê-lo',
          example: 'Nice to meet you, I am John!',
          pronunciation: 'nise too MEET yoo',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_005',
          front: 'What is your name?',
          back: 'Como você se chama?',
          example: 'What is your name? My name is Maria.',
          pronunciation: 'wot iz yor NAME',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_006',
          front: 'My name is...',
          back: 'Meu nome é...',
          example: 'My name is John, nice to meet you.',
          pronunciation: 'my NAME iz',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Business & Professional Language (6 cards)
        FlashcardModel(
          id: 'seed_007',
          front: 'To devise a strategy',
          back: 'Elaborar uma estratégia',
          example: 'We need to devise a robust strategy before launch.',
          pronunciation: 'too dih-VYZ uh STRAT-uh-jee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_008',
          front: 'To optimize processes',
          back: 'Otimizar processos',
          example: 'The company seeks to optimize processes for efficiency.',
          pronunciation: 'too AHP-tuh-myz PRAH-ses-ez',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_009',
          front: 'Sustainability',
          back: 'Sustentabilidade',
          example: 'Sustainability is a strategic priority for us.',
          pronunciation: 'suh-sten-uh-BIL-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_010',
          front: 'Feasibility',
          back: 'Viabilidade',
          example: 'Evaluate the feasibility of this project first.',
          pronunciation: 'fee-zuh-BIL-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_011',
          front: 'Stakeholder',
          back: 'Interessado',
          example: 'All stakeholders were involved in the decision.',
          pronunciation: 'STAKE-hol-der',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_012',
          front: 'Performance metrics',
          back: 'Desempenho',
          example: 'Employee performance improved significantly this quarter.',
          pronunciation: 'per-FOR-muns MET-riks',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Advanced Verbs & Actions (8 cards)
        FlashcardModel(
          id: 'seed_013',
          front: 'To contravene',
          back: 'Contravir',
          example: "This decision goes against the company's principles.",
          pronunciation: 'too con-truh-VEEN',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_014',
          front: 'To perpetuate',
          back: 'Perpetuar',
          example: 'We should perpetuate the cultural values of our community.',
          pronunciation: 'too per-PET-choo-ayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_015',
          front: 'To imbue',
          back: 'Imbuir',
          example: 'Leadership must imbue employees with purpose and vision.',
          pronunciation: 'too im-BYOO',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_016',
          front: 'To mitigate',
          back: 'Mitigar',
          example: 'It is crucial to mitigate the environmental risks here.',
          pronunciation: 'too MIT-uh-gayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_017',
          front: 'To exacerbate',
          back: 'Exacerbar',
          example:
              'Lack of communication exacerbated the conflict between '
              'departments.',
          pronunciation: 'too ig-ZAS-er-bayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_018',
          front: 'To instigate',
          back: 'Instigar',
          example: 'We should not instigate unnecessary confrontations.',
          pronunciation: 'too IN-sti-gayt',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_019',
          front: 'To overcome',
          back: 'Transpor',
          example: 'Challenges must be overcome with creativity.',
          pronunciation: 'too oh-ver-KUM',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_020',
          front: 'To apprehend',
          back: 'Apreender',
          example: 'The police managed to apprehend the illegal assets.',
          pronunciation: 'too ap-ri-HEND',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Complex Nouns & Abstract Concepts (8 cards)
        FlashcardModel(
          id: 'seed_021',
          front: 'Pragmatism',
          back: 'Pragmatismo',
          example: "The team's pragmatism allowed us to solve it quickly.",
          pronunciation: 'PRAG-muh-tiz-um',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_022',
          front: 'Diligence',
          back: 'Diligência',
          example: 'With due diligence, we identified the system flaws.',
          pronunciation: 'DIL-i-jens',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_023',
          front: 'Rigor',
          back: 'Rigor',
          example: 'Scientific rigor is essential in academic research.',
          pronunciation: 'RIG-er',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_024',
          front: 'Perspicacity',
          back: 'Perspicácia',
          example: 'Your insight allowed us to anticipate market trends.',
          pronunciation: 'per-spi-KAS-uh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_025',
          front: 'Subtlety',
          back: 'Sutileza',
          example: 'The subtlety of this difference went unnoticed by most.',
          pronunciation: 'SUB-tul-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_026',
          front: 'Ambiguity',
          back: 'Ambiguidade',
          example: 'The ambiguity of the contract caused later confusion.',
          pronunciation: 'am-BIG-yuh-wuh-tee',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_027',
          front: 'Paradox',
          back: 'Paradoxo',
          example: "There is an interesting paradox in this philosophical "
              'argument.',
          pronunciation: 'PAR-uh-doks',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_028',
          front: 'Dichotomy',
          back: 'Dicotomia',
          example:
              'The dichotomy between theory and practice is a constant '
              'challenge.',
          pronunciation: 'dy-KAH-tuh-mee',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Advanced Adjectives & Descriptors (6 cards)
        FlashcardModel(
          id: 'seed_029',
          front: 'Ambiguous',
          back: 'Ambíguo',
          example: "The government's response was quite ambiguous.",
          pronunciation: 'am-BIG-yuh-wus',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_030',
          front: 'Perspicacious',
          back: 'Perspicaz',
          example: 'Your insightful analysis contributed significantly.',
          pronunciation: 'per-spi-KAY-shus',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_031',
          front: 'Subtle',
          back: 'Sutil',
          example: 'The change was so subtle that few noticed initially.',
          pronunciation: 'SUB-tul',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_032',
          front: 'Concomitant',
          back: 'Concomitante',
          example: 'There were several simultaneous changes in the '
              'organization.',
          pronunciation: 'kun-KOM-i-tant',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_033',
          front: 'Inherent',
          back: 'Inerente',
          example: 'Risk is inherent to any innovative business venture.',
          pronunciation: 'in-HEER-ent',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_034',
          front: 'Prolix',
          back: 'Prolixo',
          example: "The president's speech was excessively verbose and "
              'confusing.',
          pronunciation: 'PROH-liks',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Nuanced Expressions & Idioms (6 cards)
        FlashcardModel(
          id: 'seed_035',
          front: 'By way of',
          back: 'À guisa de',
          example: 'By way of conclusion, I summarize the main points here.',
          pronunciation: 'by WAY uv',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_036',
          front: 'Despite',
          back: 'Malgrado',
          example: 'Despite the difficulties, we achieved our objectives.',
          pronunciation: 'dih-SPYT',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_037',
          front: 'Inasmuch as',
          back: 'Porquanto',
          example: 'The decision was postponed because essential information '
              'was missing.',
          pronunciation: 'in-az-MUCH az',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_038',
          front: 'Nevertheless',
          back: 'Não obstante',
          example: 'Nevertheless, the project was unanimously approved.',
          pronunciation: 'nev-er-thuh-LES',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_039',
          front: 'Furthermore',
          back: 'Outrossim',
          example: 'Furthermore, we must consider the financial aspects '
              'involved.',
          pronunciation: 'FER-ther-mor',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_040',
          front: 'Thus',
          back: 'Dessarte',
          example: 'Thus, we conclude that the hypothesis was correct.',
          pronunciation: 'THUS',
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

  /// Count of seed flashcards
  static int get length => cards.length;

  /// Check if a flashcard ID belongs to seed data
  static bool isSeedFlashcard(String id) => id.startsWith('seed_');
}
