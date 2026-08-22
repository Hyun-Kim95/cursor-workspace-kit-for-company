---
name: start-feature
description: Gate 1 확인 후 구현·검증·문서화; 필요 시 parallel-delivery로 병렬 구현을 연결한다.
---

# start-feature

## 목적
신규 기능 요청을 안정적으로 구현하기 위한 기본 플로우.

## 절차
1. `.cursor/rules/60-delivery-gates.mdc` Gate 1을 점검한다. 미충족이면 `plan-feature` 또는 `prd-agent`로 돌아간다.
2. 요청을 기능 단위로 분해한다.
3. UI+API가 모두 필요하고 Gate 2를 충족했다면 `parallel-delivery`를 우선 고려한다.
4. **ATDD-lite:** Gate 2 충족 **후**·구현 **전** PRD AC 기준 acceptance test **RED**. [`docs/qa/atdd-lite.md`](../../../docs/qa/atdd-lite.md)
5. UI는 `frontend-agent`, API/DB/서비스는 `backend-agent`를 사용한다. 분담·Task는 `working-principles` **분담 임계치**를 따른다.
6. **생성·검증 분리:** [`verify-change`](../verify-change/SKILL.md) → `qa-agent` → Gate 3.
7. `document-change` 또는 `docs-agent`로 변경 정리.
8. kit·공유 패키지 범위는 [`docs/qa/integration-consumption-gate.md`](../../../docs/qa/integration-consumption-gate.md) **소비 증거** 확인.

## 결과물
- 구현 코드
- acceptance test (RED→GREEN, 해당 범위)
- `docs/qa/verify-*.md` (BLOCKER 0)
- 변경 문서(권장)

## 예외
- `AGENTS.md` **직접 처리 가능한 예외**는 Gate·검증 생략 가능.
