---
name: verify-change
description: 구현 결과를 요구사항, 상태 처리, 회귀 위험 기준으로 검증한다.
---

# verify-change

## 목적
구현이 끝난 변경사항을 품질 관점에서 점검한다.

## 왜 이 점검인가 (짧게)
- **Gate 3 / AC 매핑:** 요구·테스트와 일치 여부를 분리해 확인한다.
- **회귀:** 인접 기능 피해를 잡기 위함이다.
- **생성·검증 분리:** `qa-agent` 판정을 인용만 한다.
- **harness `quality-gate-last`:** `ok: false`이면 완료 선언 금지.

## 사용 시점
- 기능 구현 직후
- 버그 수정 직후
- PR 전 점검 (생성·검증 분리: `qa-agent` 독립 검증 후 본 스킬로 Gate 3 마무리)
- 사용자 전달 전 점검

## 절차
1. `.cursor/rules/60-delivery-gates.mdc` Gate 3(DoD) 관점에서 완료 조건을 충족하는지 확인한다.
2. 요구사항 대비 구현 누락이 없는지 확인한다.
2b. **ATDD-lite:** PRD AC↔acceptance test 매핑, 자동화 AC **통과**, 미매핑·미커버 AC 목록. 수동 AC는 `manual` + `docs/qa/` 실행 기록. [`docs/qa/atdd-lite.md`](../../../docs/qa/atdd-lite.md).
2c. **외부 URL 근거:** Notion·공개 URL을 스펙 근거로 쓰면 WebFetch 등으로 fetch하고, 실패 시 추측하지 않는다.
3. 기존 기능에 영향이 없는지 회귀 위험을 확인한다.
4. `shared/` SSOT 수정 시 `scripts/sync-kit.ps1` 실행 결과를 보고에 한 줄 남긴다.
5. `.cursor/state/quality-gate-last.json`이 있으면 `ok`가 `true`인지 확인한다.
6. UTF-8·한글 깨짐 여부를 확인한다.
7. **생성·검증 분리** 시 `qa-agent` **필수** ([`agent-brief.md`](../../../docs/agent/agent-brief.md) 9절).
8. 수정이 필요하면 적절한 Skill/Agent로 되돌린다.

(2c, 4~6: [`rule-candidates.md`](../../../docs/agent/rule-candidates.md) 참고.)

## 독립 검증 계약

생성(메인·구현 에이전트)과 검증(`qa-agent`)의 맥락을 분리해 self-bias·조기 완료를 줄인다. **생성·검증 분리의 SSOT는 본 절**이다. 상세 handoff: [`docs/agent/agent-brief.md`](../../../docs/agent/agent-brief.md) **9) Verifier Handoff**.

### 공통

- 검증 입력: [`agent-brief.md`](../../../docs/agent/agent-brief.md) **9) 고정 블록**만. 허용 키 = `artifactPaths` + `rubricRef`/`rubric` + `forbidden` (+ ATDD 시 `acceptanceTestPaths`·`acIds`). 생성 대화·메인 reasoning·임의 키 금지.
- 메인은 Task 프롬프트에 **고정 블록을 복붙**한다. 서론·구현 변명을 붙이면 절차 위반(검증기는 무시·MAJOR 가능).
- 메인은 `qa-agent` **판정만** 보고에 인용한다. 자체 재해석·완화 금지.
- 체크리스트 작업: `checkedItems: N/M`, `uncheckedIds: [...]`를 필수 보고. 미완이 있으면 완료 선언 금지.
- handoff에 `rubric`/`rubricRef`를 줄 때, 명시가 없으면 `qa-agent` **기본 완료 루브릭**(「여전히/아직/다시 확인」 항목)을 포함한다.
- **완료 선언 증거(필수):** 생성·검증 분리가 적용되는 범위에서는 `qa-agent` 산출을 `docs/qa/verify-{날짜 또는 slug}.md`에 **저장**하고, 그 파일에서 **BLOCKER 0**을 확인한 뒤에만 완료·검증 완료·Gate 3 충족을 선언한다. 보고에 **verify 경로**와 BLOCKER 수를 인용한다. (`AGENTS.md` **직접 처리 가능한 예외**·단일 파일 소규모 수정은 생략 가능.)
- **verify round 상한:** 구현↔`qa-agent` 왕복은 기본 `maxVerifyRounds: 3` ([`docs/agent/delivery-loop-harness.md`](../../../docs/agent/delivery-loop-harness.md)). BLOCKER가 남아 재수정할 때마다 `verifyRound`+1(ralph 사용 시 JSON 반영). **`verifyRound >= maxVerifyRounds` 이고 BLOCKER 잔존**이면 추가 라운드 전 **HUMAN**(범위 축소·상한 상향·중단). 테스트 러너 `maxIterations`와 혼동하지 않는다. 훅은 완료 신호 시 상한·!HUMAN이면 **경고만**.

### 코드 검증

- Gate 3(DoD), 상태 UI(기본/로딩/빈/오류/권한), 회귀, harness(`quality-gate-last`, `security-last`, `perf-last`)는 위 **절차 1~11**을 따른다.

### 문서·기획 검증

- 관점·체크리스트·**원문 인용**으로 약점을 적는다. 항목별 **0점 가능** 루브릭(`docs/qa/reviewer-gate-rubric.md` 또는 작업별 체크리스트)을 사용한다.
- 출력: `BLOCKER` / `MAJOR` / `MINOR` 또는 채점표. 산출 저장: `docs/qa/verify-{날짜 또는 slug}.md` (**필수**, 위 **완료 선언 증거**)

## 결과물
- `docs/qa/verify-{날짜 또는 slug}.md` (BLOCKER/MAJOR/MINOR·근거)
- 검증 결과 요약(메인은 위 파일 인용)
- 발견된 이슈 목록
- 수정 필요 항목