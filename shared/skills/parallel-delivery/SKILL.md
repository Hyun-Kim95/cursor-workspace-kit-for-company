---
name: parallel-delivery
description: Gate 2 이후 프론트·백엔드 병렬 구현, 통합, 검증, 문서화까지 진행한다.
---

# parallel-delivery

## 목적
API 계약이 확정된 뒤 UI와 서버 작업을 병렬로 진행한다.

## 사용 시점
- Gate 2 충족 후
- `frontend-agent` + `backend-agent` 동시 착수

## 전제
- PRD 또는 동등 범위 문서
- **확정 API 계약:** 스키마, 인증·권한, 오류 포맷·상태 코드
- PRD **AC** 목록 ([`docs/qa/atdd-lite.md`](../../../docs/qa/atdd-lite.md))

## 절차
1. 계약을 단일 기준으로 고정. 변경 시 `document-change`.
2. **ATDD RED:** FE(E2E)·BE(API) acceptance test 스켈레톤 병렬 작성.
3. **제품 구현(GREEN)** 병렬.
4. 통합·계약 일치 확인.
5. `verify-change` + `qa-agent` → Gate 3.
6. 변경 요약 문서화.

## 결과물
- FE/BE 통합 구현
- acceptance test 통과
- `docs/qa/verify-*.md` (BLOCKER 0)

## 예외
- 계약 흔들림 → 병렬 중단, `plan-feature`/`prd-agent`로 재고정.
