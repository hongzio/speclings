# speclings

[English](README.md) | **한국어**

작게 "고장 난" 파일을 하나씩 고치면서 형식 검증(formal verification)을 배우는 튜토리얼입니다.
트랙마다 도구 하나를 다루고, [ziglings](https://codeberg.org/ziglings/exercises/) 와 [rustlings](https://github.com/rust-lang/rustlings) 방식을 따릅니다.

## 트랙

| 트랙 | 배우는 것 | 문제 수 |
|---|---|---|
| [`tla`](tla/README.ko.md) | TLA+ 와 TLC 모델 검사기: 시스템을 상태 기계로 기술하고, 작은 모델의 모든 behavior 를 검사한다 | 53 |
| [`lean`](lean/README.ko.md) | Lean 4: 함수형 프로그램과, 그에 대해 컴퓨터가 검사하는 증명 | 78 |

속성 기반 테스트(property-based testing), Quint, ITF 트레이스를 쓰는 모델 기반 테스트(model-based testing) 트랙을 추가할 예정입니다.
트랙끼리는 서로 독립적이니 필요한 것부터 시작하세요.

## 시작하기

macOS 나 Linux 에 [mise](https://mise.jdx.dev/) 만 있으면 됩니다. 나머지는 mise 가 설치합니다.

```sh
git clone https://github.com/hongzio/speclings.git && cd speclings
mise trust           # 이 디렉터리의 mise.toml 을 허용
mise install         # Go 와 모든 트랙의 도구 (Lean: 다운로드 약 640 MB, 설치 후 3 GB)
speclings -lang ko   # 한국어로. 언어는 저장됩니다
speclings            # 트랙과 진도 보기
speclings tla        # 트랙 시작 (또는 이어서 하기)
```

한 트랙의 도구만 설치하려면:

```sh
mise install go java http:tla2tools http:tla-community-modules   # tla
mise install go github:leanprover/lean4                          # lean
```

`speclings` 는 `bin/speclings` 입니다. mise 가
[셸에서 활성화](https://mise.jdx.dev/getting-started.html#activate-mise)되어 있으면 `bin/` 이 PATH 에 들어가고,
아니면 `mise exec -- speclings` 로 실행합니다.
실행할 때마다 러너를 다시 빌드하므로(캐시됨) 문제가 추가되어도 재설치할 필요가 없습니다.

문제는 `work/<트랙>/` 에서 풉니다. 차례가 된 문제를 speclings 가 고른 언어로 그곳에 복사합니다.
`<트랙>/exercises/` 의 원본은 건드리지 않습니다.

## 사용법

| 명령 | 하는 일 |
|---|---|
| `speclings` | 트랙과 진도를 보여준다 |
| `speclings <트랙>` | 트랙의 진도 다음 문제부터 순서대로 검사하고, 첫 실패에서 멈춘다 |
| `speclings <트랙> -watch` | 위와 같고, `work/<트랙>/` 의 파일을 저장할 때마다 다시 검사한다 |
| `speclings <트랙> -n 3` | 3 번 문제만 검사한다 (진도는 바뀌지 않음) |
| `speclings <트랙> -s 3` | 3 번부터 순서대로 검사한다 |
| `speclings <트랙> -restore 3` | 3 번 문제를 원래 상태로 되돌린다 (내 파일은 `.bak` 으로 남음) |
| `speclings <트랙> -hint` | 현재 문제의 힌트를 본다 (`-hint -n 3`: 3 번 문제). 다시 실행하면 더 자세한 다음 힌트 |
| `speclings <트랙> -v` | 통과했을 때도 도구의 출력을 경고까지 모두 보여준다 |
| `speclings <트랙> -reset` | 트랙의 진도를 지운다 |
| `speclings -lang en` | 모든 트랙의 언어를 바꾼다. `work/` 에 이미 있는 문제는 원래 언어 그대로다 |

실패하면 도구의 출력을 **그대로** 보여주고, 그 아래에 결과와 기대 결과를 덧붙입니다.
그 출력을 읽는 것도 모든 트랙의 배울 거리입니다.
힌트는 `-hint` 로 요청할 때만 보여줍니다. 실마리부터 답까지 여러 단계인 문제가 많고, `-hint` 를 실행할 때마다 한 단계씩 더 보여줍니다.
무엇을 검사하는지, 통과했을 때 무엇을 보여주는지는 트랙마다의 README 에 있습니다.

## 구성

```
cmd/speclings/     러너. 트랙 목록과 순서는 main.go 에 있다
internal/lings/    모든 트랙이 공유하는 부분: 명령, 작업 공간, 진도, verify
<트랙>/            트랙: exercises/<언어>/, solutions/, README, 그리고 문제 목록과
                   검사 방법을 담은 Go 패키지 track/
work/<트랙>/       내 작업 공간. speclings 가 만든다
bin/               speclings 와 tlc (TLA+ CommunityModules 를 포함한 TLC)
```

## 문제를 만드는 사람에게

```sh
speclings verify          # 모든 원본, 번역, 정답 검사 (mise run verify)
speclings verify lean     # 한 트랙만
go test ./...             # (mise run test)
```

`verify` 는 문제마다 다음을 확인합니다:

1. 모든 언어의 원본이 트랙이 정한 **의도한 방식으로** 실패하는지;
2. 번역의 코드가 en 과 같은지 (주석과 빈 줄은 무시);
3. 정답이 통과하는지.

번역이 없는 것은 경고일 뿐이고, 학습자는 영어판을 받습니다.

모든 트랙에 공통인 규칙 (트랙별 규칙은 각 트랙의 README 에 있습니다):

- 정답을 먼저 쓰고(`<트랙>/solutions/`), 그것을 고장 내서 원본을 만듭니다(`<트랙>/exercises/en/`).
- `<트랙>/track/exercises.go` 에 추가합니다. `Broken.At` 에는 줄 번호가 아니라 코드 조각을 줍니다. 언어마다 줄 번호가 다르기 때문입니다.
- 같은 이유로, 설명이나 힌트에 줄 번호를 쓰지 않습니다.
- 번역하고(`<트랙>/exercises/ko/`), 언어별 힌트를 추가합니다.
- `Hint` 는 마지막이자 가장 자세한 힌트로, 답인 경우가 많습니다. 그 앞의 힌트는 `Nudges` 에 가장 막연한 것부터 넣습니다.
  먼저 어떤 생각이나 도구를 쓸지, 그다음 핵심 단계. 학습자가 찾을 수 있는 라이브러리 정리의 이름은 `Hint` 에 남겨 둡니다.
- 문제를 중간에 끼워 넣으려면 뒤의 문제들의 번호를 바꾸고(파일, `exercises.go`, 각 파일 첫 줄의 번호) 예전 이름을
  기록합니다(`lings.Exercise.Was`). 그러면 speclings 가 학습자의 진도와 `work/` 의 파일을 새 이름으로 옮깁니다.

언어를 추가하려면 `internal/lings/messages.go` 와 모든 트랙의 `track/messages.go` 에 카탈로그를 더하고, `exercises/<언어>/` 디렉터리를 만드세요.

트랙을 추가하려면 `exercises/en/`, `solutions/`, 그리고 `lings.Track` 을 구현하는 Go 패키지(`internal/lings/track.go` 참고)를 담은
`<이름>/` 을 만들고, `cmd/speclings/main.go` 에 등록하고, 도구를 `mise.toml` 에 추가하세요.

## 라이선스

[MIT](LICENSE)
