---
type: doc
project: cursor-workspace-kit
doc_lane: qa
updated_at: 2026-07-23
tags: [docs, atdd, prd, template]
---

# Acceptance Criteria Template (PRD 붙여넣기용)

PRD 또는 동등 범위 문서에 아래 섹션을 복사해 사용한다. 상세: [`atdd-lite.md`](atdd-lite.md)

## 수용 기준 (Acceptance Criteria)

| ID | 시나리오 | 대상 | 상태 | 자동/수동 | 의도(왜) | 비고 |
|----|----------|------|------|-----------|----------|------|
| AC-01 | Given 비로그인 사용자 When `/login`에서 유효 자격 증명 제출 Then `/dashboard`로 이동 | 화면 | 기본 | auto | 로그인 성공 후 진입점 보장 | E2E |
| AC-02 | Given 인증 헤더 없음 When `GET /api/items` Then `401` + 오류 본문 형식 계약 준수 | API | 오류 | auto | 비인증 데이터 노출 방지 | |
| AC-03 | Given 목록 API 빈 배열 When 목록 화면 로드 Then 빈 상태 UI 문구 표시 | 화면 | 빈 | auto | 빈 결과를 오류로 오인하지 않게 | |
| AC-04 | Given 권한 없는 역할 When 관리 메뉴 접근 Then 권한 제한 UI | 화면 | 권한 | manual | 권한 우회·혼란 방지 | 스테이징 수동 1회 |
| AC-05 | Given 사용자 A 로그인 When 사용자 B의 `resource_id`로 `GET /api/...` Then `403` 또는 `404` | API | 권한 | auto | IDOR로 타인 자원 접근 차단 | IDOR |
| AC-06 | Given 비로그인 When 민감 데이터 API 직접 호출 Then `401` 또는 거부(BaaS면 RLS 거부) | API | 권한 | auto | 민감 API 직접 호출 차단 | baseline·BaaS |

### 작성 규칙

- ID는 `AC-01`부터 연속 번호.
- **행위·계약·상태**만 시나리오에 기술 (픽셀·색상·간격 금지).
- **의도(왜):** 이 AC가 보호하는 사용자·사업 가치, 또는 **실패 시 피해**를 한 줄로 적는다. 테스트가 “무엇을 통과하는지”가 아니라 “왜 필요한지”를 추적한다.
- `auto`: Gate 2 후 acceptance test RED → Gate 3 GREEN 필수.
- `manual`: PRD에 `manual` 표기 + `docs/qa/` 실행 기록.

### AC ↔ 테스트 매핑 (Gate 2 직후 작성)

| AC ID | 테스트 파일·describe/it | RED 확인 |
|-------|-------------------------|----------|
| AC-01 | `e2e/login.spec.ts` — `AC-01 logged-in user sees dashboard` | 실패 확인 |
| AC-02 | `tests/api/items.test.ts` — `AC-02` | 실패 확인 |
| AC-05 | `tests/api/resource.test.ts` — `AC-05 IDOR denied` | 실패 확인 |
| AC-06 | `tests/api/sensitive.test.ts` — `AC-06 unauthenticated denied` | 실패 확인 |

## Vault

- [[cursor-workspace-kit/docs/cursor-workspace-kit-docs-hub|Hub]]
