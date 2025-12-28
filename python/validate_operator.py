from pathlib import Path

import xmlschema
from lxml import etree

# Resolve paths relative to the project root so the script works from any CWD.
ROOT = Path(__file__).resolve().parent.parent
XSD_PATH = ROOT / "schemas" / "xml" / "operator.xsd"
XML_PATH = ROOT / "data" / "operator.xml"


def validate_with_xmlschema():
    """Primary validation with xmlschema."""
    schema = xmlschema.XMLSchema(str(XSD_PATH))
    schema.validate(str(XML_PATH))
    print(f"XML is valid against {XSD_PATH} (xmlschema).")


def validate_with_lxml():
    """Secondary validation with lxml to inspect the error log."""
    xsd_doc = etree.parse(str(XSD_PATH))
    xsd = etree.XMLSchema(xsd_doc)
    xml_doc = etree.parse(str(XML_PATH))

    if xsd.validate(xml_doc):
        print(f"XML is valid against {XSD_PATH} (lxml).")
    else:
        print("lxml validation errors:")
        for error in xsd.error_log:
            print(f"- {error}")


def main():
    try:
        validate_with_xmlschema()
    except xmlschema.XMLSchemaValidationError as e:
        print("XML is not valid:")
        print(f"- {e}")
        for error in xmlschema.XMLSchema(str(XSD_PATH)).iter_errors(str(XML_PATH)):
            print(f"- {error}")
        return
    except Exception as e:
        print(f"xmlschema validation failed: {e}")
        return

    try:
        validate_with_lxml()
    except Exception as e:
        print(f"lxml validation failed: {e}")


if __name__ == "__main__":
    main()
