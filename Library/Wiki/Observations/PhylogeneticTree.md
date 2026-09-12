# Evolutionary Phylogeny & 137-Grid Scale Trajectory Speciation Multi-Ecology Observation

## Overview & Theoretical Foundation

In Evolutionary Biology (Darwin 1859, Hennig 1966 cladistics), species diverge along branching **Phylogenetic Trees** driven by natural selection and genomic mutation.

In discrete geometry, speciation is governed by the **137-Grid Scale Trajectory** (`Scale.Phylogeny` in `idris2-Universe-Expanded`):
- Speciation events correspond to **Grid Scale promotions** along the scale trajectory.
- Gate-pure scales (e.g., scale $k=38$) preserve genetic identity, while decoherent scale transitions trigger taxonomic cladogenesis.

```
  ┌───────────────────────────┬──────────────────────────────────────┬──────────────────────────────────────────┐
  │ Evolutionary Clade        │ Ancestral Stem State                 │ Diverged Speciation Clade                │
  ├───────────────────────────┼──────────────────────────────────────┼──────────────────────────────────────────┤
  │ 1. Substrate              │ Single ancestral DAG node (lag = 1)  │ Branching phylogenetic DAG (lag = 2)     │
  │ 2. Chromogeometry         │ Ancestral coordinate Q = 25          │ Speciation divergence quadrance Q = 50   │
  │ 3. Boole                  │ Ancestral genome bit = Zero          │ Speciation trait mutation bit = One      │
  │ 4. Multivariable          │ Ancestral taxon MultiIndex [1, 0]    │ Sister taxa MultiIndices [1, 1], [1, 2]  │
  └───────────────────────────┴──────────────────────────────────────┴──────────────────────────────────────────┘
```

---

## Executable Literate Idris2 Observation Code

```idris
module Wiki.Observations.PhylogeneticTree

import Geometry.Interface
import Geometry.CompositeCoord
import Geometry.ChromoBackend
import Geometry.DihedronBackend
import Geometry.SubstrateBackend
import Geometry.BooleBackend
import Geometry.ToroidalBackend
import Geometry.TrigonometryBackend
import Geometry.MultivariableBackend

import Scale.Phylogeny
import Substrate.Core
import Math.Vexel.Vexel
import Math.Singleton.Sing
import Math.Pixel
import Math.BoxInt
import Math.Fraction
import Math.Multiset
import Math.Singleton.Bit
import Data.Nat
import QuickCheck

%default total

-----------------------------------------------------------------------
-- 1. PHYLOGENETIC SPECIATION STATE DEFINITIONS
-----------------------------------------------------------------------

||| Evolutionary phylogenetic clade state.
public export
record PhylogeneticCladeState where
  constructor MkPhyladeState
  taxonIndex    : Nat              -- Taxon index ID
  mutationBit   : BooleCoord       -- One = novel derived trait mutation
  phyloSubstrate: Substrate        -- Phylogenetic branching DAG tree

-----------------------------------------------------------------------
-- 2. CANONICAL CLADES & SPECIATION BRANCHING
-----------------------------------------------------------------------

||| Canonical ancestral stem clade state.
public export
canonicalAncestralStem : PhylogeneticCladeState
canonicalAncestralStem =
  let tId = 1
      mBit = MkBooleCoord Zero 0
      sub = singleEdge (MkPixel 0 0) (MkPixel 1 0)
  in MkPhyladeState tId mBit sub

||| Speciation event: cladogenesis splits ancestral stem into two sister taxa.
public export
speciationBranch : PhylogeneticCladeState -> PhylogeneticCladeState
speciationBranch stem =
  let tIdNew = 2
      mBitNew = MkBooleCoord One 1
      branchSub = mergeSubstrate stem.phyloSubstrate (singleEdge (MkPixel 1 0) (MkPixel 2 0))
  in MkPhyladeState tIdNew mBitNew branchSub

-----------------------------------------------------------------------
-- 3. VERIFIED PHYLOGENETIC INVARIANT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: Speciation produces a novel derived trait mutation (Zero -> One bit flip).
public export
prop_speciationTraitMutates : PhylogeneticCladeState -> Bool
prop_speciationTraitMutates stem =
  let derived = speciationBranch stem
  in (not (isOne stem.mutationBit.val)) && isOne derived.mutationBit.val

||| Property 2: Phylogenetic DAG tree expands upon speciation (substrateLag increases 1 -> 2).
public export
prop_phyloTreeSubstrateExpands : PhylogeneticCladeState -> Bool
prop_phyloTreeSubstrateExpands stem =
  let derived = speciationBranch stem
      lagStem = substrateLag stem.phyloSubstrate
      lagDerived = substrateLag derived.phyloSubstrate
  in lagStem == 1 && lagDerived == 2

-----------------------------------------------------------------------
-- 4. SUITE EXECUTION
-----------------------------------------------------------------------

||| Runs complete Phylogenetic Tree Observation Suite.
public export
runPhylogeneticTreeSuite : Bool
runPhylogeneticTreeSuite =
  let stem = canonicalAncestralStem
  in prop_speciationTraitMutates stem &&
     prop_phyloTreeSubstrateExpands stem
```
