---
name: release-check
description: 배포 직전 핵심 기능·환경·회귀·문서를 점검한다.
---

# Release Check

## 목적
배포 직전 누락과 리스크를 줄이기 위한 최종 검증.

## 점검 절차

### 1) 핵심 기능
- 핵심 시나리오 3~5개
- PRD AC ↔ acceptance test **통과** ([`docs/qa/atdd-lite.md`](../../../docs/qa/atdd-lite.md))

### 2) 환경·비밀
- 필수 env·외부 연동 값
- 비밀정보 코드/로그 노출 없음

### 3) 오류·회귀
- 네트워크/서버 실패 시 사용자 안내
- 인접 기능 회귀

### 4) 문서
- 변경 요약·영향 범위
- API/계약 변경 시 명시

### 5) 검증
- [`verify-change`](../verify-change/SKILL.md) + `qa-agent` (Gate 3)

## 결과 보고
- 배포 가능 / 조건부 / 보류
- 즉시 대응 vs 배포 후 모니터링 분리
