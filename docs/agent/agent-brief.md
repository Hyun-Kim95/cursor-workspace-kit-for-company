# Agent Brief Template

## 0) Metadata (갱신 시 함께 수정)
- **Revision:** (예: v1, v2 또는 날짜)
- **Last updated:** (YYYY-MM-DD)
- **Owner:** (담당 또는 역할)
- **lifecyclePhase:** `mock` (단계 2·비교 목업) \| `implement` (디자인 선택 후·Gate 2+ 제품 구현)
- **Decisions this revision:** (이번 리비전에서 확정된 결약·결정을 3줄 이내로)

## 1) Goal
- 작업 목표를 한 문장으로 명확히 정의한다.

## 2) Scope
- 포함 범위:
  - 이번 작업에서 반드시 처리할 항목
- 비포함 범위:
  - 이번 작업에서 제외할 항목

## 3) Policies And Constraints
- 적용해야 할 규칙/정책
- 보안/권한/데이터 제약
- 성능/호환성/플랫폼 제약

## 4) Inputs
- 참고 문서 경로 (PRD, `docs/qa/atdd-lite.md`, stage3 체크리스트 등)
- **PRD 수용 기준:** `AC-xx` 목록 또는 `docs/requirements/...` AC 섹션 경로
- **선택안 링크/ID**(디자인 HUMAN 선택 후) + **제품 구현 경로**(라우트·모듈)
- 참고 코드/디자인 경로(목업은 스펙 근거만; `implement` 단계에서 mock-only만 다시 만들지 않음)
- **ATDD-lite (Gate 2+):** acceptance test 경로(RED 상태 또는 GREEN 목표), AC ID ↔ 테스트 매핑 메모
- 선행 조건(있다면): stage3 체크리스트, Gate 2, **RED 확인 기록**

## 5) Expected Outputs
- 산출물 파일/모듈 (코드 변경 경로 또는 `docs/` SSOT md)
- **ATDD-lite:** acceptance test 경로(RED→GREEN), AC ID ↔ 테스트 매핑
- **독립 검증 산출:** `docs/qa/verify-{날짜 또는 slug}.md` (`qa-agent` 채점·이슈 목록)
- 검증 결과(테스트/체크리스트)
- 사용자 전달용 요약

## 6) Done Criteria
- 기능/요구사항 충족 기준
- 상태 처리 기준(기본/로딩/빈/오류/권한)
- 회귀 위험 점검 기준
- **생성·검증 분리:** `qa-agent` **BLOCKER 0**, 불합격 항목 0 (판정은 메인이 재해석하지 않음). 증거 파일: `docs/qa/verify-{날짜 또는 slug}.md` (경로를 완료 보고에 인용)

## 7) Open Questions
- 현재 확정되지 않은 사항
- 작업 전에 확인이 필요한 의사결정

미결정이 스택·구조·도메인 등 **되돌리기 비싼 선택**에 닿으면, 여기에 **후보 옵션 2~3개**와 **추천 1개**(각 옵션 장단점 한 줄씩)를 적어 둔다. 사용자가 확정하면 **0) Metadata**의 `Decisions this revision`에 반영하고, Open Questions에서 해당 항목을 정리한다.

## 8) Handoff Notes
- 다음 담당자에게 전달할 핵심 변경점
- 알려진 제한/리스크

## 9) Verifier Handoff (생성·검증 분리)

메인이 산출을 마친 뒤 `qa-agent`에 넘길 때 **아래 고정 블록만** 전달한다. 생성 대화·작성 reasoning·구현 변명은 포함하지 않는다.  
**필드 SSOT:** 본 절. `qa-agent`·`verify-change`는 본 절을 가리킨다(필드 목록을 늘리지 않음).

### 허용 필드 (이 키만)

| 필드 | 필수 | 내용 |
|------|------|------|
| `artifactPaths` | **필수** | 검증 대상 파일·모듈 경로 목록 |
| `rubricRef` | 권장† | Gate 3, `docs/qa/atdd-lite.md`, `docs/qa/reviewer-gate-rubric.md`, 작업별 체크리스트 경로 또는 한 줄 요약 |
| `forbidden` | **필수** | 금지 조건. 최소: 산출물 수정 / 칭찬·완화 / 생성 맥락·reasoning 참조 |
| `acceptanceTestPaths` | ATDD 시 | acceptance test 경로 목록. 해당 없으면 키 생략 또는 `[]` |
| `acIds` | ATDD 시 | PRD AC ID 목록. 해당 없으면 키 생략 또는 `[]` |

† 루브릭 충족 수단(택1): `rubricRef` **또는** 인라인 `rubric` **또는** 둘 다 없을 때 검증기 **기본 완료 루브릭**. 경로·ID가 있으면 `rubricRef`를 우선한다.

### 고정 블록 (복붙용)

Task/`qa-agent` 프롬프트에는 **이 형태만** 넣는다. 위아래 서론·변명·대화 요약 금지.

```markdown
## Verifier Handoff
- artifactPaths:
  - <path>
  - <path>
- acceptanceTestPaths: []
- acIds: []
- rubricRef: <Gate 3 | 체크리스트 경로 | 한 줄>
- forbidden:
  - 산출물 생성·수정
  - 칭찬·완화·단정
  - 생성 대화·reasoning·구현 의도 참조
```

동일 키만 담은 JSON도 허용한다(예: [`docs/qa/atdd-lite-consumption-record-example.md`](../qa/atdd-lite-consumption-record-example.md) §5).

### 거부 (넣으면 절차 위반 — 검증기는 무시·MAJOR로 기록 가능)

- 생성 대화 요약, 메인 reasoning, 「왜 이렇게 구현했는지」해설
- 예상 합격 유도·판정 초안·“거의 완료” 서술
- brief **1)~8)** 전문, PRD/디자인 장문 재첨부(경로로 `artifactPaths`/`rubricRef`에만)
- 허용 표에 없는 임의 키(`context`, `notes`, `summary`, `implementationNotes` 등)

### 검증기 출력 (메인이 디스크에 저장)

| 항목 | 내용 |
|------|------|
| 산출 경로 | `docs/qa/verify-{날짜 또는 slug}.md` |
| Gate 3 | 메인이 완료 선언 전 **BLOCKER 0** 확인·경로 인용 |

**코드 예:** `artifactPaths` = 변경 파일 + `rubricRef` = Gate 3·상태 UI  
**문서 예:** `artifactPaths` = `docs/requirements/...` + `rubricRef` = 체크리스트(항목별 0점 가능)
