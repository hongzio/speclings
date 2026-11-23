import Lean
open Lean

/-!
# leanlings-check

Compares a learner's compiled exercise with the reference: the original exercise
(with its `sorry`s) compiled the same way. Both are `.olean` files of a module with
the same name, in different directories.

    leanlings-check <refDir> <learnerDir> <Module>

For every declaration of the reference module, except internal ones and the
auxiliary declarations of theorems and of definitions that contain `sorry`:

* it must still exist, and be the same kind of declaration (a theorem stays a theorem);
* its type (the statement) must be the same;
* if it is a definition without `sorry` (given by the exercise), its value must be the same;
* it may only depend on the standard axioms and on axioms the exercise itself declares.

Fresh declarations of the learner (helper lemmas and so on) are allowed; they are
checked through the declarations that use them.

Prints one JSON object per problem: `{"problem": ..., "decl": ..., "detail": ...}`.
Exit code: 0 no problems, 1 problems, 2 the check could not run.
-/

def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

def kindOf : ConstantInfo → String
  | .defnInfo _ => "def"
  | .thmInfo _ => "theorem"
  | .axiomInfo _ => "axiom"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quot"
  | .inductInfo _ => "inductive"
  | .ctorInfo _ => "constructor"
  | .recInfo _ => "recursor"

/-- Definitions with `sorry` are the learner's to fill in. -/
def isHole (c : ConstantInfo) : Bool :=
  match c with
  | .defnInfo v => v.value.hasSorry
  | .opaqueInfo v => v.value.hasSorry
  | _ => false

/-- Whether `n` is an auxiliary declaration of a theorem or of a hole, e.g. `f.match_1`
or `t.proof_1`. Their shape depends on how the learner fills in the proof or definition. -/
def isAuxOfLearnerPart (ref : NameMap ConstantInfo) (n : Name) : Bool :=
  go n.getPrefix
where
  go : Name → Bool
    | .anonymous => false
    | p@(.str q _) | p@(.num q _) =>
      match ref.find? p with
      | some c => c.isTheorem || isHole c || go q
      | none => go q

structure Problem where
  problem : String
  decl : Name
  detail : String := ""
  deriving ToJson

def runCore (env : Environment) (x : CoreM α) : IO α := do
  let ctx : Core.Context := { fileName := "<leanlings-check>", fileMap := default }
  let (a, _) ← x.toIO ctx { env }
  return a

def check (refDir learnerDir : System.FilePath) (mod : Name) : IO (Array Problem) := do
  let (refData, _) ← readModuleData (refDir / s!"{mod}.olean")
  let ref : NameMap ConstantInfo :=
    refData.constants.foldl (fun m c => m.insert c.name c) {}
  initSearchPath (← findSysroot) [learnerDir]
  let env ← importModules #[{ module := mod }] {}
  let allowed := standardAxioms ++ (refData.constants.filter (·.isAxiom)).toList.map (·.name)
  let mut problems := #[]
  for cR in refData.constants do
    let n := cR.name
    if (n.isInternal && !isPrivateName n) || isAuxOfLearnerPart ref n then
      continue
    let some cL := env.find? n
      | problems := problems.push { problem := "missing", decl := n }; continue
    if kindOf cR != kindOf cL then
      problems := problems.push { problem := "kind", decl := n, detail := s!"{kindOf cR} → {kindOf cL}" }
      continue
    if cR.type != cL.type then
      problems := problems.push { problem := "statement", decl := n }
      continue
    if !cR.isTheorem && !isHole cR && cR.value? != cL.value? then
      problems := problems.push { problem := "definition", decl := n }
      continue
    let axioms ← runCore env (collectAxioms n)
    let bad := axioms.filter (!allowed.contains ·)
    unless bad.isEmpty do
      problems := problems.push { problem := "axioms", decl := n, detail := ", ".intercalate (bad.toList.map toString) }
  -- Report what the learner wrote, not the declarations Lean generated from it
  -- (Point.rec, Point.mk.injEq, ...): keep problems with a source range, unless none has one.
  -- A missing declaration has no range; drop it when its parent is missing too.
  let mut shown := #[]
  for p in problems do
    let visible ← match p.problem with
      | "missing" => pure !(problems.any fun q => q.problem == "missing" && q.decl == p.decl.getPrefix)
      | _ => do pure (← runCore env (findDeclarationRangesCore? p.decl)).isSome
    if visible then shown := shown.push p
  return if shown.isEmpty then problems else shown

def main (args : List String) : IO UInt32 := do
  let [refDir, learnerDir, mod] := args
    | IO.eprintln "usage: leanlings-check <refDir> <learnerDir> <Module>"; return 2
  try
    let problems ← check refDir learnerDir mod.toName
    for p in problems do
      IO.println (toJson p).compress
    return if problems.isEmpty then 0 else 1
  catch e =>
    IO.eprintln s!"leanlings-check: {e}"
    return 2
