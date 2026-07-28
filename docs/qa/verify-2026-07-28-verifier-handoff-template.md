# verify-2026-07-28-verifier-handoff-template

- **date:** 2026-07-28
- **verifier:** qa-agent (생성·검증 분리) — 채팅 본문만; 디스크 저장은 메인
- **rubricRef:** Debate 강화 2번 — Verifier Handoff 고정 블록(허용 키·거부 목록) SSOT=`docs/agent/agent-brief.md` 9절. qa-agent·verify-change는 필드 목록 미확장·9절 참조. 복붙용 고정 블록·거부 키·오염 시 MAJOR. sync 정합.
- **forbidden 준수:** 산출물 미수정; 칭찬·완화·단정 없음; 생성 대화·reasoning 미사용

## 판정

| 등급 | 건수 | 비고 |
|------|------|------|
| BLOCKER | 0 | — |
| MAJOR | 0 | — |
| MINOR | 0 | 초검 m1(`rubricRef` 필수/생략 표기) → 「권장† + 택1 루브릭」으로 해소 |

**Gate 3 완료 선언(본 변경):** BLOCKER 0.

## checkedItems

`checkedItems: 8/8`

| ID | 항목 | 결과 |
|----|------|------|
| C1 | `agent-brief.md` 9절이 Verifier Handoff **필드 SSOT**로 명시 | 충족 |
| C2 | 허용 키 표·복붙 고정 블록 키가 동일 집합 | 충족 |
| C3 | 거부 목록 + 오염 시 무시·**MAJOR** 기록 가능 | 충족 |
| C4 | `qa-agent`가 9절을 가리키고 화이트리스트 미확장 | 충족 |
| C5 | `verify-change`가 9절을 가리키고 허용 키 동일 집합 | 충족 |
| C6 | example §5·dogfood·enforcement-matrix가 9절을 가리킴 | 충족 |
| C7 | sync: shared ≡ `.cursor` agents/skills | 충족 |
| C8 | 인코딩·harness(해당 시) | 충족 |

`uncheckedIds: []`

## BLOCKER / MAJOR

(없음)

## MINOR

(없음 — 초검 m1 해소)

- **였던 문제:** 표에 `rubricRef` **필수**와 †「미지정 시 기본 루브릭」공존.
- **조치:** 필수를 **권장†**로 바꾸고, 충족 수단을 `rubricRef` \| `rubric` \| 기본 완료 루브릭(택1)으로 단일화.

## artifactPaths (확인)

- docs/agent/agent-brief.md
- shared/agents/qa-agent.md
- shared/skills/verify-change/SKILL.md
- shared/skills/start-feature/SKILL.md
- docs/qa/dogfood-generate-verify-separation.md
- docs/agent/enforcement-matrix.md
- docs/qa/atdd-lite-consumption-record-example.md
- .cursor/agents/qa-agent.md
- .cursor/skills/verify-change/SKILL.md
