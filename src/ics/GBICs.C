/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBICs.h"

template<>
InputParameters validParams<GBICs>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription("Calculate location of grain boundaries in a polycrystalline sample");
  params.addRequiredParam<unsigned int>("MinVal", "Minimum value in the map");
  params.addRequiredParam<unsigned int>("MaxVal", "Maximum value in the map");
  params.addRequiredParam<unsigned int>("bnds", "Grain boundary map");
  return params;
}

GBICs::GBICs(const InputParameters & parameters) :
    Action(params),
    _MinVal(getParam<Real>("MinVal"))
    _MaxVal(getParam<Real>("MaxVal"))
    _bnds(getParam<Real Array>("bnds"))
}

Real
GBICs::act()
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
