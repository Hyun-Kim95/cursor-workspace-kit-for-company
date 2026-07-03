---
type: doc
project: cursor-workspace-kit
doc_lane: security
updated_at: 2026-07-03T00:00:00
tags: [docs, security, baas, supabase, vault-sync]
---

# baas-checklist — BaaS 접근 통제

Supabase(PostgREST)·Firebase 등 **브라우저에 공개 키가 노출되는 BaaS**에서의 최소 점검. 상위: [`vibe-coding-baseline.md`](vibe-coding-baseline.md).

## 체크리스트

| ID | 점검 | 수동 확인 방법 |
|----|------|----------------|
| BaaS-1 | 사용자 데이터 테이블 RLS **ENABLED** | Supabase: Table Editor → 각 테이블 → RLS 토글 ON. SQL: `SELECT relname, relrowsecurity FROM pg_class JOIN pg_namespace ON ...` |
| BaaS-2 | 정책이 과도하게 넓지 않음 (`USING (true)` 전체 허용 금지) | 대시보드 Policies 탭에서 `SELECT`/`INSERT`/`UPDATE`/`DELETE`별 `auth.uid()` 등 소유자 조건 확인 |
| BaaS-3 | `service_role` / admin SDK 키가 클라이언트·번들에 없음 | `grep -r service_role` / 빌드 산출물·`.env.local`이 git 추적되지 않는지. 프론트 env에 `VITE_*`/`NEXT_PUBLIC_*`로 admin 키 없음 |
| BaaS-4 | 비로그인 PostgREST/REST 호출 시 거부 또는 빈 결과 | curl 또는 브라우저: `anon` 키만으로 `/rest/v1/{table}` 호출 — 민감 행이 반환되면 FAIL |
| BaaS-5 | Storage 버킷 정책 동일 점검 | Storage → Policies. public read/write가 의도된 버킷만 허용. 사용자별 경로는 `auth.uid()` 조건 |

## Supabase 빠른 스모크 (예)

```bash
# anon 키 + 프로젝트 URL (민감 테이블명으로 교체)
curl -s "https://<project>.supabase.co/rest/v1/profiles?select=*" \
  -H "apikey: <anon-key>" \
  -H "Authorization: Bearer <anon-key>"
```

- 로그인 없이 타인 PII가 보이면 **BaaS-1·2·4 FAIL**.
- CORS는 브라우저만 막는다. curl·스크립트는 CORS와 무관하므로 **서버·RLS가 실제 방어선**.

## Firebase 등 (동일 원칙)

- Firestore/Realtime DB **Security Rules**가 기본 deny인지, 인증·소유자 조건이 있는지 확인.
- Admin SDK 키는 서버 전용.

## 엄격 보안 게이트 연동

PRD **보안 게이트=예** + authz 축 활성 시 [`strict-axis-checklist.md`](strict-axis-checklist.md) B절 수동 점검과 **함께** 수행한다.

## 관련

- AC 예시: [`acceptance-criteria.template.md`](../qa/acceptance-criteria.template.md) AC-06
- `backend-agent`: BaaS 스키마·RLS 변경 시 본 체크리스트 spot check
