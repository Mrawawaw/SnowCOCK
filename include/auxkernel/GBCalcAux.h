/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GBCALCAUX_H
#define GBCALCAUX_H

#include "AuxKernel.h"

//Forward Declarations
class GBCalcAux;

template<>
InputParameters validParams<GBCalcAux>();

/**
 * Visualize the location of grain boundaries in a polycrystalline simulation.
 */
class GBCalcAux : public AuxKernel
{
public:
  GBCalcAux(const InputParameters & parameters);

protected:
  virtual Real computeValue();

  unsigned int _ncrys;
  std::vector<const VariableValue *> _vals;

//private:
  Real MinVal;
  Real MaxVal;

};

#endif //GBCALCAUX_H
