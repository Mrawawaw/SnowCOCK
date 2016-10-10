#include "SnowcockApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

#include "GBCalcAux.h"
#include "GBICs.h"

template<>
InputParameters validParams<SnowcockApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  params.set<bool>("use_legacy_output_syntax") = false;

  return params;
}

SnowcockApp::SnowcockApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  SnowcockApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  SnowcockApp::associateSyntax(_syntax, _action_factory);
}

SnowcockApp::~SnowcockApp()
{
}

// External entry point for dynamic application loading
extern "C" void SnowcockApp__registerApps() { SnowcockApp::registerApps(); }
void
SnowcockApp::registerApps()
{
  registerApp(SnowcockApp);
}

// External entry point for dynamic object registration
extern "C" void SnowcockApp__registerObjects(Factory & factory) { SnowcockApp::registerObjects(factory); }
void
SnowcockApp::registerObjects(Factory & factory)
{
  registerKernel(GBCalcAux);
  registerInitialCondition(GBICs);
}

// External entry point for dynamic syntax association
extern "C" void SnowcockApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { SnowcockApp::associateSyntax(syntax, action_factory); }
void
SnowcockApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
