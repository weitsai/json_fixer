// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_editor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jsonFixerService)
final jsonFixerServiceProvider = JsonFixerServiceProvider._();

final class JsonFixerServiceProvider
    extends
        $FunctionalProvider<
          JsonFixerService,
          JsonFixerService,
          JsonFixerService
        >
    with $Provider<JsonFixerService> {
  JsonFixerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonFixerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonFixerServiceHash();

  @$internal
  @override
  $ProviderElement<JsonFixerService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JsonFixerService create(Ref ref) {
    return jsonFixerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JsonFixerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JsonFixerService>(value),
    );
  }
}

String _$jsonFixerServiceHash() => r'9cfa1387c2abab51267dab8f8d7f7d3963ba9ca6';

/// 輸入文字 Provider

@ProviderFor(InputText)
final inputTextProvider = InputTextProvider._();

/// 輸入文字 Provider
final class InputTextProvider extends $NotifierProvider<InputText, String> {
  /// 輸入文字 Provider
  InputTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputTextHash();

  @$internal
  @override
  InputText create() => InputText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$inputTextHash() => r'a22decae8a2645c8f97b1aadbed55d886230525d';

/// 輸入文字 Provider

abstract class _$InputText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 格式化模式 Provider

@ProviderFor(FormatModeState)
final formatModeStateProvider = FormatModeStateProvider._();

/// 格式化模式 Provider
final class FormatModeStateProvider
    extends $NotifierProvider<FormatModeState, FormatMode> {
  /// 格式化模式 Provider
  FormatModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formatModeStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formatModeStateHash();

  @$internal
  @override
  FormatModeState create() => FormatModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FormatMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FormatMode>(value),
    );
  }
}

String _$formatModeStateHash() => r'38af031f55b8422c3754e2262e8a5670eee91e18';

/// 格式化模式 Provider

abstract class _$FormatModeState extends $Notifier<FormatMode> {
  FormatMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FormatMode, FormatMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FormatMode, FormatMode>,
              FormatMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 輸出文字 Provider (即時修正 JSON，用於樹狀結構)

@ProviderFor(outputText)
final outputTextProvider = OutputTextProvider._();

/// 輸出文字 Provider (即時修正 JSON，用於樹狀結構)

final class OutputTextProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 輸出文字 Provider (即時修正 JSON，用於樹狀結構)
  OutputTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outputTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outputTextHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return outputText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$outputTextHash() => r'cb2e9fe0d72b302e1025553ae349011dd66c85dd';

/// 縮排設定 Provider

@ProviderFor(IndentSize)
final indentSizeProvider = IndentSizeProvider._();

/// 縮排設定 Provider
final class IndentSizeProvider extends $NotifierProvider<IndentSize, int> {
  /// 縮排設定 Provider
  IndentSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'indentSizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$indentSizeHash();

  @$internal
  @override
  IndentSize create() => IndentSize();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$indentSizeHash() => r'3cb02947c94ea2d2237aaf88f28d08e7a6705e75';

/// 縮排設定 Provider

abstract class _$IndentSize extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 輸入字體大小 Provider

@ProviderFor(InputFontSize)
final inputFontSizeProvider = InputFontSizeProvider._();

/// 輸入字體大小 Provider
final class InputFontSizeProvider
    extends $NotifierProvider<InputFontSize, double> {
  /// 輸入字體大小 Provider
  InputFontSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputFontSizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputFontSizeHash();

  @$internal
  @override
  InputFontSize create() => InputFontSize();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$inputFontSizeHash() => r'41f825bd8506d639be2895333f624b2e2a4661db';

/// 輸入字體大小 Provider

abstract class _$InputFontSize extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 輸出字體大小 Provider

@ProviderFor(OutputFontSize)
final outputFontSizeProvider = OutputFontSizeProvider._();

/// 輸出字體大小 Provider
final class OutputFontSizeProvider
    extends $NotifierProvider<OutputFontSize, double> {
  /// 輸出字體大小 Provider
  OutputFontSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outputFontSizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outputFontSizeHash();

  @$internal
  @override
  OutputFontSize create() => OutputFontSize();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$outputFontSizeHash() => r'664f62b08f288c71faa9e5be4523c294cd9b62db';

/// 輸出字體大小 Provider

abstract class _$OutputFontSize extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 錯誤訊息 Provider

@ProviderFor(ErrorMessage)
final errorMessageProvider = ErrorMessageProvider._();

/// 錯誤訊息 Provider
final class ErrorMessageProvider
    extends $NotifierProvider<ErrorMessage, String?> {
  /// 錯誤訊息 Provider
  ErrorMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorMessageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorMessageHash();

  @$internal
  @override
  ErrorMessage create() => ErrorMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$errorMessageHash() => r'673268779e8660217d24bbbc329a4c520bbcfb64';

/// 錯誤訊息 Provider

abstract class _$ErrorMessage extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// JSON 統計資訊 Provider

@ProviderFor(jsonStats)
final jsonStatsProvider = JsonStatsProvider._();

/// JSON 統計資訊 Provider

final class JsonStatsProvider
    extends $FunctionalProvider<JsonStats, JsonStats, JsonStats>
    with $Provider<JsonStats> {
  /// JSON 統計資訊 Provider
  JsonStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonStatsHash();

  @$internal
  @override
  $ProviderElement<JsonStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JsonStats create(Ref ref) {
    return jsonStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JsonStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JsonStats>(value),
    );
  }
}

String _$jsonStatsHash() => r'7d59a702ec328b133c8c2f8cbdc547f4cdea51fc';

/// JSON 驗證結果 Provider

@ProviderFor(jsonValidation)
final jsonValidationProvider = JsonValidationProvider._();

/// JSON 驗證結果 Provider

final class JsonValidationProvider
    extends
        $FunctionalProvider<(bool, String?), (bool, String?), (bool, String?)>
    with $Provider<(bool, String?)> {
  /// JSON 驗證結果 Provider
  JsonValidationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonValidationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonValidationHash();

  @$internal
  @override
  $ProviderElement<(bool, String?)> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  (bool, String?) create(Ref ref) {
    return jsonValidation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((bool, String?) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(bool, String?)>(value),
    );
  }
}

String _$jsonValidationHash() => r'26673e257c32fa9d66aa7d77f105c58ef3fffc42';

/// JSON 編輯器操作類

@ProviderFor(JsonEditor)
final jsonEditorProvider = JsonEditorProvider._();

/// JSON 編輯器操作類
final class JsonEditorProvider extends $NotifierProvider<JsonEditor, void> {
  /// JSON 編輯器操作類
  JsonEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonEditorHash();

  @$internal
  @override
  JsonEditor create() => JsonEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$jsonEditorHash() => r'7351d081d1e9513d7b6eb96047ae0976693d21b0';

/// JSON 編輯器操作類

abstract class _$JsonEditor extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
