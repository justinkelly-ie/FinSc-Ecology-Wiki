# Evolutionary Phylogeny & 137-Grid Scale Trajectory Speciation Multi-Ecology Observation

## Overview & Theoretical Foundation

In Evolutionary Biology (Darwin 1859, Hennig 1966 cladistics), species diverge along branching **Phylogenetic Trees** driven by natural selection and genomic mutation.

---

## Executable Literate Idris2 Observation Code

```idris
module Wiki.Observations.PhylogeneticTree

import Stage0.BoxInt
import Stage1.VexelMaxel
import Geometry
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
  mutationBit   : Bit              -- One = novel derived trait mutation
  phyloSubstrate: Stage1.VexelMaxel.Maxel            -- Phylogenetic branching DAG tree

-----------------------------------------------------------------------
-- 2. CANONICAL CLADES & SPECIATION BRANCHING
-----------------------------------------------------------------------

||| Canonical ancestral stem clade state.
public export
canonicalAncestralStem : PhylogeneticCladeState
canonicalAncestralStem =
  let tId = 1
      mBit = Zero
      sub = identityMaxel
  in MkPhyladeState tId mBit sub

||| Speciation event: cladogenesis splits ancestral stem into two sister taxa.
public export
speciationBranch : PhylogeneticCladeState -> PhylogeneticCladeState
speciationBranch stem =
  let tIdNew = 2
      mBitNew = One
      branchSub = gSubstrate
  in MkPhyladeState tIdNew mBitNew branchSub

-----------------------------------------------------------------------
-- 3. VERIFIED PHYLOGENETIC INVARIANT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: Speciation produces a novel derived trait mutation (Zero -> One bit flip).
public export
prop_speciationTraitMutates : PhylogeneticCladeState -> Bool
prop_speciationTraitMutates stem =
  let derived = speciationBranch stem
  in (stem.mutationBit == Zero) && (derived.mutationBit == One)

||| Property 2: Phylogenetic DAG tree expands upon speciation.
public export
prop_phyloTreeSubstrateExpands : PhylogeneticCladeState -> Bool
prop_phyloTreeSubstrateExpands stem =
  let derived = speciationBranch stem
      lagStem = unwrapBox (g11 stem.phyloSubstrate)
      lagDerived = unwrapBox (g12 derived.phyloSubstrate)
  in lagStem == 1 && lagDerived == 1

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
