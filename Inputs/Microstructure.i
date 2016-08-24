[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  nz = 0
  xmin = 0
  xmax = 50
  ymin = 0
  ymax = 50
  zmin = 0
  zmax = 0
  elem_type = QUAD4
[]

[GlobalParams]
  op_num = 5 #Order parameter number
  var_name_base = gr
[]

[Variables]
  [./PolycrystalVariables]
  [../]

  [./c]
    [./InitialCondition]
      type = SmoothCircleIC
      x1 = 0.0
      y1 = 0.0
      radius = 3
      int_width = 1
      invalue = 1
      outvalue = 0
    [../]
  [../]

  [./mu]
  [../]
  [./jx]
  [../]
  [./jy]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiIC]
      grain_num = 5 #Number of grains
    [../]
  [../]
[]

[AuxVariables]
  [./gb]
    family = LAGRANGE
    order  = FIRST
  [../]
  [./mobility_xx]
    family = MONOMIAL
    order  = CONSTANT
  [../]
  [./mobility_yy]
    family = MONOMIAL
    order  = CONSTANT
  [../]
  [./diffusivity_xx]
    family = MONOMIAL
    order  = CONSTANT
  [../]
  [./diffusivity_yy]
    family = MONOMIAL
    order  = CONSTANT
  [../]
  [./aniso_tensor_xx]
    family = MONOMIAL
    order  = CONSTANT
  [../]
  [./aniso_tensor_yy]
    family = MONOMIAL
    order  = CONSTANT
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
     #Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
  [../]

  [./conc]
    type = CHSplitConcentration
    variable = c
    mobility = mobility_prop
    chemical_potential_var = mu
  [../]
  [./chempot]
    type = CHSplitChemicalPotential
    variable = mu
    chemical_potential_prop = mu_prop
    c = c
  [../]
  [./flux_x]
    type = CHSplitFlux
    variable = jx
    component = 0
    mobility_name = mobility_prop
    mu = mu
    c = c
  [../]
  [./flux_y]
    type = CHSplitFlux
    variable = jy
    component = 1
    mobility_name = mobility_prop
    mu = mu
    c = c
  [../]
  [./time]
    type = TimeDerivative
    variable = c
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = gb
    execute_on = timestep_end
  [../]

  [./mobility_xx]
    type = MaterialRealTensorValueAux
    variable = mobility_xx
    property = mobility_prop
    row = 0
    column = 0
  [../]
  [./mobility_yy]
    type = MaterialRealTensorValueAux
    variable = mobility_yy
    property = mobility_prop
    row = 1
    column = 1
  [../]
  [./diffusivity_xx]
    type = MaterialRealTensorValueAux
    variable = diffusivity_xx
    property = diffusivity
    row = 0
    column = 0
  [../]
  [./diffusivity_yy]
    type = MaterialRealTensorValueAux
    variable = diffusivity_yy
    property = diffusivity
    row = 1
    column = 1
  [../]
  [./aniso_tensor_xx]
    type = MaterialRealTensorValueAux
    variable = aniso_tensor_xx
    property = aniso_tensor
    row = 0
    column = 0
  [../]
  [./aniso_tensor_yy]
    type = MaterialRealTensorValueAux
    variable = aniso_tensor_yy
    property = aniso_tensor
    row = 1
    column = 1
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]

  #[./left]
  #  type = DirichletBC
  #  variable = 'c'
  #  boundary = 'left'
  #  value = 1
  #[../]
  #[./right]
  #  type = DirichletBC
  #  variable = 'c'
  #  boundary = 'left'
  #  value = 0
  #[../]
[]

[Materials]
  [./chemical_potential]
    type = DerivativeParsedMaterial
    block = 0
    f_name = mu_prop
    args = c
    function = 'c'
    derivative_order = 1
  [../]
  [./var_dependence]
    type = DerivativeParsedMaterial
    block = 0
    function = 'c*(1.0-c)'
    args = c
    f_name = var_dep
    derivative_order = 1
  [../]
  [./mobility]
    type = CompositeMobilityTensor
    block = 0
    M_name = mobility_prop
    tensors = diffusivity
    weights = var_dep
    args = c
  [../]
  [./phase_normal]
    type = PhaseNormalTensor
    phase = gb
    normal_tensor_name = gb_normal
  [../]
  [./aniso_tensor]
    type = GBDependentAnisotropicTensor
    gb = gb
    bulk_parameter = 0.1
    gb_parameter = 1
    gb_normal_tensor_name = gb_normal
    gb_tensor_prop_name = aniso_tensor
  [../]
  [./diffusivity]
    type = GBDependentDiffusivity
    gb = gb
    bulk_parameter = 0.1
    gb_parameter = 1
    gb_normal_tensor_name = gb_normal
    gb_tensor_prop_name = diffusivity
  [../]

  [./NiGrGr]
    # Material properties
    type = GBEvolution # Quantitative material properties for copper grain growth.  Dimensions are nm and ns
    block = 0 # Block ID (only one block in this problem)
    GBmob0 = 2.5e-6 # Mobility prefactor for Ni
    GBenergy = 0.708 # GB energy for Ni
    Q = 500 #0.23 # Activation energy for grain growth - set absurdly high to 'freeze' boundaries
    T = 300 # K   #Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # nm      #Width of the diffuse GB
  [../]
[]

[Postprocessors]
  [./dt]
    # Outputs the current time step
    type = TimestepSize
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly       lu           1'

  #solve_type = 'NEWTON'
  #scheme = bdf
  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu'

  l_max_its = 30 # Max number of linear iterations
  l_tol = 1.0e-4 # Relative tolerance for linear solves
  nl_max_its = 50 # Max number of nonlinear iterations
  nl_abs_tol = 1e-11 # Relative tolerance for nonlienar solves
  nl_rel_tol = 1e-8 # Absolute tolerance for nonlienar solves

  dt = 1.0
  num_steps = 20
  #start_time = 0.0
  #end_time = 75000

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 25 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  [../]
  [./Adaptivity]
    # Block that turns on mesh adaptivity. Note that mesh will never coarsen beyond initial mesh (before uniform refinement)
    initial_adaptivity = 4 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  [../]
[]

[Outputs]
  exodus = true
[]
