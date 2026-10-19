{
  mkApplication,
  pythonSet,
  workspace,
}:
mkApplication {
  venv = pythonSet.mkVirtualEnv "python-template-env" workspace.deps.default;
  package = pythonSet.python-template;
}
