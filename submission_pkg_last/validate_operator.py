import xmlschema
from lxml import etree

XSD_PATH = "operator.xsd"
XML_PATH = "operator.xml"


def validate_with_xmlschema():
    """Primary validation with xmlschema."""
    schema = xmlschema.XMLSchema(XSD_PATH)
    schema.validate(XML_PATH)
    print("XML is valid against operator.xsd (xmlschema).")


def validate_with_lxml():
    """Secondary validation with lxml to inspect the error log."""
    xsd_doc = etree.parse(XSD_PATH)
    xsd = etree.XMLSchema(xsd_doc)
    xml_doc = etree.parse(XML_PATH)

    if xsd.validate(xml_doc):
        print("XML is valid against operator.xsd (lxml).")
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
        for error in xmlschema.XMLSchema(XSD_PATH).iter_errors(XML_PATH):
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
