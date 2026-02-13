import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Seed flashcards for initial app load
///
/// Contains 40 high-quality B2/C1-level English flashcards
/// for advanced English learning
abstract class SeedFlashcards {
  /// List of seed flashcards (40 cards - B2/C1 Level)
  static List<FlashcardModel> get cards => [
        // Advanced Verbs (10 cards)
        FlashcardModel(
          id: 'seed_001',
          front: 'Deteriorate',
          back: 'Deteriorar',
          pronunciation: '/dɪˈtɪr.i.ə.reɪt/ (di-tí-ri-a-rêit)',
          example:
              '''Working conditions have deteriorated significantly over the past year.

Deteriorate significa:
- Deteriorar, piorar (mais comum)
- Degradar-se gradualmente
- Declinar em qualidade ou condição

Exemplos:
His health began to deteriorate rapidly.
→ A saúde dele começou a deteriorar rapidamente.

The relationship deteriorated after the argument.
→ O relacionamento deteriorou após a discussão.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_002',
          front: 'Discern',
          back: 'Discernir',
          pronunciation: '/dɪˈsɜːrn/ (di-sérn)',
          example:
              '''It is difficult to discern truth from fiction in modern media.

Discern significa:
- Discernir, distinguir (mais comum)
- Perceber com dificuldade
- Reconhecer, identificar

Exemplos:
She could discern a pattern in the data.
→ Ela conseguiu discernir um padrão nos dados.

We need to discern the underlying causes.
→ Precisamos discernir as causas subjacentes.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_003',
          front: 'Encompass',
          back: 'Abranger',
          pronunciation: '/ɪnˈkʌm.pəs/ (in-kâm-pes)',
          example:
              '''The project encompasses multiple disciplines including design and engineering.

Encompass significa:
- Abranger, incluir (mais comum)
- Envolver, compreender
- Circundar, cercar

Exemplos:
The curriculum encompasses various subjects.
→ O currículo abrange várias matérias.

His responsibilities encompass team management.
→ Suas responsabilidades abrangem gestão de equipe.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_004',
          front: 'Jeopardize',
          back: 'Comprometer',
          pronunciation: '/ˈdʒep.ɚ.daɪz/ (djé-per-daiz)',
          example:
              '''Poor planning could jeopardize the entire project timeline.

Jeopardize significa:
- Comprometer, colocar em risco (mais comum)
- Ameaçar, pôr em perigo
- Arriscar perder algo

Exemplos:
Don't jeopardize your career over this.
→ Não comprometa sua carreira por causa disso.

The scandal jeopardized the company's reputation.
→ O escândalo comprometeu a reputação da empresa.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_005',
          front: 'Perpetuate',
          back: 'Perpetuar',
          pronunciation: '/pɚˈpet.ʃu.eɪt/ (per-pé-tchu-êit)',
          example: '''These stereotypes perpetuate harmful attitudes in society.

Perpetuate significa:
- Perpetuar, fazer durar (mais comum)
- Manter indefinidamente
- Continuar, prolongar

Exemplos:
We must not perpetuate these inequalities.
→ Não devemos perpetuar essas desigualdades.

The system perpetuates poverty.
→ O sistema perpetua a pobreza.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_006',
          front: 'Preclude',
          back: 'Impedir',
          pronunciation: '/prɪˈkluːd/ (pri-klúd)',
          example:
              '''Budget limitations preclude hiring additional staff this quarter.

Preclude significa:
- Impedir, excluir a possibilidade (mais comum)
- Prevenir, evitar
- Tornar impossível

Exemplos:
His injury precludes him from competing.
→ A lesão dele o impede de competir.

This does not preclude future opportunities.
→ Isso não impede oportunidades futuras.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_007',
          front: 'Provoke',
          back: 'Provocar',
          pronunciation: '/prəˈvoʊk/ (pro-vôuk)',
          example:
              '''The policy change provoked widespread criticism from stakeholders.

Provoke significa:
- Provocar, incitar (mais comum)
- Causar, gerar (reação)
- Irritar deliberadamente

Exemplos:
His comments provoked angry responses.
→ Os comentários dele provocaram respostas irritadas.

The decision provoked debate.
→ A decisão provocou debate.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_008',
          front: 'Relinquish',
          back: 'Renunciar',
          pronunciation: '/rɪˈlɪŋ.kwɪʃ/ (ri-lín-kuish)',
          example:
              '''The CEO decided to relinquish control to focus on strategic planning.

Relinquish significa:
- Renunciar, abandonar (mais comum)
- Ceder, abrir mão
- Desistir voluntariamente

Exemplos:
She refused to relinquish her position.
→ Ela se recusou a renunciar sua posição.

He relinquished all claims to the property.
→ Ele renunciou todas as reivindicações sobre a propriedade.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_009',
          front: 'Suppress',
          back: 'Reprimir',
          pronunciation: '/səˈpres/ (sa-prés)',
          example:
              '''Authoritarian governments often suppress freedom of speech and expression.

Suppress significa:
- Reprimir, conter (mais comum)
- Suprimir, eliminar
- Esconder, ocultar

Exemplos:
She tried to suppress her emotions.
→ Ela tentou reprimir suas emoções.

The report was suppressed by management.
→ O relatório foi suprimido pela administração.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_010',
          front: 'Underestimate',
          back: 'Subestimar',
          pronunciation: '/ˌʌn.dɚˈes.tə.meɪt/ (ân-der-és-ti-mêit)',
          example:
              '''Never underestimate the importance of thorough preparation and planning.

Underestimate significa:
- Subestimar, avaliar abaixo do real (mais comum)
- Menosprezar
- Calcular por baixo

Exemplos:
Don't underestimate your competitors.
→ Não subestime seus concorrentes.

We underestimated the project's complexity.
→ Subestimamos a complexidade do projeto.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Complex Nouns (10 cards)
        FlashcardModel(
          id: 'seed_011',
          front: 'Accountability',
          back: 'Responsabilização',
          pronunciation: '/əˌkaʊn.t̬əˈbɪl.ə.t̬i/ (a-kaun-ta-bí-li-ti)',
          example:
              '''Transparency and accountability are essential for good governance.

Accountability significa:
- Responsabilização, prestação de contas (mais comum)
- Obrigação de responder por ações
- Responsabilidade demonstrável

Exemplos:
There is little accountability in the system.
→ Há pouca responsabilização no sistema.

We must ensure accountability at all levels.
→ Devemos garantir responsabilização em todos os níveis.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_012',
          front: 'Autonomy',
          back: 'Autonomia',
          pronunciation: '/ɔːˈtɑː.nə.mi/ (ô-tá-no-mi)',
          example:
              '''Employees value autonomy in how they manage their daily tasks.

Autonomy significa:
- Autonomia, independência (mais comum)
- Autogoverno
- Liberdade de decisão

Exemplos:
The region gained greater autonomy.
→ A região ganhou maior autonomia.

Professional autonomy is important.
→ Autonomia profissional é importante.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_013',
          front: 'Credibility',
          back: 'Credibilidade',
          pronunciation: '/ˌkred.əˈbɪl.ə.t̬i/ (kre-da-bí-li-ti)',
          example:
              '''The research's credibility depends on rigorous methodology and transparency.

Credibility significa:
- Credibilidade, confiabilidade (mais comum)
- Capacidade de ser acreditado
- Reputação de honestidade

Exemplos:
His credibility was damaged by the scandal.
→ A credibilidade dele foi danificada pelo escândalo.

We must maintain our credibility.
→ Devemos manter nossa credibilidade.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_014',
          front: 'Discretion',
          back: 'Discrição',
          pronunciation: '/dɪˈskreʃ.ən/ (dis-kré-shen)',
          example:
              '''Managers have discretion in how they allocate team resources.

Discretion significa:
- Discrição, critério pessoal (mais comum)
- Poder de decisão
- Capacidade de ser discreto

Exemplos:
Use your discretion in this matter.
→ Use seu critério neste assunto.

The information was handled with discretion.
→ A informação foi tratada com discrição.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_015',
          front: 'Framework',
          back: 'Estrutura',
          pronunciation: '/ˈfreɪm.wɜːrk/ (frêim-uórk)',
          example:
              '''The organization developed a framework for evaluating employee performance.

Framework significa:
- Estrutura, arcabouço (mais comum)
- Sistema de regras ou conceitos
- Modelo, moldura conceitual

Exemplos:
We need a theoretical framework.
→ Precisamos de uma estrutura teórica.

The legal framework is inadequate.
→ A estrutura legal é inadequada.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_016',
          front: 'Implication',
          back: 'Implicação',
          pronunciation: '/ˌɪm.pləˈkeɪ.ʃən/ (im-pli-kêi-shen)',
          example:
              '''The policy change has serious implications for small businesses.

Implication significa:
- Implicação, consequência (mais comum)
- Sugestão indireta
- Envolvimento, conexão

Exemplos:
What are the implications of this decision?
→ Quais são as implicações desta decisão?

The implications are far-reaching.
→ As implicações são de longo alcance.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_017',
          front: 'Integrity',
          back: 'Integridade',
          pronunciation: '/ɪnˈteɡ.rə.t̬i/ (in-té-gri-ti)',
          example:
              '''Professional integrity requires honesty even when it's difficult.

Integrity significa:
- Integridade, honestidade (mais comum)
- Totalidade, completude
- Consistência moral

Exemplos:
His integrity is beyond question.
→ A integridade dele está além de questionamento.

Data integrity must be maintained.
→ A integridade dos dados deve ser mantida.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_018',
          front: 'Magnitude',
          back: 'Magnitude',
          pronunciation: '/ˈmæɡ.nə.tuːd/ (mág-ni-tiúd)',
          example:
              '''The magnitude of the climate crisis requires immediate global action.

Magnitude significa:
- Magnitude, grandeza (mais comum)
- Tamanho, escala
- Importância, extensão

Exemplos:
We underestimated the magnitude of the problem.
→ Subestimamos a magnitude do problema.

An earthquake of significant magnitude occurred.
→ Um terremoto de magnitude significativa ocorreu.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_019',
          front: 'Nuance',
          back: 'Nuance',
          pronunciation: '/ˈnuː.ɑːns/ (nú-ans)',
          example:
              '''Understanding cultural nuances is crucial for effective international business.

Nuance significa:
- Nuance, sutileza (mais comum)
- Pequena diferença de significado
- Matiz, tonalidade

Exemplos:
The argument lacks nuance.
→ O argumento carece de nuance.

She explained the nuances of the policy.
→ Ela explicou as nuances da política.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_020',
          front: 'Trajectory',
          back: 'Trajetória',
          pronunciation: '/trəˈdʒek.tər.i/ (tra-djék-to-ri)',
          example:
              '''The company's growth trajectory suggests continued expansion in emerging markets.

Trajectory significa:
- Trajetória, caminho (mais comum)
- Curso de desenvolvimento
- Direção de movimento

Exemplos:
Her career trajectory has been impressive.
→ A trajetória da carreira dela tem sido impressionante.

The economic trajectory is concerning.
→ A trajetória econômica é preocupante.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Advanced Adjectives (10 cards)
        FlashcardModel(
          id: 'seed_021',
          front: 'Conducive',
          back: 'Propício',
          pronunciation: '/kənˈduː.sɪv/ (ken-dú-siv)',
          example:
              '''A quiet environment is conducive to focused work and concentration.

Conducive significa:
- Propício, favorável (mais comum)
- Que contribui para
- Que facilita

Exemplos:
The atmosphere is conducive to learning.
→ A atmosfera é propícia ao aprendizado.

These conditions are not conducive to success.
→ Essas condições não são propícias ao sucesso.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_022',
          front: 'Detrimental',
          back: 'Prejudicial',
          pronunciation: '/ˌdet.rəˈmen.t̬əl/ (de-tri-mén-tel)',
          example:
              '''Excessive screen time can be detrimental to children's development.

Detrimental significa:
- Prejudicial, danoso (mais comum)
- Que causa dano
- Nocivo, negativo

Exemplos:
The policy had detrimental effects.
→ A política teve efeitos prejudiciais.

Smoking is detrimental to your health.
→ Fumar é prejudicial à sua saúde.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_023',
          front: 'Elusive',
          back: 'Elusivo',
          pronunciation: '/ɪˈluː.sɪv/ (i-lú-siv)',
          example:
              '''Success in this industry remains elusive for most startups.

Elusive significa:
- Elusivo, difícil de alcançar (mais comum)
- Fugidio, que escapa
- Difícil de definir ou lembrar

Exemplos:
The solution proved elusive.
→ A solução se mostrou elusiva.

Peace remains elusive in the region.
→ A paz permanece elusiva na região.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_024',
          front: 'Formidable',
          back: 'Formidável',
          pronunciation: '/ˈfɔːr.mə.də.bəl/ (fór-mi-da-bel)',
          example:
              '''The team faces formidable challenges in the upcoming quarter.

Formidable significa:
- Formidável, impressionante (mais comum)
- Intimidante, que inspira respeito
- Difícil de lidar

Exemplos:
She is a formidable opponent.
→ Ela é uma oponente formidável.

The task ahead is formidable.
→ A tarefa pela frente é formidável.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_025',
          front: 'Intricate',
          back: 'Intrincado',
          pronunciation: '/ˈɪn.trɪ.kət/ (ín-tri-ket)',
          example:
              '''The software architecture is intricate and requires detailed documentation.

Intricate significa:
- Intrincado, complexo (mais comum)
- Detalhado, elaborado
- Complicado, difícil de entender

Exemplos:
The design features intricate patterns.
→ O design apresenta padrões intrincados.

This is an intricate problem.
→ Este é um problema intrincado.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_026',
          front: 'Negligible',
          back: 'Insignificante',
          pronunciation: '/ˈneɡ.lə.dʒə.bəl/ (né-gli-dja-bel)',
          example: '''The impact of this change on overall costs is negligible.

Negligible significa:
- Insignificante, desprezível (mais comum)
- Muito pequeno para importar
- Mínimo, irrelevante

Exemplos:
The difference is negligible.
→ A diferença é insignificante.

The risk is negligible.
→ O risco é insignificante.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_027',
          front: 'Obsolete',
          back: 'Obsoleto',
          pronunciation: '/ˌɑːb.səˈliːt/ (áb-so-lít)',
          example:
              '''Many traditional manufacturing processes are becoming obsolete due to automation.

Obsolete significa:
- Obsoleto, ultrapassado (mais comum)
- Fora de uso
- Antiquado, desatualizado

Exemplos:
The technology is now obsolete.
→ A tecnologia agora está obsoleta.

These methods are obsolete.
→ Esses métodos são obsoletos.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_028',
          front: 'Pragmatic',
          back: 'Pragmático',
          pronunciation: '/præɡˈmæt̬.ɪk/ (prag-má-tik)',
          example:
              '''We need a pragmatic approach that focuses on practical solutions.

Pragmatic significa:
- Pragmático, prático (mais comum)
- Focado em resultados
- Realista, sensato

Exemplos:
His decision was pragmatic.
→ A decisão dele foi pragmática.

Take a pragmatic view of the situation.
→ Tenha uma visão pragmática da situação.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_029',
          front: 'Prevalent',
          back: 'Prevalente',
          pronunciation: '/ˈprev.əl.ənt/ (pré-va-lent)',
          example:
              '''Remote work has become increasingly prevalent in the tech industry.

Prevalent significa:
- Prevalente, comum (mais comum)
- Generalizado, difundido
- Predominante

Exemplos:
This view is prevalent among experts.
→ Esta visão é prevalente entre especialistas.

The disease is prevalent in the region.
→ A doença é prevalente na região.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_030',
          front: 'Vulnerable',
          back: 'Vulnerável',
          pronunciation: '/ˈvʌl.nɚ.ə.bəl/ (vâl-ne-ra-bel)',
          example:
              '''Small businesses are particularly vulnerable during economic downturns.

Vulnerable significa:
- Vulnerável, suscetível (mais comum)
- Frágil, desprotegido
- Exposto a danos

Exemplos:
Children are vulnerable to exploitation.
→ Crianças são vulneráveis à exploração.

The system is vulnerable to attacks.
→ O sistema é vulnerável a ataques.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        // Professional & Academic Terms (10 cards)
        FlashcardModel(
          id: 'seed_031',
          front: 'Coherence',
          back: 'Coerência',
          pronunciation: '/koʊˈhɪr.əns/ (côu-hí-rens)',
          example:
              '''The proposal lacks coherence and needs better organization.

Coherence significa:
- Coerência, consistência lógica (mais comum)
- Conexão clara entre ideias
- Unidade, harmonia

Exemplos:
The argument lacks coherence.
→ O argumento carece de coerência.

We need coherence in our messaging.
→ Precisamos de coerência em nossa mensagem.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_032',
          front: 'Contemplate',
          back: 'Contemplar',
          pronunciation: '/ˈkɑːn.t̬əm.pleɪt/ (kán-tem-plêit)',
          example:
              '''The board will contemplate various strategic options before deciding.

Contemplate significa:
- Contemplar, considerar (mais comum)
- Pensar profundamente sobre
- Planejar, ponderar

Exemplos:
She contemplated changing careers.
→ Ela contemplou mudar de carreira.

We must contemplate the consequences.
→ Devemos contemplar as consequências.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_033',
          front: 'Correlate',
          back: 'Correlacionar',
          pronunciation: '/ˈkɔːr.ə.leɪt/ (kó-re-lêit)',
          example:
              '''Research shows that exercise levels correlate with overall health outcomes.

Correlate significa:
- Correlacionar, relacionar (mais comum)
- Ter conexão mútua
- Corresponder

Exemplos:
High grades correlate with study time.
→ Notas altas correlacionam com tempo de estudo.

These factors correlate significantly.
→ Esses fatores correlacionam significativamente.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_034',
          front: 'Differentiate',
          back: 'Diferenciar',
          pronunciation: '/ˌdɪf.əˈren.ʃi.eɪt/ (di-fe-rén-shi-êit)',
          example:
              '''Companies must differentiate their products to succeed in competitive markets.

Differentiate significa:
- Diferenciar, distinguir (mais comum)
- Tornar diferente
- Reconhecer diferenças

Exemplos:
We need to differentiate our brand.
→ Precisamos diferenciar nossa marca.

Can you differentiate between the two?
→ Você consegue diferenciar entre os dois?''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_035',
          front: 'Empirical',
          back: 'Empírico',
          pronunciation: '/ɪmˈpɪr.ɪ.kəl/ (im-pí-ri-kel)',
          example:
              '''Scientific conclusions must be based on empirical evidence and observation.

Empirical significa:
- Empírico, baseado em observação (mais comum)
- Experimental, verificável
- Baseado em evidências

Exemplos:
The study provides empirical data.
→ O estudo fornece dados empíricos.

We need empirical evidence.
→ Precisamos de evidência empírica.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_036',
          front: 'Fluctuate',
          back: 'Flutuar',
          pronunciation: '/ˈflʌk.tʃu.eɪt/ (flâk-tchu-êit)',
          example:
              '''Currency exchange rates fluctuate constantly throughout the trading day.

Fluctuate significa:
- Flutuar, variar (mais comum)
- Oscilar irregularmente
- Mudar frequentemente

Exemplos:
Prices fluctuate with demand.
→ Preços flutuam com a demanda.

His mood tends to fluctuate.
→ O humor dele tende a flutuar.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_037',
          front: 'Innovate',
          back: 'Inovar',
          pronunciation: '/ˈɪn.ə.veɪt/ (í-no-vêit)',
          example:
              '''Tech companies must constantly innovate to maintain competitive advantage.

Innovate significa:
- Inovar, criar algo novo (mais comum)
- Introduzir mudanças
- Desenvolver novas ideias

Exemplos:
We need to innovate our processes.
→ Precisamos inovar nossos processos.

The industry continues to innovate.
→ A indústria continua a inovar.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_038',
          front: 'Prioritize',
          back: 'Priorizar',
          pronunciation: '/praɪˈɔːr.ə.taɪz/ (prai-ór-a-taiz)',
          example:
              '''Effective leaders know how to prioritize tasks based on strategic importance.

Prioritize significa:
- Priorizar, dar prioridade (mais comum)
- Ordenar por importância
- Estabelecer prioridades

Exemplos:
We must prioritize customer satisfaction.
→ Devemos priorizar a satisfação do cliente.

Learn to prioritize your time.
→ Aprenda a priorizar seu tempo.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_039',
          front: 'Stagnant',
          back: 'Estagnado',
          pronunciation: '/ˈstæɡ.nənt/ (stág-nent)',
          example:
              '''Economic growth has been stagnant for the past three quarters.

Stagnant significa:
- Estagnado, parado (mais comum)
- Sem progresso ou desenvolvimento
- Inativo, sem movimento

Exemplos:
Wages have remained stagnant.
→ Os salários permaneceram estagnados.

The market is stagnant.
→ O mercado está estagnado.''',
          createdAt: DateTime(2024, 1, 1),
        ),
        FlashcardModel(
          id: 'seed_040',
          front: 'Substantiate',
          back: 'Fundamentar',
          pronunciation: '/səbˈstæn.ʃi.eɪt/ (sab-stân-shi-êit)',
          example:
              '''You need to substantiate your claims with concrete evidence and data.

Substantiate significa:
- Fundamentar, comprovar (mais comum)
- Fornecer evidências para
- Justificar com fatos

Exemplos:
Can you substantiate this accusation?
→ Você pode fundamentar esta acusação?

The theory is difficult to substantiate.
→ A teoria é difícil de fundamentar.''',
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

  /// Count of seed flashcards
  static int get length => cards.length;

  /// Check if a flashcard ID belongs to seed data
  static bool isSeedFlashcard(String id) => id.startsWith('seed_');
}
