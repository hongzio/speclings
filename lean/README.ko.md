# speclings: Lean 트랙

[English](README.md) | **한국어** · [speclings](../README.ko.md)

작게 "고장 난" Lean 파일을 하나씩 고치면서 프로그래밍 언어이자 증명 보조기인 Lean 4 를 배웁니다.

모두 73문제이고, 여덟 Part 로 나뉩니다: Part 0: 도구, Part 1: 값과 함수, Part 2: 데이터 정의, Part 3: 프로그램, Part 4: 명제와 증명, Part 5: 귀납법, Part 6: 종속 타입, Part 7: 검증된 프로그램.

`speclings lean` 으로 실행합니다. 설치와 명령은 [메인 README](../README.ko.md) 에 있습니다.
검사하기 전에 speclings 가 `checker/` 의 검사기를 빌드합니다 (캐시됨. 맨 처음 빌드만 몇 초 걸림).

통과했을 때는 `#eval`, `#check` 의 출력을 보여주고, (linter 같은) 경고는 `-v` 를 줄 때만 보여줍니다.

## 에디터

speclings 는 터미널에서 파일을 검사하지만, Lean 은 입력하는 동안 Lean 을 돌려 커서 위치의 증명 목표(goal)를
보여 주는 에디터(infoview)에서 쓰는 것이 가장 좋습니다. 둘을 나란히 띄워 쓰세요.

- **Neovim**: [lean.nvim](https://github.com/Julian/lean.nvim). PATH 의 `lean` 을 실행하므로, mise 가 활성화된
  셸에서 Neovim 을 시작하세요 (또는 mise 의 shims 를 PATH 에 넣으세요). `:checkhealth lean` 이 Lake 를 찾아야 합니다.
- **VS Code**: [Lean 4 확장](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4).
  [elan](https://github.com/leanprover/elan) 과 함께 쓰는 것이 가장 좋습니다. elan 은 저장소 루트의 `lean-toolchain` 을 읽어
  mise 와 같은 Lean 버전을 씁니다. `work/lean/` 이 아니라 저장소 루트를 여세요.

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
speclings 는 텍스트가 아니라 컴파일된 선언을 비교하므로(`checker/` 참고), 파일 서식은 마음대로 바꿔도 되고 보조 정리를 더해도 됩니다.
검사 한 번에 1초 정도 걸립니다.

## 문제를 만드는 사람에게

`speclings verify lean` 은 PATH 의 Lean, `lean-toolchain`, `mise.toml` 의 버전이 같은지 보고, 문제마다
모든 언어의 원본이 의도한 방식으로 실패하는지(Lean 메시지, 그 종류나 문구, 가리키는 줄), 검사를 통과하지 못하는지,
그리고 빈 파일이 통과하지 않는지 확인합니다.

[모든 트랙에 공통인 규칙](../README.ko.md#문제를-만드는-사람에게)에 더해:

- 원본이 `sorry` 와 `#` 명령을 빼면 컴파일될 때는 `fill()` 을 씁니다. 그러면 원본이 학습자 파일과 비교할 기준이 됩니다.
  일부러 실수를 넣은 원본(문법이나 타입 에러)에는 `fix()` 를 씁니다. 이런 문제에는 정의를 쓰는 `#guard` 가 있어야 합니다. 없으면 빈 파일이 통과합니다.
- Lean 은 `sorry` 를 그 선언의 이름 위치에서 보고하므로 `Broken.At` 은 선언입니다: `blank("def triple")`.
- `#` 명령(`#guard`, `#eval`, `#check`, ...)은 한 줄에 씁니다. 기준을 만들 때 줄 단위로 지웁니다.
- `#guard_msgs` 는 쓰지 않습니다. 기대 출력이 주석이라 번역하면 바뀝니다.
- import 하지 않거나, Lean 에 들어 있는 모듈만 import 합니다. import 할수록 모든 검사가 느려집니다 (`import Std` 는 약 0.4초).

Lean 을 올리려면 `mise.toml` 과 `lean-toolchain`(둘 다 저장소 루트) 의 버전을 바꾸고 `mise install` 후 `speclings verify lean` 을 실행하세요. Lean 메시지는 버전마다 바뀝니다.

## 더 배우기

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/): 프로그래밍 언어로서의 Lean.
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/): 의존 타입 이론과 증명.
- [The Lean Language Reference](https://lean-lang.org/doc/reference/latest/).
- [Natural Number Game](https://adam.math.hhu.de/#/g/leanprover-community/nng4): 브라우저에서 게임으로 하는 증명.
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/): Mathlib 으로 하는 수학.
- [The Hitchhiker's Guide to Logical Verification](https://lean-forward.github.io/hitchhikers-guide/2024/): 의미론과 프로그램 검증.
