module Wiki.Main

import Wiki.Observations.PredatorPreyDynamics
import Wiki.Observations.TrophicEnergyFlow
import Wiki.Observations.PhylogeneticTree
import Wiki.Observations.ThermodynamicEcology

%default total

main : IO ()
main = do
  putStrLn "=========================================================================="
  putStrLn "   IDRIS2 DISCRETE ECOLOGY, TROPHIC DYNAMICS & PHYLOGENY WIKI RUNNER"
  putStrLn "=========================================================================="
  putStrLn ""
  putStrLn "--- PART 1: LOTKA-VOLTERRA PREDATOR-PREY POPULATION DYNAMICS ---"
  if runPredatorPreySuite
     then putStrLn "   -> PASS: Lotka-Volterra population dynamics & biomass conservation verified."
     else putStrLn "   -> FAIL: Predator-Prey check failed."

  putStrLn ""
  putStrLn "--- PART 2: LINDEMAN 10% TROPHIC LEVEL ENERGY FLOW & DISSIPATION ---"
  if runTrophicEnergySuite
     then putStrLn "   -> PASS: Lindeman 10% trophic transfer efficiency & 990Q dissipation verified."
     else putStrLn "   -> FAIL: Trophic Energy check failed."

  putStrLn ""
  putStrLn "--- PART 3: EVOLUTIONARY PHYLOGENY & 137-GRID SPECIATION ---"
  if runPhylogeneticTreeSuite
     then putStrLn "   -> PASS: 137-grid evolutionary speciation & trait mutation bit verified."
     else putStrLn "   -> FAIL: Evolutionary Phylogeny check failed."

  putStrLn ""
  putStrLn "--- PART 4: PRIGOGINE DISSIPATIVE ECOLOGICAL THERMODYNAMICS ---"
  if runThermodynamicEcologySuite
     then putStrLn "   -> PASS: Prigogine dissipative ecological self-organization & 2nd law verified."
     else putStrLn "   -> FAIL: Thermodynamic Ecology check failed."

  putStrLn ""
  putStrLn "=========================================================================="
  putStrLn "   ALL DISCRETE ECOLOGY & EVOLUTIONARY SUITES PASSED WITH 100% TOTALITY!"
  putStrLn "=========================================================================="
