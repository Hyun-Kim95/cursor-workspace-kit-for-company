# verify-2026-07-28-completion-verify-artifact

- **date:** 2026-07-28
- **verifier:** qa-agent (생성·검증 분리) → 메인 저장
- **rubricRef:** Gate 3 생성·검증 분리 — `docs/qa/verify-*.md` + BLOCKER 0 완료 선언 필수화; SSOT=`verify-change` 독립 검증 계약 + `60-delivery-gates` Gate 3; 직접 처리 예외 생략 가능; sync 정합; 훅 경고만
- **forbidden 준수:** 검증기 산출물 미수정; 메인이 본 파일만 저장·M1/m1/m2 후속 수정 반영

## 판정

| 등급 | 건수 | 비고 |
|------|------|------|
| BLOCKER | 0 | — |
| MAJOR | 0 | 초검 M1(훅 repo root) → 디스크 존재 검사 제거·텍스트 인용만으로 해소 |
| MINOR | 0 | 초검 m1(절차 번호)·m2(저장 주체) → dogfood·qa-agent 문구로 해소 |

**Gate 3 완료 선언(본 변경):** BLOCKER 0.

## checkedItems

`checkedItems: 5/5`

| ID | 항목 | 결과 |
|----|------|------|
| C1 | Gate 3 / verify-change / AGENTS에 verify 파일+BLOCKER 0 완료 금지 문구 | 충족 |
| C2 | start-feature·parallel-delivery·qa-agent·lifecycle·brief·enforcement-matrix·dogfood가 동일 계약 가리킴 | 충족 |
| C3 | guard-completion-claims verify 증빙 **텍스트** 경고(디스크 stale 묵음 없음) | 충족(수정 후) |
| C4 | `.cursor` sync 사본에 Gate 3·완료 선언 증거 문구 반영 | 충족 |
| C5 | 중복 SSOT 충돌·모순 문장 없음 | 충족(수정 후) |

`uncheckedIds: []`

## BLOCKER

(없음)

## MAJOR

(없음 — 초검 M1 해소)

### 초검 M1 (해소됨)

- **였던 문제:** `.cursor/hooks`에서 `..` → `.cursor`로 잘못 resolve, `docs/qa` 미탐지. 형제 훅은 `../..`.
- **조치:** 디스크 `verify-*.md` 존재로 증빙 간주하는 분기 **삭제**. 완료 페이로드에 `docs/qa/verify` / `blocker 0` / `qa-agent` 등 **텍스트 인용만** 인정(stale 파일 묵음 방지).

## MINOR

(없음 — 초검 m1·m2 해소)

- **m1:** dogfood `절차 8` → `절차 9`로 정정.
- **m2:** `qa-agent.md`에 「디스크 기록은 메인; 검증기는 채팅 본문만」명시.

## C1~C2 근거 (요약)

- `project-kit/.cursor/rules/60-delivery-gates.mdc` Gate 3: verify 파일 + BLOCKER 0
- `shared/skills/verify-change/SKILL.md` **완료 선언 증거(필수)**
- `AGENTS.md` 게이트/병렬/완료 기준 + 기본 진입 생성·검증 분리
- start-feature / parallel-delivery / lifecycle / brief / enforcement-matrix / dogfood / README 동일 계약

## 훅 동작 (수정 후)

- 완료 시그널 감지 시 DoD 증빙(기존) + verify 텍스트 시그널 없으면 경고
- 차단 없음(`exit 0`)
- 디스크 파일 존재로 경고 억제하지 않음

## artifactPaths

- project-kit/.cursor/rules/60-delivery-gates.mdc
- shared/skills/verify-change|start-feature|parallel-delivery/SKILL.md
- shared/agents/qa-agent.md
- AGENTS.md
- docs/agent/agent-brief.md, enforcement-matrix.md
- docs/qa/dogfood-generate-verify-separation.md, README.md
- project-kit/.cursor/skills/client-project-lifecycle/SKILL.md
- .cursor/hooks/guard-completion-claims.ps1
- sync: .cursor/rules/60-delivery-gates.mdc, .cursor/skills/*, .cursor/agents/qa-agent.md
