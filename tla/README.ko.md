# speclings: TLA+ 트랙

[English](README.md) | **한국어** · [speclings](../README.ko.md)

작게 "고장 난" TLA+ 스펙을 하나씩 고치면서 TLA+ 와 TLC 를 배웁니다.

> **작업 중:** 지금은 53문제(Part 0: 도구, Part 1: 값, Part 2: 상태 기계, Part 3: 동시성, Part 4: 시간 속성, Part 5: 심화)가 있고, 계속 추가하고 있습니다.

`speclings tla` 로 실행합니다. 설치와 명령은 [메인 README](../README.ko.md) 에 있습니다.

통과했을 때는 `-v` 를 주거나, 파일에서 `Print`, `PrintT` 를 썼거나, 목표가 반례(위반이나 deadlock)였을 때만 TLC 출력을 보여줍니다. 반례를 읽을 수 있게 하려는 것입니다.

## 통과 기준

| 기대 결과 | 통과 조건 |
|---|---|
| 에러 없음 | TLC 가 에러 없이 끝난다. 원본의 `ASSUME` 은 모두 파일에 남아 있어야 한다 (`???` 는 채우되 줄을 지우거나 주석 처리하지 않기). 새 `ASSUME` 은 더해도 된다 |
| 에러 없음, distinct state N 개 | 위 + 탐색한 상태 수가 정확히 N |
| 불변식 위반: X (반례 길이 N) | TLC 가 X 의 위반을 찾고, 반례가 N 개 상태로 이루어진다 |
| deadlock (반례 길이 N) | TLC 가 deadlock 을 찾고, 반례가 N 개 상태로 이루어진다 |
| 속성 위반: X | TLC 가 속성 X 의 위반을 찾는다. 반례 길이는 보지 않는다: liveness 반례는 가장 짧지도 않고 실행마다 다를 수 있다 |

상태 수까지 보는 이유: `Next == FALSE` 처럼 스펙을 "지우면" 모든 불변식이 통과합니다.
상태 수와 반례 길이는 BFS + worker 1 개에서 항상 같은 값이 나오므로 기대값으로 쓸 수 있습니다.

TLC 는 실행마다 30 초가 지나면 멈춥니다. 문제는 1 초 안팎이면 끝나므로, 더 오래 걸리는 스펙은 상태 공간이 무한할 가능성이 큽니다.

## Go 프로그램

Part 3, 5 는 실제 Go 코드를 모델링합니다. 프로그램은 `go/` 에 있고, 문제에 적힌 대로 저장소 루트에서 실행합니다 (예: `go run -race ./tla/go/034_lost_update`).

## 문제를 만드는 사람에게

`speclings verify tla` 는 모든 언어의 원본이 의도한 방식으로 실패하는지 확인합니다: exit code, 출력의 문구, 그리고 가리키는 줄.

[모든 트랙에 공통인 규칙](../README.ko.md#문제를-만드는-사람에게)에 더해:

- 원본의 `ASSUME` 은 모두 학습자 파일에 남아 있어야 합니다. 지워도 "통과"하면 안 되기 때문입니다.
  speclings 는 공백을 무시하고 `???` 는 아무것에나 맞는 것으로 보고 줄을 비교합니다. 학습자는 새 `ASSUME` 을 더해도 됩니다.
  `Broken.At` 이 든 `ASSUME` 줄은 그 코드 조각만 남아 있으면 되므로, 거기 있는 값을 고치게 하는 문제도 만들 수 있습니다.
- 보조 모듈을 INSTANCE 하거나 EXTENDS 하는 문제는 그 모듈을 `Modules` 에 적습니다. speclings 는 보조 모듈을 문제와 함께 `work/tla/` 에 복사하고, `verify` 는 그 코드도 언어 사이에 같은지 확인합니다. `work/tla/` 는 공유되므로 이름 앞에 문제 번호를 붙이세요 (`050_AtomicCounter`).
- `solutions/<Name>.cfg` 는 `.cfg` 를 고치는 문제에만 둡니다. 없으면 원본의 `.cfg` 로 정답을 검사합니다.

## 더 나아가기

- **ALIAS**: `.cfg` 에 `ALIAS View` 를 쓰면 TLC 가 반례의 각 상태를 변수 대신 레코드 `View` 로 출력합니다 (051 의 팁).
- **시뮬레이션**: `tlc -simulate num=1000 -depth 100 Spec.tla` 는 모든 behavior 대신 최대 100 step 의 무작위 behavior 1000 개를 검사합니다. 다 탐색하기엔 너무 큰 상태 공간에 씁니다. `num` 이 없으면 멈출 때까지 계속 돕니다.
- **[Apalache](https://github.com/apalache-mc/apalache)**: SMT solver 와 타입 주석을 쓰는 TLA+ 기호적(symbolic) 모델 검사기입니다. TLC 가 나열할 수 없는 크거나 무한한 데이터를 가진 스펙도 검사할 수 있습니다.
- **더 읽을거리**: Leslie Lamport 의 [Specifying Systems](https://lamport.azurewebsites.net/tla/book.html), Hillel Wayne 의 [Learn TLA+](https://learntla.com).
