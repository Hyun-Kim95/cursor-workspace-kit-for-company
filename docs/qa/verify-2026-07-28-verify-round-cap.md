# verify-2026-07-28-verify-round-cap

- **date:** 2026-07-28
- **verifier:** qa-agent (생성·검증 분리) → 메인 저장·MAJOR 수정 반영
- **rubricRef:** Debate 강화 3번 — verifyRound/maxVerifyRounds(기본 3)·초과 시 HUMAN(verifyRoundExceededHuman). iteration/maxIterations와 구분. 훅은 경고만.
- **forbidden 준수:** 검증기 산출 미수정; 메인이 M1/M2/m1 정합 수정 후 본 파일 저장

## 판정

| 등급 | 건수 | 비고 |
|------|------|------|
| BLOCKER | 0 | — |
| MAJOR | 0 | 초검 M1·M2 해소 |
| MINOR | 0 | 초검 m1 해소 |

**Gate 3 완료 선언(본 변경):** BLOCKER 0.

## checkedItems

`checkedItems: 10/10`

| ID | 항목 | 결과 |
|----|------|------|
| C1 | example JSON 필드·iteration 공존 | 충족 |
| C2 | harness 카운터 구분·기본 3·HUMAN | 충족(수정 후) |
| C3 | lifecycle 4C 상한+BLOCKER→HUMAN | 충족 |
| C4 | verify-change 동일 계약·maxIterations 혼동 금지 | 충족 |
| C5 | qa-agent 4C HUMAN 필요 | 충족 |
| C6 | guard-delivery-loop 경고·exit 0 | 충족 |
| C7 | dogfood·enforcement-matrix 반영 | 충족 |
| C8 | sync 정합 | 충족 |
| C9 | HUMAN 발동 조건 산출물 간 동일 | 충족(수정 후) |
| C10 | 훅=경고만 / 에이전트=정책 분리 | 충족(수정 후) |

`uncheckedIds: []`

## BLOCKER / MAJOR / MINOR

(없음)

### 초검 해소

| ID | 조치 |
|----|------|
| M1 | HUMAN = `verifyRound >= max` **그리고** BLOCKER 잔존(에이전트). 훅은 완료 신호+상한+!HUMAN 경고만(BLOCKER 미파싱). harness·verify-change·4C·훅 메시지 정렬. |
| M2 | harness에서 훅을 “진행 금지” 주체에서 분리 → 경고만 / 에이전트 정책만. |
| m1 | `verifyRound`+1은 메인 의무(ralph 유무 무관; ralph면 JSON 반영). |

## 계약 요약 (SSOT 포인터)

- 필드·절차: [`docs/agent/delivery-loop-harness.md`](../agent/delivery-loop-harness.md)
- 예제 JSON: [`docs/qa/delivery-loop-state.example.json`](delivery-loop-state.example.json)
- 스킬: `verify-change` · lifecycle 4C · `qa-agent` 4C
- 훅: `.cursor/hooks/guard-delivery-loop.ps1` (경고만)
