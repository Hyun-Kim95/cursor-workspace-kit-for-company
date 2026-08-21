# 제품·사업 전제 (기본값)

에이전트가 **계획·PRD·실행 계획**을 짤 때 쓰는 기본 전제 SSOT이다.  
회사 킷 프로파일: [`company-profile.md`](company-profile.md).

## 수익·사업자

| 항목 | 기본값 |
|------|--------|
| 사업자 | 있음 (회사·법인) |
| 수익 | 제품·서비스 매출 후보(구독·라이선스·B2B 등). 광고·후원은 비기본 |
| 결제 | 대외 유료 범위에서만 설계 후보. 순수 사내 도구는 결제 플로우 비기본. PG·세무 세부는 HUMAN |

규칙: [`shared/rules/product-monetization-default.mdc`](../../shared/rules/product-monetization-default.mdc)  
sync 후: `.cursor/rules/product-monetization-default.mdc`

**다른 모델**(광고만·후원만·사업자 없음)을 쓰려면 채팅에서 **명시**한다. 에이전트는 그때 전제를 갱신하고 PRD에 기록한다.

## 배포

- 채널 B: `shared/rules` 전체 sync
- 채널 A: `project-kit` 게이트 rules + `encoding-utf8-global.mdc` + **`product-monetization-default.mdc`** (`sync-kit-product.ps1`)

## 관련

- [`encoding.md`](encoding.md) — UTF-8
- [`company-kit-checklist.md`](company-kit-checklist.md)
- [`plan-feature`](../../shared/skills/plan-feature/SKILL.md), [`prd-agent`](../../shared/agents/prd-agent.md)
- [`AGENTS.md`](../../AGENTS.md)
