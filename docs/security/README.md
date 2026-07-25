---
type: doc
project: cursor-workspace-kit
doc_lane: security
updated_at: 2026-07-25T00:00:00
tags: [docs, security, vault-sync]
---

# security — 진입점

비기능 **보안 게이트**(시크릿·의존성·정적분석·인증·전송·데이터)를 **PRD에서 보안 게이트=예(엄격)** 로 명시한 경우 여기서 시작한다.

## 결정 트리

1. **PRD에 보안 게이트=아니오(또는 미명시)?** → [`vibe-coding-baseline.md`](vibe-coding-baseline.md) **권장** (6축·`security:ci`·본 폴더 엄격 절차는 스킵. 기본 harness·`release-check` 민감정보 항목은 유지)
2. **신규 제품·보안 정책·스캔이 없음?** → [`greenfield-checklist.md`](greenfield-checklist.md)
3. **이미 일부 스캔·CI가 있음?** → [`brownfield-checklist.md`](brownfield-checklist.md)
4. **엄격(strict) 티어?** → [`strict-axis-checklist.md`](strict-axis-checklist.md) + 단계 4B 보안 축 **필수**
5. **제품 SSOT:** `docs/requirements/security-policy.json`(또는 팀 규칙 경로)에 [`security-policy.template.json`](security-policy.template.json)을 복사한 뒤 `tier`·`checks.*.enabled`를 채운다.
6. **측정:** 제품이 구현한 `npm run security:ci`(또는 동등) → `.cursor/state/security-last.json`(권장). kit 스텁: [`scripts/security/README.md`](../../scripts/security/README.md)

## 보안 축 (조합 가능)

| 축 | `checks` 키 | 대표 점검 (제품 도구) |
|----|-------------|------------------------|
| **secrets** | `secrets` | gitleaks, trufflehog |
| **dependencies** | `dependencies` | `npm audit`, pip-audit, Dependabot |
| **sast** | `sast` | Semgrep, CodeQL, ESLint security |
| **authz** | `authz` | 인증·권한·세션·IDOR 수동·자동 점검 |
| **transport** | `transport` | TLS, HSTS, CSP, CORS, 쿠키 플래그 |
| **data** | `data` | PII 분류·암호화·로그 마스킹·보존 |

비활성 축은 `security-last.json`에서 `skipped: true`로 둔다. **전체 `ok`** 는 **활성 축만 AND**. 엄격 티어는 **6축 모두 `enabled: true`** 가 기본.

## 문서 구성

| 파일 | 용도 |
|------|------|
| [`policy-and-contract.md`](policy-and-contract.md) | PRD 보안 절, `security-last` 계약, brownfield 매핑표 |
| [`security-policy.template.json`](security-policy.template.json) | 정책·활성 축 템플릿 (기본 `tier: strict`, 전 축 `enabled: false`) |
| [`greenfield-checklist.md`](greenfield-checklist.md) | 신규: NFR → policy → security:ci → 4B·릴리스 루프 |
| [`brownfield-checklist.md`](brownfield-checklist.md) | 기존: 인벤토리 → 갭 보완 |
| [`strict-axis-checklist.md`](strict-axis-checklist.md) | 엄격 4B 보안 축·OWASP 수동 점검 |
| [`release-checklist.md`](release-checklist.md) | 릴리스 3항 — `release-check` 스킬 참조 |
| [`vibe-coding-baseline.md`](vibe-coding-baseline.md) | 라이트 5항·배포 전 3항 (보안 게이트 미명시 **권장**) |
| [`baas-checklist.md`](baas-checklist.md) | Supabase 등 BaaS RLS·Storage·anon 스모크 |
| [`llm-and-agents.md`](llm-and-agents.md) | LLM 프록시·rate limit·에이전트·운영 DB 분리 |

## Harness 연동 (권장)

| 도구 | 용도 |
|------|------|
| [`harness-layer1.md`](../agent/harness-layer1.md) | `quality-gate` 짧은 스캔 vs 긴 `security:ci` 역할 분담 |
| [`delivery-loop-harness.md`](../agent/delivery-loop-harness.md) | `lifecyclePhase: verify` + `Invoke-DeliveryLoop.ps1`로 `security:ci` 반복 |
| [`project-kit/.cursor/quality-gate.security.example.json`](../../project-kit/.cursor/quality-gate.security.example.json) | quality-gate 보안 명령 예시 |
| [`docs/qa/security-last.example.json`](../qa/security-last.example.json) | 상태 파일 예시 |
| [`docs/qa/security-axis.template.md`](../qa/security-axis.template.md) | 단계 4B 산출 `security-axis-{날짜}.md` 템플릿 |

**완료 선언 권고:** 제품에 `security-last.json`이 있고 `ok: false`이면 검증·완료·출시 준비 선언을 하지 않는다 (`quality-gate-last`·`perf-last`와 동일 패턴, [`policy-and-contract.md`](policy-and-contract.md)).

## 참조 매핑 (배포 전 15항목 렌즈)

외부에서 쓰는 배포 전 15항목 표와 kit 검사 ID의 **참조용** 대응이다. **검사 SSOT는 [`strict-axis-checklist.md`](strict-axis-checklist.md)의 A~F ID**이며, 아래 표로 검사 절차를 대체하지 않는다.

| # | 렌즈 항목 | kit ID (SSOT) |
|---|-----------|---------------|
| 01 | CORS | D3 |
| 02 | CSRF | C3 |
| 03 | XSS + CSP | C2 · D2 |
| 04 | SSRF | C5 |
| 05 | AuthN/AuthZ | B1 · B4 · B5 |
| 06 | RBAC · 테넌트 | B2 (역할·테넌트) · BaaS RLS |
| 07 | 최소권한 | B2 · [`llm-and-agents.md`](llm-and-agents.md) |
| 08 | Input + SQLi | C1 |
| 09 | Rate Limit | F3 · vibe #4 |
| 10 | 쿠키 · 세션 | D4 · B4 |
| 11 | Secret · Rotation | A1 · F1 |
| 12 | HTTPS · 보안헤더 | D1 · D2 |
| 13 | Audit Log | F2 |
| 14 | 에러 노출 | C6 |
| 15 | 의존성 취약점 | A2 |

자동 스캔(A1~A3)은 제품 `security:ci` 구현이 필요하고, kit `Invoke-SecurityGate.ps1`은 계약 스텁이다.

## 관련 kit

- 선택 규칙: `shared/optional/24-security-gate.mdc` (보안 게이트=예 제품/팀만 opt-in)
- 인증·권한 설계: Gate 1·2 (`60-delivery-gates.mdc`) — 본 폴더와 중복 정의하지 않음
- PII·이벤트: `docs/product-analytics/` (측정=예일 때 병행)
- 실패·재시도: `shared/rules/working-principles.mdc` **조사·소통·실패 대응**
