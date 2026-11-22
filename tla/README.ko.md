# tlings

[English](README.md) | **한국어**

작게 "고장 난" TLA+ 스펙을 하나씩 고치면서 TLA+ 와 TLC 를 배우는 튜토리얼입니다.
[ziglings](https://codeberg.org/ziglings/exercises/) 방식을 따릅니다.

> **작업 중:** 지금은 20문제(Part 0: 도구, Part 1: 값)가 있고, 계속 추가하고 있습니다.

## 시작하기

macOS 나 Linux 에 [mise](https://mise.jdx.dev/) 만 있으면 됩니다. 나머지는 mise 가 설치합니다.

```sh
git clone https://github.com/hongzio/tlings.git && cd tlings
mise trust         # 이 디렉터리의 mise.toml 을 허용
mise install       # Java, Go, tla2tools, CommunityModules, Apalache
tlings -lang ko    # 한국어로 시작. 언어는 저장되므로 다음부터는 tlings 만
```

`tlings` 는 `bin/tlings` 입니다. mise 가
[셸에서 활성화](https://mise.jdx.dev/getting-started.html#activate-mise)되어 있으면 `bin/` 이 PATH 에 들어가고,
아니면 `mise exec -- tlings` 로 실행합니다.
실행할 때마다 러너를 다시 빌드하므로(캐시됨) 문제가 추가되어도 재설치할 필요가 없습니다.

문제는 `work/` 에서 풉니다. 차례가 된 문제를 tlings 가 고른 언어로 그곳에 복사합니다.
`exercises/` 의 원본은 건드리지 않습니다.

## 사용법

| 명령 | 하는 일 |
|---|---|
| `tlings` | 진도 다음 문제부터 순서대로 검사하고, 첫 실패에서 멈춘다 |
| `tlings -watch` | 위와 같고, `work/` 의 파일을 저장할 때마다 다시 검사한다 |
| `tlings -lang en` | 언어를 바꾼다. `work/` 에 이미 있는 문제는 원래 언어 그대로다 |
| `tlings -n 3` | 3 번 문제만 검사한다 (진도는 바뀌지 않음) |
| `tlings -s 3` | 3 번부터 순서대로 검사한다 |
| `tlings -restore 3` | 3 번 문제를 원래 상태로 되돌린다 (내 파일은 `.bak` 으로 남음) |
| `tlings -reset` | 진도를 지운다 |

실패하면 TLC 의 출력을 **그대로** 보여주고, 그 아래에 결과, 기대 결과, 힌트를 덧붙입니다.
TLC 출력을 읽는 것도 배울 거리입니다.

## 통과 기준

| 기대 결과 | 통과 조건 |
|---|---|
| 에러 없음 | TLC 가 에러 없이 끝난다 (변수 없는 모듈은 모든 `ASSUME` 이 참) |
| 에러 없음, distinct state N 개 | 위 + 탐색한 상태 수가 정확히 N |
| 불변식 위반: X (반례 길이 N) | TLC 가 X 의 위반을 찾고, 반례가 N 개 상태로 이루어진다 |
| deadlock (반례 길이 N) | TLC 가 deadlock 을 찾고, 반례가 N 개 상태로 이루어진다 |

상태 수까지 보는 이유: `Next == FALSE` 처럼 스펙을 "지우면" 모든 불변식이 통과합니다.
상태 수와 반례 길이는 BFS + worker 1 개에서 항상 같은 값이 나오므로 기대값으로 쓸 수 있습니다.

## 구성

```
exercises/en/     원본 문제(고장 난 상태), 영어. 기준 언어
exercises/ko/     한국어 번역. 주석만 다르고 코드는 en 과 같아야 한다
solutions/        정답 (영어). 막혔을 때만 보세요
work/             내 작업 공간. tlings 가 만든다
cmd/tlings/       러너. 문제 순서와 기대 결과는 cmd/tlings/exercises.go
```

## 문제 작성자용

작성자용 절차(검사 항목, 문제 추가, 언어 추가)는 [README.md 의 For authors](README.md#for-authors) 를 보세요.

## 라이선스

[MIT](LICENSE)
