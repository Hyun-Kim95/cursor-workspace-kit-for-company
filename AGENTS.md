# AGENTS

## 목적

이 프로젝트의 메인 에이전트는 요청을 분석하고, 적절한 Rules, Skills, Subagents를 선택해 작업을 진행한다.

이 파일은 총괄 오케스트레이션만 담당한다.
세부 정책은 `.cursor/rules/`( [`scripts/sync-kit.ps1`](scripts/sync-kit.ps1) 중 rules; SSOT는 `shared/rules/`, `project-kit/.cursor/rules/`), 작업 절차는 [`shared/skills/`](shared/skills/)(sync 후 `.cursor/skills/`), 역할별 전문 범위는 [`shared/agents/`](shared/agents/)(sync 후 `.cursor/agents/`)에서 관리한다.

## 정책 출처(SSOT)

- 실행 계획 형식, **라이트/풀** 선택, 분담 임계치·서브 타입 매핑·재계획: [`shared/rules/working-principles.mdc`](shared/rules/working-principles.mdc) **분담 임계치** 절(라이트/풀 포함)이 SSOT다.
- **직접 처리 가능한 예외**의 목록(아래 해당 섹션)은 **본 파일이 SSOT**다. 다른 규칙·스킬은 목록을 늘리지 않고 이 섹션을 가리킨다.

## 운영 원칙

- 공통 작업 원칙(계획/출력/커밋 안전/완료 보고)은 `shared/rules/working-principles.mdc`를 기본으로 적용한다.
- 이 파일은 오케스트레이션, 역할 분담, 우선순위, 직접 처리 예외 목록 같은 **프로젝트 로컬 SSOT**만 다룬다.
- `start-feature`·`plan-feature`·`parallel-delivery`·`verify-change`·`document-change`·`bugfix-flow`·`release-check` 등 공통 스킬은 `shared/skills/`(sync 후 `.cursor/skills/`)를 우선 사용한다.
- 게이트·병렬·DoD는 `.cursor/rules/60-delivery-gates.mdc`를 따른다. 회사 킷 프로파일: [`docs/agent/company-profile.md`](docs/agent/company-profile.md).
- UI+API 병렬은 Gate 2(API 계약 확정 + ATDD RED) 충족 후에만 허용한다.
- 같은 내용을 Rules, Skills, Agents 파일에 중복 정의하지 않는다.
- 규칙이 많을 때의 초점 맞추기·한 줄 요약은 `docs/agent/rules-context-notes.md`를 참고한다.
- 규칙·스킬·에이전트 파일을 고칠 때의 정합 점검은 `docs/agent/rules-maintenance-checklist.md`를 참고한다. SSOT·배포는 `docs/agent/kit-inventory.md`, `docs/agent/rules-deploy.md`, `docs/agent/skills-agents-deploy.md`를 본다.
- 텍스트 파일(문서·설정·소스)은 `shared/rules/encoding-utf8-global.mdc`와 `docs/agent/encoding.md`에 따라 **UTF-8(BOM 없음 기본)** 로 저장한다.

## 규칙 우선순위 (충돌 시)

1. 사용자가 대화에서 **명시한 지시**(범위·예외·긴급도 포함)
2. **안전·보안·민감정보** 보호(유출 방지, 권한, 비밀 커밋 방지 등)
3. `.cursor/rules/60-delivery-gates.mdc`의 **Gate** 조건
4. `shared/rules/working-principles.mdc`의 **실행 계획/출력 계약** 형식
5. 그 외 `.cursor/rules/`

**충돌 시 행동:** 우선순위를 스스로 판단하기 어렵거나 구현이 멈출 수 있으면, **구현을 잠시 멈추고** 짧은 **확인 질문 1~2개**를 먼저 한다.

## 역할 분담 기준

- UI·화면·마크업·클라이언트 상호작용: `frontend-agent`
- API, DB, 서비스, 인증, 권한, 파일 처리: `backend-agent`
- 요구사항 정리, 정책 설계, 기능 범위 정의: `prd-agent`
- 구현 결과 검증, 회귀 점검: `qa-agent`
- 작업 내역 정리, 변경사항 문서화: `docs-agent`

위 이름은 **역할·전문 범위**를 가리킨다. 실행 환경에 별도 서브에이전트 세션이 없을 수 있으며, 그 경우 **메인 에이전트가 동일 범위를 수행**한다.

## 재사용 최소 복사 세트

- `AGENTS.md`
- `project-kit/.cursor/rules/60-delivery-gates.mdc`
- `shared/rules/` (회사 킷: `working-principles`, `encoding-utf8-global`, `emergent-rule-capture-global`, `dev-server-cleanup-global` + 선택 `locale-ko`)

## 게이트/병렬/완료 기준

- Gate 1~3, ATDD-lite, 병렬 조건, DoD는 `.cursor/rules/60-delivery-gates.mdc`를 SSOT로 따른다.
- **횡단 자산**(kit·공유 패키지)은 생성과 소비를 분리한다. [`docs/qa/integration-consumption-gate.md`](docs/qa/integration-consumption-gate.md)
- `quality-gate-last.json`의 `ok: false`이면 완료·검증 완료 선언 금지. [`docs/agent/harness-layer1.md`](docs/agent/harness-layer1.md)
- Gate 3: `docs/qa/verify-*.md` + **BLOCKER 0** 없이 완료 선언 금지 ([`verify-change`](shared/skills/verify-change/SKILL.md))

## `/start-setting` · `/start`

- 온보딩: [`docs/agent/product-onboarding.md`](docs/agent/product-onboarding.md), 스킬 `start-setting`
- 매일 kit 갱신: `/start` · `/kit-start`, 스킬 `kit-start` — [`docs/agent/kit-start.md`](docs/agent/kit-start.md)

## 기본 진입 규칙

- 신규 기능: `plan-feature`(모호 시) → Gate 1 → `start-feature` (UI+API 병렬이면 Gate 2 → ATDD RED → `parallel-delivery`)
- 버그: `bugfix-flow`
- 검증: `verify-change` + `qa-agent`
- 문서: `document-change` · `docs-agent`
- 배포 전: `release-check`
- 지식: `kit-wiki` · 규칙 후보: `kit-rule-mine`

## 직접 처리 가능한 예외

- 오탈자·문구·주석·단순 링크·명백한 단일 파일 소규모 스타일 수정

## 다중 작업 처리 원칙

- 화면 + API: `frontend-agent` + `backend-agent` (Gate 2 후)
- 요구 애매: `plan-feature` → `start-feature`
- Gate 2 후 병렬: `parallel-delivery`
- 구현 후 QA: `verify-change`

## 분담 임계치

[`shared/rules/working-principles.mdc`](shared/rules/working-principles.mdc) **분담 임계치** 절을 따른다.

## 금지사항

- Rules/Skills/Agents 중복 정의
- 근거 없는 구조 전면 개편
- 미확정 사항을 확정처럼 구현
