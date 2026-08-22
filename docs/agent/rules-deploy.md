# Rules 배포 가이드

Rules **편집 SSOT:** `shared/rules/`, `shared/optional/`, `project-kit/.cursor/rules/`  
회사 킷(슬림): [`company-profile.md`](company-profile.md) · 인벤토리: [`kit-inventory.md`](kit-inventory.md)

## kit 레포에서 작업

**채널 B (권장):** User Rules 중복 없이 워크스페이스 `.cursor/rules/`만 사용.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\sync-kit.ps1
```

**주의:** `.cursor/rules/`는 sync 산출물 — SSOT만 편집.

## 채널 A — User Rules + 제품 `.cursor/rules`

| 위치 | 내용 |
|------|------|
| User Rules | `shared/rules/*.mdc` (회사 킷: 4개 운영 규칙) |
| 제품 `.cursor/rules/` | `60-delivery-gates` + **`encoding-utf8-global`** (`sync-kit-product.ps1` whitelist) |

`shared/optional/locale-ko.mdc`는 팀 정책에 따라 추가.

## 제품 레포 온보딩

[`product-onboarding.md`](product-onboarding.md) — submodule + `/start-setting` + `/start`

## 인코딩

- `encoding-utf8-global.mdc` · [`encoding.md`](encoding.md)
- 제품 템플릿: `project-kit/.editorconfig`, `.gitattributes`

## 버전

kit 태그·CHANGELOG 기준으로 submodule pin.
