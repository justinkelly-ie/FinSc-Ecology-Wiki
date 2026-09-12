# Lindeman 10% Trophic Level Energy Flow & Substrate Lag Dissipation Multi-Ecology Observation

## Overview & Theoretical Foundation

In Ecosystem Energetics (Raymond Lindeman 1942), energy transfer between successive trophic levels follows the **10% Trophic Transfer Efficiency Law**:

$$E_{n+1} \approx 0.10 \times E_n$$

The remaining 90% of energy is dissipated as metabolic respiration heat and unconsumed biomass.

In discrete geometry, 10% trophic transfer is modeled as **Substrate Lag Dissipation**:
- **Primary Producers (Trophic Level 1)**: Energy $E_1 = 1000Q$ ChargeGate² units (`substrateLag` = 1000).
- **Primary Consumers / Herbivores (Level 2)**: Transferred energy $E_2 = 100Q$, dissipated lag = 900.
- **Secondary Consumers / Carnivores (Level 3)**: Transferred energy $E_3 = 10Q$, dissipated lag = 90.

```
  ┌───────────────────────────┬──────────────────────────────────────┬──────────────────────────────────────────┐
  │ Trophic Level             │ Energy Quanta (ChargeGate² Q)        │ Dissipated Substrate Thermal Lag         │
  ├───────────────────────────┼──────────────────────────────────────┼──────────────────────────────────────────┤
  │ Level 1: Producers (Plants)│ 1000 Q                               │ 0 Q (Solar capture input)                │
  │ Level 2: Herbivores       │ 100 Q (10% transfer)                 │ 900 Q (Metabolic respiration loss)       │
  │ Level 3: Apex Carnivores  │ 10 Q (10% transfer)                  │ 90 Q (Metabolic respiration loss)        │
  └───────────────────────────┴──────────────────────────────────────┴──────────────────────────────────────────┘
```

---

## Executable Literate Idris2 Observation Code

```idris
module Wiki.Observations.TrophicEnergyFlow

import Geometry.Interface
import Geometry.CompositeCoord
import Geometry.ChromoBackend
import Geometry.DihedronBackend
import Geometry.SubstrateBackend
import Geometry.BooleBackend
import Geometry.ToroidalBackend
import Geometry.TrigonometryBackend

import Wiki.Observations.ATPHydrolysis
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
-- 1. TROPHIC ENERGY FLOW STATE DEFINITIONS
-----------------------------------------------------------------------

||| Trophic level energy pyramid state.
public export
record TrophicPyramidState where
  constructor MkTrophicPyramid
  producerEnergy : Nat              -- Level 1: Primary producers (1000 Q)
  herbivoreEnergy: Nat              -- Level 2: Herbivores (100 Q)
  carnivoreEnergy: Nat              -- Level 3: Apex carnivores (10 Q)
  dissipatedLag  : Nat              -- Cumulative dissipated substrate thermal lag

-----------------------------------------------------------------------
-- 2. CANONICAL TROPHIC PYRAMID & TRANSFER DYNAMICS
-----------------------------------------------------------------------

||| Computes 10% trophic energy transfer efficiency.
public export
trophicTransfer10Percent : Nat -> Nat
trophicTransfer10Percent e = e `div` 10

||| Canonical 3-level ecosystem energy pyramid.
public export
canonicalTrophicPyramid : TrophicPyramidState
canonicalTrophicPyramid =
  let e1 = 1000
      e2 = trophicTransfer10Percent e1      -- 100 Q
      e3 = trophicTransfer10Percent e2      -- 10 Q
      dLag = (minus e1 e2) + (minus e2 e3)  -- 900 + 90 = 990 Q dissipated
  in MkTrophicPyramid e1 e2 e3 dLag

-----------------------------------------------------------------------
-- 3. VERIFIED TROPHIC ENERGY INVARIANT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: 10% trophic efficiency law: Level 2 = 100 Q, Level 3 = 10 Q.
public export
prop_trophic10PercentTransferLaw : Bool
prop_trophic10PercentTransferLaw =
  let pyr = canonicalTrophicPyramid
  in (pyr.herbivoreEnergy == 100) && (pyr.carnivoreEnergy == 10)

||| Property 2: Total energy conservation: E_producers == E_carnivores + E_dissipated.
public export
prop_trophicEnergyConserved : Bool
prop_trophicEnergyConserved =
  let pyr = canonicalTrophicPyramid
  in pyr.producerEnergy == pyr.carnivoreEnergy + pyr.dissipatedLag

||| Property 3: Dissipated substrate thermal lag equals 990 Q (99% total loss across 2 steps).
public export
prop_dissipatedLagIs990Q : Bool
prop_dissipatedLagIs990Q =
  canonicalTrophicPyramid.dissipatedLag == 990

-----------------------------------------------------------------------
-- 4. SUITE EXECUTION
-----------------------------------------------------------------------

||| Runs complete Trophic Energy Flow Observation Suite.
public export
runTrophicEnergySuite : Bool
runTrophicEnergySuite =
  prop_trophic10PercentTransferLaw &&
  prop_trophicEnergyConserved &&
  prop_dissipatedLagIs990Q
```
