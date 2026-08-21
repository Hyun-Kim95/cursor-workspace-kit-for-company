# 회사 킷 프로파일

이 레포(`cursor-workspace-kit-for-company`)의 **고정된 전제**다. 정책 변경 시 본 파일과 관련 SSOT를 함께 갱신한다.

## 확정 (HUMAN)

| 항목 | 값 | 일자 |
|------|-----|------|
| 형태 | **A** — 회사 전용 킷 레포 (제품은 submodule로 소비) | 2026-08-20 |
| 주 용도 | **사내 제품만** (고객사 납품 E2E 기본 아님) | 2026-08-20 |
| Git remote | https://github.com/Hyun-Kim95/cursor-workspace-kit-for-company.git | 2026-08-21 |

## 파생 정책

| 영역 | 회사 킷 기본 | SSOT |
|------|--------------|------|
| 고객 E2E (`70` / `client-project-lifecycle`) | **opt-in만** (명시 요청 시에만) | `project-kit/.cursor/rules/70-client-lifecycle-default.mdc` |
| Gate 1~3 | **유지** (사내 제품도 Gate·ATDD-lite) | `60-delivery-gates.mdc` |
| 수익·사업자 | **회사(법인) 전제**, 광고·후원 비기본 | `shared/rules/product-monetization-default.mdc` |
| DB·배포 | 로컬 PostgreSQL 시작, **원격은 회사 인프라**(미확정) | `working-principles.mdc` DB 절 |

## 미확정 (HUMAN 필요)

| 항목 | 상태 | 비고 |
|------|------|------|
| 원격 DB/호스팅 (AWS/GCP/Azure/사내 등) | 미확정 | Railway 기본값 제거됨 |
| 보안 게이트 상시 on 여부 | 미확정 | 필요 시 `24-security-gate` + `docs/security/` |
| 첫 소비자 제품 레포 경로 | 미확정 | Gate 3 소비 증거용 |

상세 실행 목록: [`company-kit-checklist.md`](company-kit-checklist.md)
