/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GBSCALEAUX_H
#define GBSCALEAUX_H

#include "AuxKernel.h"

//Forward Declarations
class GBScaleAux;

template<>
InputParameters validParams<GBScaleAux>();

/**
 * Visualize the location of grain boundaries in a polycrystalline simulation.
 */
class GBScaleAux : public AuxKernel
{
public:
  GBScaleAux(const InputParameters & params);

protected:
  virtual Real computeValue();
  const VariableValue & _bnds;
  //const VariableValue & _bnds;
  //std::vector<const VariableValue *> _bnds;
  Function & _MinFun;
  Function & _MaxFun;

};

#endif //GBScaleAux_H
