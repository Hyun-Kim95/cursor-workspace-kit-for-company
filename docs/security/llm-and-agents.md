---
type: doc
project: cursor-workspace-kit
doc_lane: security
updated_at: 2026-07-03T00:00:00
tags: [docs, security, llm, agents, vault-sync]
---

# llm-and-agents — LLM·AI 에이전트 보안

LLM API·에이전트 자동화에서 흔한 비용·권한 사고를 막기 위한 최소 기준. 상위: [`vibe-coding-baseline.md`](vibe-coding-baseline.md).

## 체크리스트

| ID | 항목 | 요지 |
|----|------|------|
| LLM-1 | **서버 프록시** | API 키·모델 ID·시스템 프롬프트는 서버/엣지에만. 브라우저에서 LLM 벤더 직접 호출 금지 (`.env`를 프론트에 넣어도 번들에 포함될 수 있음) |
| LLM-2 | **Rate limit·비용** | LLM 중계 엔드포인트에 IP/사용자별 rate limit. 벤더 콘솔 **월 지출 한도** 설정 |
| LLM-3 | **프롬프트 인젝션** | 사용자 입력·웹 스크래핑·업로드 문서를 프롬프트에 넣을 때 악의적 지시 삽입 가정. 도구(함수) 권한 최소화 |
| LLM-4 | **에이전트·운영 DB** | 로컬 dev·CI·Cursor 에이전트에 **운영 DB write 권한 금지**. 읽기 전용 복제 또는 샌드박스 DB 사용 |
| LLM-5 | **Human 승인** | 삭제·배포·대량 쓰기·결제 등 위험 도구는 자동 실행 전 사람 승인 단계 |

## 구현 패턴 (권장)

```
[클라이언트] → POST /api/chat (세션 인증)
                 → [서버] rate limit + 입력 검증
                 → [LLM API] (키는 서버 env만)
```

- 스트리밍도 동일: 클라이언트는 **자사 API**만 호출.

## 프롬프트 인젝션 완화 (요약)

- 시스템 지시와 사용자 콘텐츠를 구조적으로 분리.
- 에이전트 도구는 allowlist; 파일시스템·DB·shell은 최소 권한.
- 외부 URL/HTML ingest는 사람 검토 또는 별도 샌드박스 파이프라인.

입력 검증 일반: [`strict-axis-checklist.md`](strict-axis-checklist.md) C절.

## dev / prod 분리

- 에이전트·로컬 스크립트의 DB URL·Railway·Supabase **service_role**은 운영이 아닌 dev/staging만.
- harness: [`harness-layer1.md`](../agent/harness-layer1.md) (`shellGuard`, 환경 변수 혼선 방지).

## 엄격 보안 게이트 연동

- **secrets** 축: 저장소·로그에 LLM 키 없음.
- **authz** 축: LLM 프록시도 인증·권한 검사.
- F3 rate limit: LLM 중계 필수. [`strict-axis-checklist.md`](strict-axis-checklist.md) F3 비고.

## 관련

- `backend-agent`: LLM 프록시·에이전트 백엔드 구현 시 본 문서 준수
- baseline 5항 ②④⑤: [`vibe-coding-baseline.md`](vibe-coding-baseline.md)
