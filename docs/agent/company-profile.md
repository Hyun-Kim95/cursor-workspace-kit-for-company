# 회사 킷 프로파일

이 레포(`cursor-workspace-kit-for-company`)의 **고정된 전제**다.

## 확정 (HUMAN)

| 항목 | 값 | 일자 |
|------|-----|------|
| 형태 | **A** — 회사 전용 킷 레포 (제품은 submodule로 소비) | 2026-08-20 |
| 주 용도 | **사내 제품만** | 2026-08-20 |
| Git remote | https://github.com/Hyun-Kim95/cursor-workspace-kit-for-company.git | 2026-08-21 |
| 정책 범위 | **슬림** — 수익/UX/디자인 게이트/optional 도메인 게이트 **미포함** | 2026-08-22 |

## 유지 (핵심)

| 영역 | SSOT |
|------|------|
| Gate 1~3 · ATDD-lite | `60-delivery-gates.mdc` |
| 작업·분담·DoD | `working-principles.mdc` |
| kit 운영 | `/start-setting`, `/start`, harness |
| 인코딩 | `encoding-utf8-global.mdc` |

## 제거됨 (의도적)

- 사업자·수익·광고 (`product-monetization` 등)
- 이중 디자인·`65-design-gate`·`design-brief`·Stitch·`client-project-lifecycle`·`70`
- UX 전역 규칙 (`product-ui-core`, web/app, table, dark, CSS contract)
- optional `21`~`24` 및 `docs/mobile|product-analytics|performance|security`
- `design-system-agent` (FE는 일반 구현 역할만)

## 미확정

| 항목 | 비고 |
|------|------|
| 원격 DB/호스팅 | `working-principles` DB 절 |
| 첫 소비자 제품 레포 | Gate 3 소비 증거 |

체크리스트: [`company-kit-checklist.md`](company-kit-checklist.md)
