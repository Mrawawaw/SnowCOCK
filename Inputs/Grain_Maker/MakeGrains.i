[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 60
  nz = 0
  xmin = 0
  xmax = 30e3 # nm (30 um)
  ymin = 0
  ymax = 30e3 # nm (30 um)
  zmin = 0
  zmax = 0
  elem_type = QUAD4
[]

[GlobalParams]
  op_num = 4
  var_name_base = grains
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiIC]
      grain_num = 4
    [../]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = GBCalcAux # Custom calculator
    #type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./Nickel]
    type = GBEvolution
    block = 0
    T = 500 # K
    wGB = 500 # nm
    GBmob0 = 2.5e-6 #m^4/(Js) from Schoenfelder 1997
    Q = 0.23 #Migration energy in eV
    GBenergy = 0.708 #GB energy in J/m^2
  [../]
[]

[Postprocessors]
  [./MinVal]
    type = ElementExtremeValue
    block = 0
    execute_on = timestep_end
    value_type = min
    variable = bnds
    outputs = exodus
  [../]
  [./MaxVal]
    type = ElementExtremeValue
    block = 0
    execute_on = timestep_end
    value_type = max
    variable = bnds
    outputs = exodus
  [../]
[]

[Preconditioning]
  active = ''
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 20
  nl_rel_tol = 1.0e-9
  start_time = 0.0
  num_steps = 20
  dt = 1

  #[./Adaptivity]
  #  # Block that turns on mesh adaptivity. Note that mesh will never coarsen beyond initial mesh (before uniform refinement)
  #  initial_adaptivity = 4 # Number of times mesh is adapted to initial condition
  #  refine_fraction = 0.1 # Fraction of high error that will be refined
  #  coarsen_fraction = 0.1 # Fraction of low error that will coarsened
  #  max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #[../]
[]

[Outputs]
  file_base = MakeGrains/BoundaryMap
  exodus = true
[]
