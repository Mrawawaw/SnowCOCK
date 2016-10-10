/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBICs.h"

#include "IndirectSort.h"
#include "MooseRandom.h"
#include "MooseMesh.h"

template<>
InputParameters validParams<GBICs>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addClassDescription("Calculate location of grain boundaries in a polycrystalline sample");
  params.addRequiredParam<Real>("MinVal", "Minimum value in the map");
  params.addRequiredParam<Real>("MaxVal", "Maximum value in the map");
  params.addRequiredParam<Real>("bnds", "Grain boundary map");
  return params;
}

GBICs::GBICs(const InputParameters & parameters) :
    InitialCondition(parameters),
    _MinVal(getParam<Real>("MinVal")),
    _MaxVal(getParam<Real>("MaxVal")),
    _bnds(getParam<Real>("bnds"))
{
}

Real
GBICs::value(const Point & p)
{

  //_MinVal = _MinVal * -1.0 + 1.0;
  //_MaxVal = _MaxVal * -1.0 + 1.0;

  //Scales to use full range of 0 -> 1
  _bnds = _bnds - _MinVal;
  _bnds = _bnds * (1/_MaxVal);

  return _bnds;
}
