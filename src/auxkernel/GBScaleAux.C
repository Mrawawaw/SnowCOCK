/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBScaleAux.h"
#include "Function.h"

#include "NonlinearSystem.h"
#include "MooseMesh.h"

#include "libmesh/numeric_vector.h"
#include "libmesh/utility.h"

#include <cmath>
#include "float.h"

template<>
InputParameters validParams<GBScaleAux>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription("Scale the calculated grain boundary map.");
  params.addRequiredCoupledVar("inbnds","The boundary map.");
  params.addRequiredParam<FunctionName>("MinFunction", "The minimum forcing function.");
  params.addRequiredParam<FunctionName>("MaxFunction", "The maximum forcing function.");
  return params;
}

GBScaleAux::GBScaleAux(const InputParameters & params) :
    AuxKernel(params),
    _bnds(coupledValue("inbnds")),
    //_bnds(coupledComponents("inbnds")),
    _MinFun(getFunction("MinFunction")),
    _MaxFun(getFunction("MaxFunction"))
{
}

Real
GBScaleAux::computeValue()
{
  //Method 1 (doesn't work)
  //Real _MinVal = GatherMin(value);
  //Real _MaxVal = GatherMax(value);

  //Method 2 (doesn't work)
  //Real _MinVal = _communicator.min(value);
  //Real _MaxVal = _communicator.max(value);

  // Method 3
  double *_MinVal = new double[_qp];
  _MinVal[_qp] = {1.0};
  _MinVal[_qp] = _MinVal[_qp] * _MinFun.value(_t, _q_point[_qp]);

  double *_MaxVal = new double[_qp];
  _MaxVal[_qp] = {1.0};
  _MaxVal[_qp] = _MaxVal[_qp] * _MaxFun.value(_t, _q_point[_qp]);

  //Scale to use 0 -> 1 range
  return (_bnds[_qp] - _MinVal[_qp]) * (1/_MaxVal[_qp]);
}
