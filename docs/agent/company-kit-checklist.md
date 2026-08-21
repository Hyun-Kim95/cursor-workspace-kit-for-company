# 회사 킷 체크리스트

**프로파일:** [`company-profile.md`](company-profile.md) (형태 A · 사내 제품만)

이 문서는 개인 킷을 **회사 SSOT로 전환**할 때 가져갈 것 / 바꿀 것 / 첫 제품 온보딩을 한곳에 모은다.

---

## 1. 가져갈 것 (구조 유지)

| 경로 | 목적 |
|------|------|
| `shared/rules|skills|agents|hooks/` | 공통 SSOT |
| `project-kit/` | Gate 60·65·70, `client-project-lifecycle`(opt-in) |
| `scripts/` | `sync-kit`, `Invoke-KitStartSetting`, `Invoke-KitStart`, `sync-kit-product` |
| `AGENTS.md` | 오케스트레이션·직접 처리 예외 SSOT |
| `docs/agent/`, `docs/qa/` | 온보딩·Gate·ATDD 문서 |
| 채널 B | 제품 `.cursor/`만 sync — User Rules에 장문 복붙하지 않음 |

**하지 말 것:** 빈 레포에 rules 재작성, 제품마다 킷 복사, `.cursor/`를 SSOT로 직접 편집.

---

## 2. 바꿀 것 (정체성)

아래를 **회사 remote·이름**으로 교체한다.

| 대상 | 현재 | 완료 |
|------|------|------|
| GitHub remote + `git remote set-url` | `https://github.com/Hyun-Kim95/cursor-workspace-kit-for-company.git` | [x] |
| `README.md` clone URL·제품 예시 | 회사 킷 명칭, `my-product` | [x] |
| `scripts/Invoke-KitStartSetting.ps1` `-KitRepoUrl` 기본값 | 동일 URL | [x] |
| `shared/hooks/kit-start-on-prompt.ps1` submodule add URL | 동일 | [x] |
| `docs/agent/product-onboarding.md`, `kit-start.md`, `project-kit/README.md` | URL·예시명 | [x] |
| README/문서의 `dietManagement`·개인 킷 계정 혼동 | 제거·일반화 | [x] |

URL 변경 후 `scripts/sync-kit.ps1` 실행.
---

## 3. 바꿀 것 (정책 오버레이) — 사내 제품만

| 대상 | 변경 요지 | 상태 |
|------|-----------|------|
| `70-client-lifecycle-default.mdc` | 고객 E2E **자동 적용 끔**, 명시 opt-in만 | 반영 |
| `AGENTS.md` 기본 진입 | 사내는 `plan-feature`/`start-feature` 우선, lifecycle은 명시 시 | 반영 |
| `product-monetization-default.mdc` + `product-assumptions.md` | 사업자=회사, 광고·후원 비기본 | 반영 |
| `working-principles.mdc` DB | Railway 고정 제거 → 회사 인프라(미확정) | 반영 |
| `65-design-gate` 이중 목업 | 기본 유지(UI 신규). 부담 시 별도 HUMAN으로 완화 | 유지(미완화) |
| 보안·PII | 필요 시 optional `24-security-gate` + `docs/security/` | 미확정 |

편집은 항상 SSOT만 → sync.

---

## 4. 첫 소비자 온보딩 (Gate 3 소비)

킷만 만들고 제품에 안 붙이면 **소비 미충족**과 같다. 사내 제품 1곳에:

```powershell
# (킷 레포에서) remote URL 확인한 뒤
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Invoke-KitStartSetting.ps1 `
  -WorkspaceRoot D:\path\to\first-internal-product `
  -KitRepoUrl https://github.com/Hyun-Kim95/cursor-workspace-kit-for-company.git
```

제품 폴더를 Cursor로 연 뒤:

```text
/start-setting
/start 스모크: sync·Gate 규칙 로드 확인
```

**스모크 체크**

- [ ] `vendor/cursor-workspace-kit`(또는 설정 경로) submodule OK
- [ ] `.cursor/rules`에 `60-delivery-gates`, `product-monetization-default` 존재
- [ ] `70`이 **opt-in** 문구인지(고객 E2E 자동 진입 없음)
- [ ] `/start` pull·sync 성공 (`.cursor/state/kit-start-last.json` `ok: true`)

소비 증거는 [`docs/qa/integration-consumption-gate.md`](../qa/integration-consumption-gate.md)에 경로·PR·스모크를 남긴다.

---

## 5. 역할·Gate

| 항목 | 내용 |
|------|------|
| 담당 | 메인(킷 전환). 문서 `docs-agent`, 정책 미세조정 `prd-agent` |
| UI/디자인 분담 | 킷 전환 자체에는 불필요 |
| Gate 2 parallel-delivery | 해당 없음 (제품 UI+API 구현 아님) |
| 다음 HUMAN | 원격 인프라, 첫 제품 경로 |

---

## 6. 완료 판정 (이 킷 전환)

- [x] 형태 A · 사내 제품만 프로파일 기록
- [x] 70 opt-in · monetization · DB 전제 오버레이
- [x] private remote + URL 플레이스홀더 실값 교체
- [ ] 첫 사내 제품 `/start-setting` 스모크 + 소비 증거
