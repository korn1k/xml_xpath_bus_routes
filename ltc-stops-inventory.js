let xhttp = null;

const LoadDoc = (filename) => {
  if (window.ActiveXObject) {
    xhttp = new ActiveXObject('Msxml2.XMLHTTP');
  } else {
    xhttp = new XMLHttpRequest();
  }

  xhttp.open('GET', filename, false);

  try {
    xhttp.responseType = 'msxml-document';
  } catch (err) {
    console.log(err);
  }

  xhttp.send('');

  return xhttp.responseXML;
};

const FindStops = () => {
  const makeValidRouteNumber = (number) => {
    if (number.toString().length == 0) {
      return -1;
    }

    let xmlNumber = number.toString().split('');
    const zeroesToAdd = 3 - xmlNumber.length;

    if (zeroesToAdd < 0 || zeroesToAdd > 2) {
      return -1;
    }

    const arrOfZeroes = new Array(zeroesToAdd).fill('0');

    xmlNumber = [...arrOfZeroes, ...xmlNumber].join('');

    return xmlNumber;
  };

  const routeNumber =
    document.getElementById('route__number').value &&
    !isNaN(document.getElementById('route__number').value)
      ? makeValidRouteNumber(document.getElementById('route__number').value)
      : -1;

  const streetName = document.getElementById('street__name').value
    ? document.getElementById('street__name').value
    : -1;

  document.getElementById('route__number').value = '';
  document.getElementById('street__name').value = '';

  if (routeNumber) {
    const xml = LoadDoc('ltc-stops-inventory.xml');
    const xslt = LoadDoc('ltc-stops-inventory.xslt');

    if (window.ActiveXObject || xhttp.responseType == 'msxml-document') {
      const template = new ActiveXObject('Msxml2.XslTemplate.6.0');
      template.stylesheet = xslt;

      const proc = template.createProcessor();
      proc.input = xml;

      if (routeNumber == -1 && !(streetName == -1)) {
        proc.addParameter('streetName', streetName);
      } else if (streetName == -1 && !(routeNumber == -1)) {
        proc.addParameter('routeNumber', routeNumber);
      } else if (!(routeNumber == -1) && !(streetName == -1)) {
        proc.addParameter('routeNumber', routeNumber);
        proc.addParameter('streetName', streetName);
      } else {
        alert('Please fill out the fields!');
      }

      proc.transform();

      document.getElementById('general__output').innerHTML = proc.output;
    } else if (typeof XSLTProcessor !== 'undefined') {
      const xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xslt);

      if (routeNumber == -1 && !(streetName == -1)) {
        xsltProcessor.setParameter(null, 'streetName', streetName);
      } else if (streetName == -1 && !(routeNumber == -1)) {
        xsltProcessor.setParameter(null, 'routeNumber', routeNumber);
      } else if (routeNumber == -1 && streetName == -1) {
        console.log('No pass');
      } else {
        xsltProcessor.setParameter(null, 'routeNumber', routeNumber);
        xsltProcessor.setParameter(null, 'streetName', streetName);
      }

      const resultDocument = xsltProcessor.transformToFragment(xml, document);

      document.getElementById('general__output').innerHTML = '';
      document.getElementById('general__output').appendChild(resultDocument);
    }
  } else if (routeNumber == -1) {
    alert('Could you change numbers to xxx (ex. 002, 025)');
  }
};
