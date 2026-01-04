# JSON Fixer

一個 Flutter macOS 桌面應用程式，用於修復和格式化非標準 JSON。

## 開發背景

在 Flutter 開發中使用 Dio 套件時，後端回傳的 JSON 內容在 console log 中往往會失去雙引號，變成類似 Dart Map 的格式：

```
{name: John, age: 25, active: true}
```

這種格式無法直接貼到 JSON 工具中使用，也難以閱讀複雜的巢狀結構。本專案就是為了解決這個痛點，讓開發者可以快速將 log 中的內容轉換為標準 JSON 格式。

## 功能特色

- **自動修復 JSON** - 將非標準 JSON（如 Dart Map 格式、單引號字串、無引號 key）轉換為標準 JSON
- **樹狀結構檢視** - 以階層方式瀏覽 JSON 結構
- **統計資訊** - 顯示行數、檔案大小等資訊

## 快速開始

```bash
# 安裝依賴
flutter pub get

# 執行應用程式
flutter run -d macos
```

## 建置

```bash
# 建置 Release 版本
flutter build macos --release
```

建置產物位於 `build/macos/Build/Products/Release/json_fixer.app`

## 專案架構

```
lib/
├── main.dart                 # 應用程式進入點
├── app.dart                  # MaterialApp 配置
├── shared/
│   └── theme/                # 全域主題系統
└── features/
    └── json_editor/
        ├── presentation/     # UI 層（頁面與元件）
        ├── providers/        # Riverpod 狀態管理
        └── services/         # 業務邏輯（JSON 修復核心）
```