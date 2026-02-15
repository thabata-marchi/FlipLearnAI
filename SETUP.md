# Setup do Projeto FlipLearnAI

## Pré-requisitos

- Flutter SDK (>=3.19.0)
- Dart SDK (>=3.3.0)
- Android SDK (para builds Android)
- Xcode (para builds iOS - somente macOS)

## Instalação

1. Clone o repositório:
```bash
git clone <seu-repositorio>
cd FlipLearnAI
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Gere os arquivos de código:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Configuração para Build de Release (Android)

### Criando sua Keystore

1. Gere uma keystore para assinar o app:
```bash
keytool -genkey -v -keystore ~/fliplearnai-upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias fliplearnai
```

2. Copie o arquivo de exemplo:
```bash
cp android/key.properties.example android/key.properties
```

3. Edite `android/key.properties` com suas informações:
```properties
storePassword=SUA_SENHA_DA_STORE
keyPassword=SUA_SENHA_DA_KEY
keyAlias=fliplearnai
storeFile=/caminho/completo/para/sua/keystore.jks
```

**⚠️ IMPORTANTE:** Nunca comite o arquivo `key.properties` ou a keystore (`.jks`) no repositório!

## Build

### Debug
```bash
flutter run
```

### Release (Android)
```bash
flutter build appbundle --release
```

O arquivo `.aab` estará em: `build/app/outputs/bundle/release/app-release.aab`

### Release (iOS)
```bash
flutter build ios --release
```

## Testes

```bash
flutter test
```

## Cobertura de Testes

```bash
flutter test --coverage
```

## Licença

[Adicione sua licença aqui]
