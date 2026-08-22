# project-kit

사내 제품용 **Gate rules** 묶음. 제품 레포에는 submodule + **`/start-setting`** / **`/start`**.

**전체 절차:** [`docs/agent/product-onboarding.md`](../docs/agent/product-onboarding.md)

## 포함 (SSOT)

| 경로 | 내용 |
|------|------|
| `.cursor/rules/60-delivery-gates.mdc` | Gate 1~3, ATDD-lite |

(`project-kit/.cursor/skills/` — 회사 킷에서는 **없음**. 공통 스킬은 `shared/skills/`.)

## 함께 필요

| 항목 | SSOT |
|------|------|
| `AGENTS.md` | 오케스트레이션 |
| `shared/rules/` | 운영 규칙 |
| `shared/skills/` | plan/start/verify 등 |
| `shared/agents/` | FE/BE/PRD/QA/docs |

프로파일: [`docs/agent/company-profile.md`](../docs/agent/company-profile.md)
