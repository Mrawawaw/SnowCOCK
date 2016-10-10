/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GBICs_H
#define GBICs_H

#include "Kernel.h"
#include "InitialCondition.h"

#include <string>

// Forward Declarations
class GBICs;

template<>
InputParameters validParams<GBICs>();

/**
 * PolycrystalReducedIC creates a polycrystal initial condition.
 * With 2 Grains, _typ = 0 results in a circular inclusion grain and _type = 1 gives a bicrystal.
 * With more than 2 grains, _typ = 0 gives set positions for 6 grains, _type = 1 gives hexagonal grains for 4 grains.
 *                          _typ = 2 Gives a random voronoi structure
*/
class GBICs : public InitialCondition
{
public:
  GBICs(const InputParameters & parameters);
  virtual Real value(const Point & p);

protected:
  Real bnds;

//private:
  Real _MinVal;
  Real _MaxVal;
  Real _bnds;

};

#endif //GBICs_H
