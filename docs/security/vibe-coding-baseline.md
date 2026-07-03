---
type: doc
project: cursor-workspace-kit
doc_lane: security
updated_at: 2026-07-03T00:00:00
tags: [docs, security, baseline, vibe-coding, vault-sync]
---

# vibe-coding-baseline — 라이트 보안 (권장)

AI·1인 빌더가 자주 놓치는 보안 실수를 **보안 게이트 opt-in 전**에도 챙기기 위한 최소 기준이다.

## 적용 범위

- PRD **보안 게이트=아니오·미명시** 제품에 **권장**.
- [`24-security-gate`](../../shared/optional/24-security-gate.mdc) 6축·`security:ci`·`security-last.json`의 **대체가 아님**.
- 엄격 보안이 필요하면 [`README.md`](README.md) 결정 트리 2~4로 업그레이드한다.

## 5항 베이스라인

| # | 항목 | 요지 |
|---|------|------|
| 1 | **BaaS 접근 통제** | 사용자 데이터 테이블에 RLS(또는 동등 잠금) ON + 정책 검토. BaaS 사용 시 [`baas-checklist.md`](baas-checklist.md) |
| 2 | **시크릿 분리** | API·LLM 키는 `.env` + `.gitignore`. 프론트 번들·공개 repo에 노출 금지. LLM은 서버/엣지 프록시 경유 |
| 3 | **서버 인증·인가** | UI 버튼만으로 관리자 기능 보호 금지. 모든 민감 API는 서버에서 인증·권한 검사(401/403) |
| 4 | **요청·비용 제한** | 공개·LLM 중계 API에 rate limit. LLM은 콘솔 **월 지출 한도** 설정 |
| 5 | **입력 검증** | SQL/NoSQL은 문자열 연결 대신 SDK·ORM·파라미터화. 외부 입력·스크래핑은 프롬프트 인젝션 가정 |

## Gate 연결 (권장, 필수 아님)

| Gate | 권장 조치 |
|------|-----------|
| **Gate 1** | PRD 「비기능·보안(라이트)」에 5항 요약 1줄 또는 Gate 1 점검 메모. BaaS/LLM 사용 시 하위 체크리스트 명시 |
| **Gate 2** | AC에 401·IDOR(403/404) 포함. [`acceptance-criteria.template.md`](../qa/acceptance-criteria.template.md) AC-02·AC-05·AC-06 참고 |
| **Gate 3** | `verify-change` baseline spot check. 보안 게이트=예이면 [`strict-axis-checklist.md`](strict-axis-checklist.md) 병행 |

## 배포 전 3항 (권장)

- [ ] **비로그인 스모크:** 로그인 없이 민감 데이터 API·BaaS REST 경로를 1회 호출 — 데이터가 그대로 오면 차단
- [ ] **키 노출:** 프론트 번들·공개 저장소에 LLM 키·`service_role`/admin 키 없음
- [ ] **(BaaS)** 이번 릴리스에 추가·변경한 테이블·Storage 버킷 RLS·정책 확인

## 사고 대응 순서 (권장)

1. 노출된 키·토큰 **즉시 로테이션**, 문제 기능·엔드포인트 차단
2. 어떤 데이터가 얼마나 새었는지 **범위 파악**
3. 원인 수정 + 동일 허점이 다른 경로에 없는지 **전수 점검**

시크릿 로테이션 절차: [`release-checklist.md`](release-checklist.md) · [`strict-axis-checklist.md`](strict-axis-checklist.md) F1.

## 하위 문서

| 사용 시 | 문서 |
|---------|------|
| Supabase·Firebase 등 BaaS | [`baas-checklist.md`](baas-checklist.md) |
| LLM API·AI 에이전트 | [`llm-and-agents.md`](llm-and-agents.md) |

## 관련 kit

- 스킬: `plan-feature`(6e), `start-feature`, `verify-change`(4e), `release-check`
- 엄격 보안: [`README.md`](README.md) · [`policy-and-contract.md`](policy-and-contract.md)
- harness dev/prod: [`harness-layer1.md`](../agent/harness-layer1.md)
