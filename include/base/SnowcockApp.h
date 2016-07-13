#ifndef SNOWCOCKAPP_H
#define SNOWCOCKAPP_H

#include "MooseApp.h"

class SnowcockApp;

template<>
InputParameters validParams<SnowcockApp>();

class SnowcockApp : public MooseApp
{
public:
  SnowcockApp(InputParameters parameters);
  virtual ~SnowcockApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* SNOWCOCKAPP_H */
