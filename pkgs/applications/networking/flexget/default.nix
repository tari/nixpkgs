{ lib
, fetchFromGitHub
, python
, transmission
, deluge
, config
}:

with python.pkgs;

buildPythonApplication rec {
  version = "2.12.0";
  name = "FlexGet-${version}";

  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = version;
    sha256 = "0yilhvi0579n7yblqykzmccrs36sjzj0vdz117pfvf07rbkf965p";
  };

  doCheck = true;
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.3" "chardet" \
      --replace "rebulk==0.8.2" "rebulk" \
      --replace "cherrypy==10.2.2" "cherrypy" \
      --replace "portend==1.8" "portend" \
      --replace "sqlalchemy==1.1.10" "sqlalchemy" \
      --replace "zxcvbn-python==4.4.15" "zxcvbn-python" \
      --replace "flask-cors==3.0.2" "flask-cors" \
      --replace "certifi==2017.4.17" "certifi" \
      --replace "apscheduler==3.5.0" "apscheduler" \
      --replace "path.py==10.3.1" "path.py" \
      --replace "tempora==1.8" "tempora" \
      --replace "cheroot==5.5.0" "cheroot" \
      --replace "six==1.10.0" "six" \
      --replace "aniso8601==1.2.1" "aniso8601" \
      --replace "werkzeug==0.12.2" "werkzeug" \
      --replace "tzlocal==1.4" "tzlocal" \
      --replace "html5lib==0.999999999" "html5lib" \
      --replace "plumbum==1.6.3" "plumbum" \
      --replace "idna==2.5" "idna" \
      --replace "requests==2.16.5" "requests" \
      --replace "urllib3==1.21.1" "urllib3"
  '';

  checkPhase = ''
    export HOME=.
    py.test --disable-pytest-warnings -k ""
  '';

  buildInputs = [ pytest mock vcrpy boto3 ];
  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml chardet
    beautifulsoup4 html5lib PyRSS2Gen pynzb
    rpyc jinja2 jsonschema requests dateutil jsonschema
    pathpy guessit_2_0 APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful flask-restplus
    flask-compress flask_login flask-cors
    pyparsing safe future zxcvbn-python
    werkzeug tempora cheroot rebulk portend
  ] ++ lib.optional (pythonOlder "3.4") pathlib
    # enable deluge and transmission plugin support, if they're installed
    ++ lib.optional (config.deluge or false) deluge
    ++ lib.optional (transmission != null) transmissionrpc;

  meta = {
    homepage = https://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar tari ];
  };
}
