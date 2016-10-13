/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBDiffOutflowBC.h"
#include "Material.h"

template<>
InputParameters validParams<GBDiffOutflowBC>()
{
  InputParameters params = validParams<IntegratedBC>();
  params.addRequiredCoupledVar("Diffusivity_Tensor","Tensor describing the XX diffusivity");
  return params;
}

GBDiffOutflowBC::GBDiffOutflowBC(const InputParameters & parameters) :
    IntegratedBC(parameters),
    //_gb(coupledValue("bnds")),
    //_bulkdiff(getMaterialProperty<Real>("diffusivity")),
    //_bounddiff(getMaterialProperty<Real>("diffusivity")),
    _diff(coupledValue("Diffusivity_Tensor"))
{
}

Real
GBDiffOutflowBC::computeQpResidual()
{
  //Real _diff[_qp] = (_bulkdiff * (1 - _gb[_qp])) + (_bounddiff * _gb[_qp)

  return -_test[_i][_qp] * _diff[_qp] * _grad_u[_qp] * _normals[_qp];
}


Real
GBDiffOutflowBC::computeQpJacobian()
{
  return -_test[_i][_qp] * _diff[_qp] * _grad_phi[_j][_qp] * _normals[_qp];
}
