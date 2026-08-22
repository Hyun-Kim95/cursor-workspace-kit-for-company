# 회사 킷 체크리스트

**프로파일:** [`company-profile.md`](company-profile.md) (형태 A · 사내 제품만 · **슬림**)

---

## 1. 유지 (구조)

| 경로 | 목적 |
|------|------|
| `shared/rules|skills|agents|hooks/` | SSOT |
| `project-kit/.cursor/rules/60-delivery-gates.mdc` | Gate·ATDD |
| `scripts/` | sync·온보딩·harness |
| `AGENTS.md` | 오케스트레이션 |
| `docs/agent/`, `docs/qa/` | 온보딩·ATDD |

---

## 2. 정체성 (완료)

| 항목 | 상태 |
|------|------|
| remote `Hyun-Kim95/cursor-workspace-kit-for-company` | [x] |
| URL·문서 예시 일반화 | [x] |

---

## 3. 슬림화 (2026-08-22)

| 제거 | 상태 |
|------|------|
| 수익·광고·monetization | [x] |
| UX·다크·CSS·table·web-app 규칙 | [x] |
| 이중 디자인·65·design-brief·Stitch docs | [x] |
| 70·client-project-lifecycle | [x] |
| optional 21~24 + docs/mobile|analytics|performance|security | [x] |
| design-system-agent | [x] |

---

## 4. 첫 소비자 (미완)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Invoke-KitStartSetting.ps1 `
  -WorkspaceRoot D:\path\to\first-internal-product `
  -KitRepoUrl https://github.com/Hyun-Kim95/cursor-workspace-kit-for-company.git
```

스모크: `/start-setting` → `/start` → `.cursor/rules/60-delivery-gates.mdc` 존재, retired rule 없음.

---

## 5. 완료 판정

- [x] 슬림 SSOT·AGENTS·Gate
- [x] remote·정체성
- [ ] 첫 제품 submodule + 스모크
