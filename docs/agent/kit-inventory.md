# Kit inventory

Kit SSOT는 Git에서 관리한다. **편집은 SSOT 경로만** 하고, `.cursor/`는 sync 산출물이다.

**동기화:** [`scripts/sync-kit.ps1`](../../scripts/sync-kit.ps1)

| 산출물 | SSOT |
|--------|------|
| `.cursor/rules/` | `shared/rules/`, `shared/optional/`, `project-kit/.cursor/rules/` |
| `.cursor/skills/` | `shared/skills/` |
| `.cursor/agents/` | `shared/agents/` |

회사 킷 프로파일(슬림): [`company-profile.md`](company-profile.md)

---

## shared/rules (항상·운영)

| 파일 | 목적 |
|------|------|
| `working-principles.mdc` | 계획·분담·HUMAN·DoD·DB 기본 |
| `encoding-utf8-global.mdc` | UTF-8 |
| `emergent-rule-capture-global.mdc` | 규칙 후보 |
| `dev-server-cleanup-global.mdc` | dev 서버 정리 |

## shared/optional

| 파일 | 목적 |
|------|------|
| `locale-ko.mdc` | 한국어 응답 (선택) |

## project-kit/.cursor/rules

| 파일 | 목적 |
|------|------|
| `60-delivery-gates.mdc` | Gate 1~3, ATDD-lite, 병렬 |

## shared/skills

| 폴더 | 용도 |
|------|------|
| `plan-feature` | 범위·정책 정리 |
| `start-feature` | Gate 1 후 구현 |
| `parallel-delivery` | Gate 2 FE/BE 병렬 |
| `verify-change` | Gate 3 검증 |
| `document-change` | 변경 문서 |
| `bugfix-flow` | 버그 |
| `release-check` | 배포 전 |
| `kit-start` | `/start` sync |
| `start-setting` | `/start-setting` 온보딩 |
| `kit-wiki` | LLM 위키 |
| `kit-rule-mine` | 규칙 마이닝 |
| `kit-work-log` | 작업 일지 |
| `cross-check` | 교차 검증 |

## shared/agents

| 파일 | 용도 |
|------|------|
| `frontend-agent.md` | 클라이언트·화면 구현 |
| `backend-agent.md` | API·DB·서버 |
| `prd-agent.md` | 요구·범위 |
| `qa-agent.md` | 독립 검증 |
| `docs-agent.md` | 문서 |

## docs/qa

| 경로 | 목적 |
|------|------|
| `atdd-lite.md` | ATDD SSOT |
| `acceptance-criteria.template.md` | AC 템플릿 |
| `integration-consumption-gate.md` | kit·공유 패키지 소비 DoD |

## scripts (핵심)

| 스크립트 | 용도 |
|----------|------|
| `sync-kit.ps1` | kit 레포 sync |
| `sync-kit-product.ps1` | 제품 `.cursor/` sync (retired rule/skill prune 포함) |
| `Invoke-KitStartSetting.ps1` | 제품 1회 온보딩 |
| `Invoke-KitStart.ps1` | `/start` |

## 제거됨 (회사 킷)

수익/광고, UX·다크·CSS 규칙, 이중 디자인·lifecycle·design-brief, optional 21~24 및 docs/mobile|product-analytics|performance|security, `design-system-agent` — [`company-profile.md`](company-profile.md)
