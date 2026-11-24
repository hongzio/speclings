# leanlings

[English](README.md) | **한국어**

작게 "고장 난" Lean 파일을 하나씩 고치면서 프로그래밍 언어이자 증명 보조기인 Lean 4 를 배우는 튜토리얼입니다.
[ziglings](https://codeberg.org/ziglings/exercises/) 와 [rustlings](https://github.com/rust-lang/rustlings) 방식을 따릅니다.

> **작업 중:** 지금은 17문제(Part 0: 도구, Part 1: 값과 함수)가 있고, 계속 추가하고 있습니다.

## 시작하기

macOS 나 Linux 에 [mise](https://mise.jdx.dev/) 만 있으면 됩니다. 나머지는 mise 가 설치합니다.

```sh
git clone https://github.com/hongzio/leanlings.git && cd leanlings
mise trust          # 이 디렉터리의 mise.toml 을 허용
mise install        # Go 와 Lean (다운로드 약 640 MB, 설치 후 3 GB)
leanlings -lang ko  # 한국어로 시작. 언어는 저장되므로 다음부터는 leanlings 만
```

`leanlings` 는 `bin/leanlings` 입니다. mise 가
[셸에서 활성화](https://mise.jdx.dev/getting-started.html#activate-mise)되어 있으면 `bin/` 이 PATH 에 들어가고,
아니면 `mise exec -- leanlings` 로 실행합니다.
실행할 때마다 러너와 검사기를 다시 빌드하므로(캐시됨. 맨 처음 빌드만 몇 초 걸림) 문제가 추가되어도 재설치할 필요가 없습니다.

문제는 `work/` 에서 풉니다. 차례가 된 문제를 leanlings 가 고른 언어로 그곳에 복사합니다.
`exercises/` 의 원본은 건드리지 않습니다.

## 에디터

leanlings 는 터미널에서 파일을 검사하지만, Lean 은 입력하는 동안 Lean 을 돌려 커서 위치의 증명 목표(goal)를
보여 주는 에디터(infoview)에서 쓰는 것이 가장 좋습니다. 둘을 나란히 띄워 쓰세요.

- **Neovim**: [lean.nvim](https://github.com/Julian/lean.nvim). PATH 의 `lean` 을 실행하므로, mise 가 활성화된
  셸에서 Neovim 을 시작하세요 (또는 mise 의 shims 를 PATH 에 넣으세요). `:checkhealth lean` 이 Lake 를 찾아야 합니다.
- **VS Code**: [Lean 4 확장](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4).
  [elan](https://github.com/leanprover/elan) 과 함께 쓰는 것이 가장 좋습니다. elan 은 `lean-toolchain` 을 읽어 mise 와 같은 Lean 버전을 씁니다.

## 사용법

| 명령 | 하는 일 |
|---|---|
| `leanlings` | 진도 다음 문제부터 순서대로 검사하고, 첫 실패에서 멈춘다 |
| `leanlings -watch` | 위와 같고, `work/` 의 파일을 저장할 때마다 다시 검사한다 |
| `leanlings -lang en` | 언어를 바꾼다. `work/` 에 이미 있는 문제는 원래 언어 그대로다 |
| `leanlings -n 3` | 3 번 문제만 검사한다 (진도는 바뀌지 않음) |
| `leanlings -s 3` | 3 번부터 순서대로 검사한다 |
| `leanlings -restore 3` | 3 번 문제를 원래 상태로 되돌린다 (내 파일은 `.bak` 으로 남음) |
| `leanlings -hint` | 현재 문제의 힌트를 본다 (`-hint -n 3`: 3 번 문제) |
| `leanlings -v` | 통과했을 때 Lean 의 경고도 보여준다 |
| `leanlings -reset` | 진도를 지운다 |

실패하면 Lean 의 메시지를 **그대로** 보여주고, 그 아래에 결과와 기대 결과를 덧붙입니다.
힌트는 `leanlings -hint` 로 요청할 때만 보여줍니다.
통과했을 때는 `#eval`, `#check` 의 출력을 보여주고, (linter 같은) 경고는 `-v` 를 줄 때만 보여줍니다.
Lean 메시지를 읽는 것도 배울 거리입니다.

## 통과 기준

모든 문제는 다음을 만족하면 통과합니다:

1. Lean 이 에러도 `sorry` 도 보고하지 않는다.
2. 원본의 `#guard` 가 모두 파일에 남아 있다. 공백은 달라도 되고, 새 `#guard` 를 더해도 된다.

`sorry` 를 채우는 문제(기대: "주어진 정의와 명제는 그대로")는 다음도 만족해야 합니다:

3. 원본의 정의와 정리가 모두 남아 있고, 명제가 같다.
   `sorry` 가 없는 정의는 주어진 것이므로 그대로여야 한다.
4. 증명이 Lean 의 표준 공리(`propext`, `Classical.choice`, `Quot.sound`)와 문제가 직접 선언한 공리에만 기댄다.
   직접 추가한 `axiom`, `native_decide`, 남은 `sorry` 는 증명이 아니다.

프로그램 출력을 검사하거나, 특정 전술을 금지하는 문제도 있습니다 (예: 귀납법 문제에서 `omega`).

이렇게까지 검사하는 이유: 명제를 `True` 로 바꾸거나, 주어진 정의를 `rfl` 로 증명되게 바꾸면 아무것도 풀지 않고도 Lean 은 통과합니다.
leanlings 는 텍스트가 아니라 컴파일된 선언을 비교하므로(`checker/` 참고), 파일 서식은 마음대로 바꿔도 되고 보조 정리를 더해도 됩니다.
검사 한 번에 1초 정도 걸립니다.

## 구성

```
exercises/en/     원본 문제 (고장 난 상태), 영어. 기준 언어
exercises/ko/     한국어 번역. 주석만 다르고 코드는 en 과 같아야 함
solutions/        정답 (영어). 막혔을 때만 보세요
work/             여러분의 작업 공간. leanlings 가 만듦
cmd/leanlings/    러너. 문제 순서와 기대 결과는 cmd/leanlings/exercises.go 에 있음
checker/          여러분의 파일을 원본과 비교하는 Lean 프로그램
```

## 문제를 만드는 사람에게

```sh
leanlings -verify   # 모든 원본, 번역, 정답 검사
go test ./cmd/leanlings
```

`-verify` 는 PATH 의 Lean, `lean-toolchain`, `mise.toml` 의 버전이 같은지 보고, 문제마다 다음을 확인합니다:

1. 모든 언어의 원본이 **의도한 방식으로** 실패하는지: Lean 메시지, 그 종류나 문구, 가리키는 줄;
2. 번역의 코드가 en 과 같은지 (주석과 빈 줄은 무시);
3. 정답은 통과하고, 빈 파일은 통과하지 않는지.

번역이 없는 것은 경고일 뿐이고, 학습자는 영어판을 받습니다.

문제를 추가하려면:

1. 정답을 먼저 쓰고(`solutions/`), 그것을 고장 내서 원본을 만듭니다(`exercises/en/`).
2. `exercises.go` 에 추가합니다. 원본이 `sorry` 와 `#` 명령을 빼면 컴파일될 때는 `fill()` 을 씁니다. 그러면 원본이 학습자 파일과 비교할 기준이 됩니다.
   일부러 실수를 넣은 원본(문법이나 타입 에러)에는 `fix()` 를 씁니다. 이런 문제에는 정의를 쓰는 `#guard` 가 있어야 합니다. 없으면 빈 파일이 통과합니다.
3. `Broken.At` 에는 줄 번호가 아니라 코드 조각을 줍니다. 언어마다 줄 번호가 다르기 때문입니다. Lean 은 `sorry` 를 그 선언의 이름 위치에서 보고하므로 `blank("def triple")` 처럼 씁니다.
4. 번역하고(`exercises/ko/`), 언어별 힌트를 추가합니다.

문제 파일 규칙:

- 같은 이유로, 설명이나 힌트에 줄 번호를 쓰지 않습니다.
- `#` 명령(`#guard`, `#eval`, `#check`, ...)은 한 줄에 씁니다. 기준을 만들 때 줄 단위로 지웁니다.
- `#guard_msgs` 는 쓰지 않습니다. 기대 출력이 주석이라 번역하면 바뀝니다.
- import 하지 않거나, Lean 에 들어 있는 모듈만 import 합니다. import 할수록 모든 검사가 느려집니다 (`import Std` 는 약 0.4초).

Lean 을 올리려면 `mise.toml` 과 `lean-toolchain` 의 버전을 바꾸고 `mise install` 후 `leanlings -verify` 를 실행하세요. Lean 메시지는 버전마다 바뀝니다.

## 더 배우기

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/): 프로그래밍 언어로서의 Lean.
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/): 의존 타입 이론과 증명.
- [The Lean Language Reference](https://lean-lang.org/doc/reference/latest/).
- [Natural Number Game](https://adam.math.hhu.de/#/g/leanprover-community/nng4): 브라우저에서 게임으로 하는 증명.
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/): Mathlib 으로 하는 수학.
- [The Hitchhiker's Guide to Logical Verification](https://lean-forward.github.io/hitchhikers-guide/2024/): 의미론과 프로그램 검증.

## 라이선스

[MIT](LICENSE)
