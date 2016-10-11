/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBCalcAux.h"

template<>
InputParameters validParams<GBCalcAux>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription("Calculate location of grain boundaries in a polycrystalline sample");
  params.addRequiredCoupledVarWithAutoBuild("v", "var_name_base", "op_num", "Array of coupled variables");
  return params;
}

GBCalcAux::GBCalcAux(const InputParameters & params) :
    AuxKernel(params),
    _ncrys(coupledComponents("v")),
    _vals(_ncrys)
{
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _vals[i] = &coupledValue("v", i);
  }
}

Real
GBCalcAux::computeValue()
{
  Real value = 0.0;

  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    value += (*_vals[i])[_qp] * (*_vals[i])[_qp];
  }

  //Flips the GB map upside down (0 = matrix, 1 = boundaries)
  value = value * -1.0 + 1.0;

  return value;
}
