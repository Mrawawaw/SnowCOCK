/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef CHEMICALOUTFLOWBC_H
#define CHEMICALOUTFLOWBC_H

#include "IntegratedBC.h"

//Forward Declarations
class GBDiffOutflowBC;

template<>
InputParameters validParams<GBDiffOutflowBC>();

/**
 * Implements a simple constant VectorNeumann BC where grad(u)=value on the boundary.
 * Uses the term produced from integrating the diffusion operator by parts.
 */
class GBDiffOutflowBC : public IntegratedBC
{
public:
  GBDiffOutflowBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  /**
   * Vector to dot with the normal.
   */
  const VariableValue & _diff;
};

#endif //GBDiffOutflowBC_H
