/// Reads secrets from compile-time environment variables instead of
/// hardcoding them in source.
///
/// The Pexels API key is supplied when you run/build the app, e.g.:
///
///   flutter run --dart-define-from-file=config/pexels.json
///
/// `config/pexels.json` is a local, git-ignored file — see
/// `config/pexels.example.json` for the format. Nothing here ever
/// contains the real key.
class Env {
  Env._();

  static const String pexelsApiKey = String.fromEnvironment('PEXELS_API_KEY');

  static bool get hasPexelsKey => pexelsApiKey.trim().isNotEmpty;
}
