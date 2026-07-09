---
type: doc
project: cursor-workspace-kit
doc_lane: qa
updated_at: 2026-07-09
tags: [docs, security, qa, template]
---

# Security Axis Report Template (`docs/qa/security-axis-{날짜}.md`용)

단계 4B 보안 축 수행 결과 기록 템플릿. 이 파일을 제품 레포 `docs/qa/security-axis-{YYYY-MM-DD}.md`로 복사해 채운다.
항목 ID·기준은 [`docs/security/strict-axis-checklist.md`](../security/strict-axis-checklist.md) SSOT를 따른다.

---

## 요약

| 항목 | 값 |
|------|-----|
| 날짜 | YYYY-MM-DD |
| 대상(브랜치·커밋) | `main` @ `abc1234` |
| 티어 | strict / standard |
| 판정 | PASS / FAIL |
| BLOCKER / MAJOR / MINOR | 0 / 0 / 0 |
| `security-last.json` `ok` | true / false |

## A. 자동 스캔 (security:ci)

| ID | 항목 | 결과 | 심각도 | 근거·로그 |
|----|------|------|--------|-----------|
| A1 | 저장소 시크릿 | PASS / FAIL / N/A | - | gitleaks 0건 |
| A2 | 의존성 CVE | PASS / FAIL / N/A | - | |
| A3 | 정적 분석 blocker | PASS / FAIL / N/A | - | |

## B. 인증·권한 (authz) — 수동

| ID | 항목 | 결과 | 심각도 | 근거 |
|----|------|------|--------|------|
| B1 | 인증 필수 경로 | PASS / FAIL / N/A | - | |
| B2 | 권한 검사(서버 측) | PASS / FAIL / N/A | - | |
| B3 | IDOR | PASS / FAIL / N/A | - | |
| B4 | 세션·토큰 무효화 | PASS / FAIL / N/A | - | |
| B5 | 자격증명 평문 저장·로그 | PASS / FAIL / N/A | - | |

BaaS 사용 시 [`docs/security/baas-checklist.md`](../security/baas-checklist.md) 결과를 여기에 병기한다.

## C. 입력·주입·XSS (OWASP)

| ID | 항목 | 결과 | 심각도 | 근거 |
|----|------|------|--------|------|
| C1 | SQL/NoSQL injection | PASS / FAIL / N/A | - | |
| C2 | XSS | PASS / FAIL / N/A | - | |
| C3 | CSRF | PASS / FAIL / N/A | - | |
| C4 | 파일 업로드 | PASS / FAIL / N/A | - | |
| C5 | SSRF (해당 시) | PASS / FAIL / N/A | - | |

## D. 전송·헤더 (transport)

| ID | 항목 | 결과 | 심각도 | 근거 |
|----|------|------|--------|------|
| D1 | TLS | PASS / FAIL / N/A | - | |
| D2 | 보안 헤더 | PASS / FAIL / N/A | - | |
| D3 | CORS | PASS / FAIL / N/A | - | |
| D4 | 쿠키 플래그 | PASS / FAIL / N/A | - | |

## E. 데이터·로그 (data)

| ID | 항목 | 결과 | 심각도 | 근거 |
|----|------|------|--------|------|
| E1 | PII 분류 일치 | PASS / FAIL / N/A | - | |
| E2 | 로그 시크릿 미기록 | PASS / FAIL / N/A | - | |
| E3 | at-rest 암호화 | PASS / FAIL / N/A | - | |
| E4 | 보존·삭제 흐름 | PASS / FAIL / N/A | - | |

## F. 운영·침해 대응 (엄격 권장)

| ID | 항목 | 결과 | 심각도 | 근거 |
|----|------|------|--------|------|
| F1 | 시크릿 로테이션 절차 | PASS / FAIL / N/A | - | |
| F2 | 감사 로그 | PASS / FAIL / N/A | - | |
| F3 | rate limit | PASS / FAIL / N/A | - | |

---

## 미해결 항목·완화 계획

| ID | 심각도 | 내용 | 완화 계획 | 기한 |
|----|--------|------|-----------|------|
| (예) B3 | MAJOR | 관리 API 1곳 IDOR 미차단 | 서버 측 소유자 검사 추가 PR | YYYY-MM-DD |

## manualReview 반영

수동 축 결과를 `.cursor/state/security-last.json`에 반영한다 (계약: [`docs/security/policy-and-contract.md`](../security/policy-and-contract.md)).

```json
"manualReview": { "authz": "passed", "owasp": "passed" }
```

### 작성 규칙

- 결과는 **PASS / FAIL / N/A**, FAIL에는 심각도 **BLOCKER / MAJOR / MINOR** 필수.
- N/A는 사유를 근거 칸에 한 줄 기록.
- BLOCKER가 1건이라도 있으면 요약 판정은 FAIL, 단계 4C 루프로 되돌린다.
- 미해결 MAJOR는 완화 계획·기한 없이 완료 선언하지 않는다.
