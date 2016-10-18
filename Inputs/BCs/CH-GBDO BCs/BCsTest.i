[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 5
  xmin = 0
  xmax = 20
  ymin = 0
  ymax = 5
[]

[Variables]
  [./c]
    initial_condition = 0.0
  [../]
  [./mu]
  [../]
[]

[AuxVariables]
  [./gb]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 1.0
  [../]
  [./mobility_xx]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./mobility_yy]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./diffusivity_xx]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./diffusivity_yy]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./aniso_tensor_xx]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./aniso_tensor_yy]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[Kernels]
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
  [./time]
    type = TimeDerivative
    variable = c
  [../]
[]

[AuxKernels]
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

[Materials]
  [./chemical_potential]
    type = DerivativeParsedMaterial
    block = 0
    f_name = mu_prop
    args = c
    function = c
    derivative_order = 1
  [../]
  [./var_dependence]
    type = DerivativeParsedMaterial
    block = 0
    function = c*(1.0-c)
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
    bulk_parameter = 0.0088299 # nm2/s at 330*C (8.82993e-21 m^2/s)
    gb_parameter = 219.60800 # nm2/s at 330*C (2.19608e-16 m^2/s)
    gb_normal_tensor_name = gb_normal
    gb_tensor_prop_name = aniso_tensor
  [../]
  [./diffusivity]
    type = GBDependentDiffusivity
    gb = gb
    bulk_parameter = 0.0088299 # nm2/s at 330*C (8.82993e-21 m^2/s)
    gb_parameter = 219.60800 # nm2/s at 330*C (2.19608e-16 m^2/s)
    gb_normal_tensor_name = gb_normal
    gb_tensor_prop_name = diffusivity
  [../]
[]

[BCs]
  [./in_flux]
    type = CahnHilliardFluxBC
    variable = c
    boundary = left
    flux = '0.05 0 0'
    #mob_name = M
    #args = 'c d'
  [../]
  #[./out_flux]
  #  type = CahnHilliardFluxBC
  #  variable = c
  #  boundary = right
  #  flux = '0 0 0' # This allows exhaust flux where necessary, but won't 'pull' concentration
    #mob_name = M
    #args = 'c d'
  #[../]
  [./out_flux]
    type = GBDiffOutflowBC
    variable = c
    Diffusivity_Tensor = diffusivity_xx
    boundary = right
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 1e-2 # Initial time step.  In this simulation it changes.
   optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  [../]

  type = Transient
  num_steps = 10000
  #dt = 1e-2
  #solve_type = PJFNK
  solve_type = Newton
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly       lu           1'
  l_tol = 1e-3
  l_max_its = 20
  nl_max_its = 5
[]

[Outputs]
  exodus = true
  file_base = BCTest
[]
