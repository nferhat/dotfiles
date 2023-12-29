{
  lib,
  python311Packages,
  fetchPypi,
}:
python311Packages.buildPythonPackage rec {
  pname = "mons";
  version = "2.0.0";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "E1yBTwZ4T2C3sXoLGz0kAcvas0q8tO6Aaiz3SHrT4ZE=";
  };

  nativeCheckInputs = [];
  nativeBuildInputs = [python311Packages.setuptools-scm];

  propagatedBuildInputs = with python311Packages; [
    dnfile
    pefile
    click
    tqdm
    xxhash
    pyyaml
    urllib3
    platformdirs
    setuptools
    # Only required for python 3.9 and below
    # typing_extensions
    # importlib-resources
  ];

  meta = {
    description = "Command-Line Installer and Manager for Celeste Modding";
    homepage = "https://github.com/coloursofnoise/mons";
    license = lib.licenses.mit;
  };
}
