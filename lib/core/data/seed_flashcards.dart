import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Seed flashcards for initial app load
///
/// Contains 40 high-quality Portuguese ↔ English flashcards
/// across multiple vocabulary categories to give users a complete
/// experience before they create or generate their own.
abstract class SeedFlashcards {
  /// List of seed flashcards (40 cards covering common vocabulary)
  static List<FlashcardModel> get cards => [
        // Greetings & Introductions (6 cards)
        FlashcardModel(
          id: 'seed_001',
          front: 'Olá',
          back: 'Hello',
          example: 'Olá, como você está?',
          pronunciation: 'oh-LAH',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_002',
          front: 'Bom dia',
          back: 'Good morning',
          example: 'Bom dia, professor!',
          pronunciation: 'bom DEE-ah',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_003',
          front: 'Boa noite',
          back: 'Good night',
          example: 'Boa noite, durma bem!',
          pronunciation: 'boa NOY-teh',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_004',
          front: 'Prazer em conhecê-lo',
          back: 'Nice to meet you',
          example: 'Prazer em conhecê-lo, João!',
          pronunciation: 'prah-ZER em koh-neh-SEH-lo',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_005',
          front: 'Como você se chama?',
          back: 'What is your name?',
          example: 'Como você se chama? Meu nome é Maria.',
          pronunciation: 'KO-moo voh-SEH se SHA-ma',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_006',
          front: 'Meu nome é...',
          back: 'My name is...',
          example: 'Meu nome é João.',
          pronunciation: 'MEH-oo NO-meh eh',
          createdAt: DateTime(2024, 1, 1),
        ),

        // Numbers & Time (7 cards)
        FlashcardModel(
          id: 'seed_007',
          front: 'Um',
          back: 'One',
          example: 'Eu tenho um livro.',
          pronunciation: 'oom',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_008',
          front: 'Dois',
          back: 'Two',
          example: 'Eu tenho dois gatos.',
          pronunciation: 'doys',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_009',
          front: 'Dez',
          back: 'Ten',
          example: 'Ele tem dez dedos.',
          pronunciation: 'dez',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_010',
          front: 'Cem',
          back: 'One hundred',
          example: 'O livro tem cem páginas.',
          pronunciation: 'sehn',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_011',
          front: 'Que horas são?',
          back: 'What time is it?',
          example: 'Que horas são? São duas e meia.',
          pronunciation: 'keh OH-ras sow',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_012',
          front: 'Hoje',
          back: 'Today',
          example: 'Hoje é sexta-feira.',
          pronunciation: 'oh-JEH',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_013',
          front: 'Amanhã',
          back: 'Tomorrow',
          example: 'Amanhã vou ao cinema.',
          pronunciation: 'ah-mah-NYAH',
          createdAt: DateTime(2024, 1, 1),
        ),

        // Colors & Shapes (5 cards)
        FlashcardModel(
          id: 'seed_014',
          front: 'Vermelho',
          back: 'Red',
          example: 'A maçã é vermelha.',
          pronunciation: 'ver-MEH-lho',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_015',
          front: 'Azul',
          back: 'Blue',
          example: 'O céu é azul.',
          pronunciation: 'ah-ZOOl',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_016',
          front: 'Verde',
          back: 'Green',
          example: 'A grama é verde.',
          pronunciation: 'VER-deh',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_017',
          front: 'Círculo',
          back: 'Circle',
          example: 'A lua é um círculo.',
          pronunciation: 'SER-koo-lo',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_018',
          front: 'Quadrado',
          back: 'Square',
          example: 'A caixa é um quadrado.',
          pronunciation: 'kwa-DRAH-do',
          createdAt: DateTime(2024, 1, 1),
        ),

        // Food & Drinks (7 cards)
        FlashcardModel(
          id: 'seed_019',
          front: 'Maçã',
          back: 'Apple',
          example: 'Eu como uma maçã todo dia.',
          pronunciation: 'mah-SAN',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_020',
          front: 'Pão',
          back: 'Bread',
          example: 'Eu como pão no café da manhã.',
          pronunciation: 'pah-OW',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_021',
          front: 'Água',
          back: 'Water',
          example: 'Beba água todos os dias.',
          pronunciation: 'AH-gwah',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_022',
          front: 'Leite',
          back: 'Milk',
          example: 'Eu bebo leite quente à noite.',
          pronunciation: 'LAY-teh',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_023',
          front: 'Queijo',
          back: 'Cheese',
          example: 'Eu gosto de queijo italiano.',
          pronunciation: 'KAY-jo',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_024',
          front: 'Arroz',
          back: 'Rice',
          example: 'Para o almoço, comi arroz e feijão.',
          pronunciation: 'ah-HOSH',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_025',
          front: 'Café',
          back: 'Coffee',
          example: 'Eu tomo café da manhã cedo.',
          pronunciation: 'kah-FEH',
          createdAt: DateTime(2024, 1, 1),
        ),

        // Common Verbs & Actions (8 cards)
        FlashcardModel(
          id: 'seed_026',
          front: 'Ir',
          back: 'To go',
          example: 'Eu vou ao trabalho todos os dias.',
          pronunciation: 'eer',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_027',
          front: 'Vir',
          back: 'To come',
          example: 'Ele vem para casa à noite.',
          pronunciation: 'veer',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_028',
          front: 'Fazer',
          back: 'To do / To make',
          example: 'Eu faço o dever de casa todos os dias.',
          pronunciation: 'fah-ZER',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_029',
          front: 'Falar',
          back: 'To speak / To talk',
          example: 'Eu falo português e inglês.',
          pronunciation: 'fah-LAR',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_030',
          front: 'Comer',
          back: 'To eat',
          example: 'Eu como frutas no café da manhã.',
          pronunciation: 'koh-MER',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_031',
          front: 'Beber',
          back: 'To drink',
          example: 'Eu bebo suco de laranja.',
          pronunciation: 'beh-BER',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_032',
          front: 'Estudar',
          back: 'To study',
          example: 'Eu estudo português três vezes por semana.',
          pronunciation: 'es-too-DAR',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_033',
          front: 'Trabalhar',
          back: 'To work',
          example: 'Eu trabalho em uma empresa de tecnologia.',
          pronunciation: 'trah-bah-LYAR',
          createdAt: DateTime(2024, 1, 1),
        ),

        // Daily Expressions & Questions (7 cards)
        FlashcardModel(
          id: 'seed_034',
          front: 'Obrigado',
          back: 'Thank you',
          example: 'Obrigado pela ajuda!',
          pronunciation: 'oh-bree-GAH-do',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_035',
          front: 'De nada',
          back: "You're welcome",
          example: 'De nada, fico feliz em ajudar!',
          pronunciation: 'deh NAH-dah',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_036',
          front: 'Por favor',
          back: 'Please',
          example: 'Um café por favor!',
          pronunciation: 'por fah-VOR',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_037',
          front: 'Me ajude!',
          back: 'Help me!',
          example: 'Me ajude, por favor! Perdi meu passaporte!',
          pronunciation: 'meh ah-ZOO-deh',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_038',
          front: 'Quanto custa?',
          back: 'How much does it cost?',
          example: 'Quanto custa este livro?',
          pronunciation: 'KWAN-to KOOS-tah',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_039',
          front: 'Onde é o banheiro?',
          back: 'Where is the bathroom?',
          example: 'Desculpe, onde é o banheiro?',
          pronunciation: 'ON-deh eh o bah-NYAY-ro',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_040',
          front: 'Não entendo',
          back: "I don't understand",
          example: 'Desculpe, não entendo. Pode falar de novo?',
          pronunciation: 'now en-TEN-do',
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

  /// Count of seed flashcards
  static int get length => cards.length;

  /// Check if a flashcard ID belongs to seed data
  static bool isSeedFlashcard(String id) => id.startsWith('seed_');
}
