# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案概述

JSON Fixer 是一個 Flutter macOS 桌面應用程式，用於修復和格式化非標準 JSON（如 Dart Map 格式）轉為標準 JSON。

## 常用指令

```bash
# 安裝依賴
flutter pub get

# 執行應用程式（macOS）
flutter run -d macos

# 建置 Release 版本
flutter build macos --release

# 執行測試
flutter test

# 程式碼分析
flutter analyze

# 產生 Riverpod 程式碼（如果使用 @riverpod annotation）
dart run build_runner build
```

## 架構設計

### 目錄結構
```
lib/
├── main.dart                 # 應用程式進入點，使用 Riverpod ProviderScope
├── app.dart                  # MaterialApp 配置
├── shared/
│   └── theme/
│       └── app_theme.dart    # 全域主題系統（深色主題）
└── features/
    └── json_editor/
        ├── presentation/
        │   ├── pages/        # 頁面層
        │   └── widgets/      # UI 元件
        ├── providers/        # Riverpod 狀態管理
        └── services/         # 業務邏輯
```

### 狀態管理

使用 Riverpod 進行狀態管理，主要 Provider 位於 `json_editor_provider.dart`：
- `inputTextProvider`: 使用者輸入文字
- `outputTextProvider`: 自動修復後的 JSON（derived provider）
- `jsonStatsProvider`: JSON 統計資訊（行數、大小）
- `jsonValidationProvider`: 驗證結果
- `jsonEditorProvider`: 操作類 Notifier

### 核心服務

`JsonFixerService` (`services/json_fixer_service.dart`) 提供：
- `fixJson()`: 使用 tokenizer 狀態機修復非標準 JSON
- `formatJson()`: 格式化 JSON（可設定縮排）
- `minifyJson()`: 壓縮 JSON
- `validateJson()`: 驗證 JSON 有效性
- `getStats()`: 計算統計資訊

### 主題系統

`AppTheme` 定義完整的深色主題色彩系統，包含：
- 多層次背景色（Deep/Base/Elevated/Surface）
- 強調色（琥珀金系列）
- 功能色（成功/錯誤/資訊）
- 預定義陰影和圓角
- `AppButtonStyle` 提供按鈕樣式工廠方法

## 主要依賴

- `flutter_riverpod`: 狀態管理
- `re_editor`: 程式碼編輯器元件
- `file_picker`: 檔案選擇器

## 開發備註

- 專案僅支援 macOS 平台
- SDK 版本要求：Dart ^3.6.1
- UI 採用左右分割佈局：左側輸入區、右側輸出/樹狀檢視區
