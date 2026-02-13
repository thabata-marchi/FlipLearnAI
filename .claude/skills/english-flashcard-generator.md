    skill: EnglishFlashcardGenerator
version: 1.0
description: >
  Geração de flashcards de inglês nível B2 com foco educacional,
  seguindo estrutura fixa e padronizada para ensino do idioma.

objective:
  - Gerar vocabulário nível B2 ou superior.
  - Ensinar significado, pronúncia e uso contextual.
  - Manter consistência estrutural para escalabilidade e validação.

rules:
  level:
    - Apenas palavras B2 ou superior (intermediário-avançado).
    - Proibido usar palavras básicas (A1–B1).

  structure_required: |
    Word: <palavra>

    Pronúncia: <IPA> (<pronúncia aproximada em português>)

    <Frase contextual em inglês usando a palavra>

    <Palavra> significa:
    - <significado 1>
    - <significado 2 se aplicável>
    - <significado 3 se aplicável>

    Exemplos:
    <Frase em inglês>
    → <Tradução em português>

    <Frase em inglês>
    → <Tradução em português>

  context:
    - A frase principal deve ser natural e realista.
    - Priorizar contexto profissional, acadêmico ou cotidiano avançado.
    - Evitar frases artificiais.

  translation:
    - Tradução fiel ao contexto.
    - Evitar tradução excessivamente literal.
    - Manter clareza pedagógica.

restrictions:
  - Não alterar o formato definido.
  - Não adicionar comentários fora da estrutura.
  - Não incluir emojis.
  - Não incluir explicações gramaticais extensas.

quality_criteria:
  - Uso correto da IPA.
  - Frases naturais e coerentes.
  - Vocabulário relevante para comunicação profissional e acadêmica.
  - Conteúdo didático e consistente.
