# Dogfood: 생성·검증 분리 kit 반영

## 목적

메인 에이전트가 산출(코드·문서)을 하고, 검증은 `qa-agent`에 파일·루브릭만 넘기는 **생성·검증 분리** 흐름을 kit에 반영했다.

## 변경 SSOT

| 경로 | 변경 요약 |
|------|-----------|
| `shared/skills/start-feature/SKILL.md` | `## 생성·검증 분리` 절, 절차 9 정렬; verify 산출 Gate 3 필수 |
| `shared/skills/verify-change/SKILL.md` | `## 독립 검증 계약`, **완료 선언 증거**(verify 파일+BLOCKER 0) |
| `shared/agents/qa-agent.md` | `## 독립 검증기 계약`; 산출 저장 필수 |
| `docs/agent/agent-brief.md` | Done Criteria, `## 9) Verifier Handoff` **고정 블록·허용/거부 필드** |
| `AGENTS.md` | 기본 진입 + Gate 3 verify/BLOCKER 0 완료 선언 금지 |
| `project-kit/.cursor/rules/60-delivery-gates.mdc` | Gate 3 생성·검증 분리 증거 항 |
| `shared/skills/bugfix-flow/SKILL.md` | cross-reference 1줄 |
| `shared/skills/parallel-delivery/SKILL.md` | 절차 5 verify·BLOCKER 0 |
| `project-kit/.cursor/skills/client-project-lifecycle/SKILL.md` | 단계 4 verify 산출 |
| `shared/skills/release-check/SKILL.md` | 절차 6 cross-reference |
| `.cursor/hooks/guard-completion-claims.ps1` | verify 증빙 경고(경고만) |
| `docs/qa/delivery-loop-state.example.json` · `delivery-loop-harness.md` · `guard-delivery-loop.ps1` | `maxVerifyRounds`(기본 3)·HUMAN·훅 경고 |

## 핵심 계약

1. 메인 **self-verify 금지**
2. `qa-agent` 입력: [`agent-brief.md`](../agent/agent-brief.md) **9) 고정 블록**만 (`artifactPaths` + `rubricRef` + `forbidden` + ATDD 시 경로/AC). 거부 목록 준수
3. 체크리스트: `checkedItems N/M`, `uncheckedIds` 보고
4. **완료 선언 증거:** `docs/qa/verify-*.md` 저장 + **BLOCKER 0** (Gate 3 / `AGENTS.md`; 직접 처리 예외는 생략). 훅 [`guard-completion-claims.ps1`](../../.cursor/hooks/guard-completion-claims.ps1)는 경고만.
5. **verify round 상한:** 기본 `maxVerifyRounds: 3` + 초과 시 HUMAN ([`delivery-loop-harness.md`](../agent/delivery-loop-harness.md); Debate 강화 3번)

## 미확정

- verify 산출 부재·verify round 초과 시 훅 **차단(fail-closed)** 모드 — 현재는 경고만. 팀 합의 후 검토.
- cross-check(다중 모델 Debate, 강화 4번) — 요청 시에만.
