# verify: kit 하네스 스타일 맞춤 (2026-07-27)

## Verifier

- 역할: `qa-agent` (독립 검증, 생성 맥락 미전달)
- Agent: [qa-agent](6f009269-511b-4f6f-9a11-43809f0ff388)

## AC

| AC | 결과 |
|----|------|
| AC-01 분담 임계·Task≤2 SSOT | PASS |
| AC-02 20/30/40/50 alwaysApply false + sync | PASS |
| AC-03 Gate/핵심 always·생성검증 계약 유지 | PASS |
| AC-04 SSOT 링크·다시확인→qa 루브릭 | PASS |

- checkedItems: 4/4
- uncheckedIds: []
- BLOCKER/MAJOR/MINOR: 없음
- 완료 가능: yes

## 소비 증거 (이 kit 워크스페이스)

| 항목 | 증거 |
|------|------|
| 첫 소비자 | `cursor-workspace-kit` (채널 B `.cursor/rules` 로드) |
| sync | `scripts/sync-kit.ps1` exit 0 — rules 18, skills 16, agents 6 |
| always 줄 수(대략) | ~530 → ~440 (20/30/40/50 always 제외; working-principles 임계 추가로 working 자체는 증가) |
| frontmatter smoke | `.cursor/rules/20|30|40|50` → `alwaysApply: false` + globs |

제품 레포 1곳 `/start` smoke는 이번 범위에서 미실시(유지보수·간이 점검). 채널 B User Rules 중복 제거는 **사용자 Settings 작업** — [`docs/agent/rules-deploy.md`](../agent/rules-deploy.md) 체크리스트 참고.
